//
//  CharacterProgressDataArchiver.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 22/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CharacterProgressDataArchiver.h"
#import "SkillSet.h"
#import "Skill.h"
#import "SkillTemplate.h"
#import "SkillManager.h"
#import <objc/runtime.h>

@interface CharacterProgressDataArchiver()

@end

@implementation CharacterProgressDataArchiver

+(CharacterProgressDataArchiver *)newCharacterWithDocPath:(NSString *)docPath
       withConflictResolverController:(id<CharacterProgressArchiverProtocol>)controller
                          withContext:(NSManagedObjectContext *)context
{
    CharacterProgressDataArchiver *characterArchiver = [CharacterProgressDataArchiver new];
    NSDictionary *codedData = [[NSDictionary alloc] initWithContentsOfFile:docPath]; //was NSData
    if (codedData) {
        //        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
        //        skillTemplateDisk = [decoder decodeObjectForKey:defaultTitle];
        //        [decoder finishDecoding];
        
        characterArchiver = [CharacterProgressDataArchiver objectWithKeysOfDictionary:codedData];
        
        NSArray *existingCharacter = [Character fetchCharacterWithId:characterArchiver.characterId withContext:context];
        
        Character *character;
        if (existingCharacter && existingCharacter.count) {
            character = existingCharacter.lastObject;
            
            //check time stemps to allow user manually handle charcter skill modification;
            if (controller) {
                characterArchiver.delegate = controller;
                if (![characterArchiver.delegate shouldReplaceCharacterProgress:character]) {
                    return characterArchiver;
                }
            }
        }
        else {
            character = [Character newCharacterWithContext:context];
        }
        
        [characterArchiver updateCharacter:character withContext:context];
        
        return characterArchiver;
    }
    
    return nil;

}

-(void)updateCharacter:(Character *)character withContext:(NSManagedObjectContext *)context
{
    [[SkillManager sharedInstance] checkAllCharacterCoreSkills:character];
    
    for (NSString *key in [self.skillExperienceDictionary allKeys]) {
        NSArray *existingTemplate = [SkillTemplate fetchSkillTemplateForName:key withContext:context];
        if (existingTemplate && existingTemplate.count) {
            NSString *xpPointsString = [self.skillExperienceDictionary valueForKey:key];
            SkillTemplate *template = existingTemplate.lastObject;
            Skill *skill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:template withCharacter:character];
            skill.currentLevel = 0;
            skill.currentProgress = xpPointsString.floatValue;
        
            [[SkillManager sharedInstance] calculateAddingXpPointsForSkill:skill];
        }
    }
    
    [Character saveContext:context];
}

+(void)saveData:(Character *)character toPath:(NSString *)docPath;
{
    CharacterProgressDataArchiver *charcterArchiver = [CharacterProgressDataArchiver new];
    charcterArchiver.characterId = character.characterId;
    charcterArchiver.characterName = character.name;
    charcterArchiver.dateModified = character.dateModifed;
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    for (Skill *skill in character.skillSet.skills) {
        if (skill.currentProgress || skill.currentLevel) {
            NSString *key = skill.skillTemplate.name;
            float valueFloat = [[SkillManager sharedInstance] countXpSpentOnSkillWithTemplate:skill.skillTemplate forCharacter:character];
            [dict setValue:[NSString stringWithFormat:@"%f",valueFloat] forKey:key];
        }
    }
    charcterArchiver.skillExperienceDictionary = dict;
    
    BOOL success;
    if (docPath) {
        if ([CharacterProgressDataArchiver createDataPathWith:docPath]) {
            NSString *filePath = [docPath stringByAppendingString: [NSString stringWithFormat:@"/%@.plist",charcterArchiver.characterId]];
            
            //            NSMutableData *data = [NSMutableData new];
            //            NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            //            [encoder encodeObject:skillTemplateDisk forKey:defaultTitle];
            //            [encoder finishEncoding];
            //            success = [data writeToFile:filePath atomically:true];
            
            NSDictionary *dictinary = [CharacterProgressDataArchiver dictionaryWithPropertiesOfObject:charcterArchiver];
            success = [dictinary writeToFile:filePath atomically:true];
            
            if (success) {
                NSLog(@"successfully saved");
            }
        }
    }
}

+(BOOL)createDataPathWith:(NSString *)dataPath
{
    if (dataPath) {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:true attributes:nil error:&error];
        if (success) {
            return true;
        }
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return false;
}


+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"CharacterArchives"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

+(NSDictionary *)dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [obj valueForKey:key];
        if (value) {
            [dict setObject:[obj valueForKey:key] forKey:key];
        }
    }
    free(properties);
    return [NSDictionary dictionaryWithDictionary:dict];
}

+(CharacterProgressDataArchiver *)objectWithKeysOfDictionary:(NSDictionary *)dictionary;
{
    CharacterProgressDataArchiver *characterArchiver = [CharacterProgressDataArchiver new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [characterArchiver setValue:obj forKey:(NSString *)key];
    }];
    
    return characterArchiver;
}


#pragma mark NSCoding

#define kid   @"id"
#define kname @"name"
#define kskillDict @"skillExperience"
#define kdateModified @"dateModified"

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.characterId forKey:kid];
    [encoder encodeObject:self.characterName forKey:kname];
    [encoder encodeDouble:self.dateModified forKey:kdateModified];
    [encoder encodeObject:self.skillExperienceDictionary forKey:kskillDict];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self.characterId = [decoder decodeObjectForKey:kid];
    self.characterName = [decoder decodeObjectForKey:kname];
    self.dateModified = [decoder decodeDoubleForKey:kdateModified];
    self.skillExperienceDictionary = [decoder decodeObjectForKey:kskillDict];
    
    return self;
}

@end
