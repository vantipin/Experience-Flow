//
//  CharacterProgressDataArchiver.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 22/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CharacterDataArchiver.h"
#import "SkillSet.h"
#import "Skill.h"
#import "SkillTemplate.h"
#import "SkillManager.h"
#import <objc/runtime.h>

@interface CharacterDataArchiver()

@property (nonatomic) NSString *characterId;
@property (nonatomic) NSString *characterName;
@property (nonatomic) NSTimeInterval dateModified;
@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic) NSDictionary *skillExperienceDictionary;

@end

@implementation CharacterDataArchiver

+(NSData *)chracterToDictionaryData:(Character *)character;
{
    CharacterDataArchiver *charcterArchiver = [CharacterDataArchiver new];
    charcterArchiver.characterId = character.characterId;
    charcterArchiver.characterName = character.name;
    charcterArchiver.dateModified = character.dateModifed;
    charcterArchiver.dateCreated = character.dateCreated;
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    for (Skill *skill in character.skillSet.skills) {
        if (skill.currentProgress || skill.currentLevel) {
            NSString *key = skill.skillTemplate.name;
            float valueFloat = [[SkillManager sharedInstance] countXpSpentOnSkillWithTemplate:skill.skillTemplate forCharacter:character];
            [dict setValue:[NSString stringWithFormat:@"%f",valueFloat] forKey:key];
        }
    }
    
    charcterArchiver.skillExperienceDictionary = dict;
    NSDictionary *characterDictionary = [CharacterDataArchiver dictionaryWithPropertiesOfObject:charcterArchiver];
    NSData *result = [NSKeyedArchiver archivedDataWithRootObject:characterDictionary];
    return result;
}


+(void)loadCharacterFromDictionaryData:(NSData *)archive withContext:(NSManagedObjectContext *)context;
{
    NSDictionary *dictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:archive];
    
    CharacterDataArchiver *characterArchiver = [CharacterDataArchiver new];
    characterArchiver = [CharacterDataArchiver objectWithKeysOfDictionary:dictionary];
    
    NSArray *existingCharacter = [Character fetchCharacterWithId:characterArchiver.characterId withContext:context];
    
    Character *character;
    if (existingCharacter && existingCharacter.count) {
        character = existingCharacter.lastObject;
    }
    else {
        character = [Character newCharacterWithContext:context];
        character.characterFinished = true;
    }
    
    character.characterId = characterArchiver.characterId;
    character.name = characterArchiver.characterName;
    character.dateModifed = characterArchiver.dateModified;
    character.dateCreated = characterArchiver.dateCreated;

    [[SkillManager sharedInstance] checkAllCharacterCoreSkills:character];
    
    for (NSString *key in [characterArchiver.skillExperienceDictionary allKeys]) {
        NSArray *existingTemplate = [SkillTemplate fetchSkillTemplateForName:key withContext:context];
        if (existingTemplate && existingTemplate.count) {
            NSString *xpPointsString = [characterArchiver.skillExperienceDictionary valueForKey:key];
            SkillTemplate *template = existingTemplate.lastObject;
            Skill *skill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:template withCharacter:character];
            skill.currentLevel = 0;
            skill.currentProgress = xpPointsString.floatValue;
            
            [[SkillManager sharedInstance] calculateAddingXpPointsForSkill:skill];
        }
    }
    
    [Character saveContext:context];
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

+(CharacterDataArchiver *)objectWithKeysOfDictionary:(NSDictionary *)dictionary;
{
    CharacterDataArchiver *characterArchiver = [CharacterDataArchiver new];
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
