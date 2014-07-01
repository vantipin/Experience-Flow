//
//  SkillTemplateDiskData.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 07.05.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "SkillTemplateDiskData.h"
#import "MainContextObject.h"
#import <objc/runtime.h>

#define defaultTitle @"SkillTemplate"
#define defaultDataFile @"SkillTemplate.plist"

@implementation SkillTemplateDiskData

+(SkillTemplate *)newSkillTemplateWithDocPath:(NSString *)docPath withContext:(NSManagedObjectContext *)context;
{
    SkillTemplateDiskData *skillTemplateDisk = [SkillTemplateDiskData new];
    NSDictionary *codedData = [[NSDictionary alloc] initWithContentsOfFile:docPath]; //was NSData
    if (codedData) {
//        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
//        skillTemplateDisk = [decoder decodeObjectForKey:defaultTitle];
//        [decoder finishDecoding];
        
        
        skillTemplateDisk = [SkillTemplateDiskData objectWithKeysOfDictionary:codedData];
        
        SkillTemplate *skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:skillTemplateDisk.name
                                                                         withRules:skillTemplateDisk.skillRules
                                                                 withRulesExamples:skillTemplateDisk.skillRulesExamples
                                                                   withDescription:skillTemplateDisk.skillDescription
                                                                     withSkillIcon:nil
                                                                withBasicXpBarrier:skillTemplateDisk.levelBasicBarrier
                                                              withSkillProgression:skillTemplateDisk.levelProgression
                                                          withBasicSkillGrowthGoes:skillTemplateDisk.levelGrowthGoesToBasicSkill
                                                                     withSkillType:skillTemplateDisk.skillEnumType
                                                            withDefaultStartingLvl:skillTemplateDisk.defaultLevel
                                                           withParentSkillTemplate:nil
                                                                       withContext:context];
        
        if (skillTemplateDisk.nameForBasicSkillTemplate) {
            NSArray *existingBasicSkill = [SkillTemplate fetchSkillTemplateForName:skillTemplateDisk.nameForBasicSkillTemplate withContext:context];
            if (existingBasicSkill && existingBasicSkill.count != 0) {
                SkillTemplate *basicSkill = [existingBasicSkill lastObject];
                skillTemplate.basicSkillTemplate = basicSkill;
                [basicSkill addSubSkillsTemplateObject:skillTemplate];
            }
        }
        
        if (skillTemplateDisk.namesForSubSkillTemplates) {
            for (NSString *skillName in skillTemplateDisk.namesForSubSkillTemplates) {
                NSArray *existingSubSkill = [SkillTemplate fetchSkillTemplateForName:skillName withContext:context];
                if (existingSubSkill && existingSubSkill.count != 0) {
                    SkillTemplate *subSkill = [existingSubSkill lastObject];
                    [skillTemplate addSubSkillsTemplateObject:subSkill];
                    
                    if (subSkill.basicSkillTemplate) {
                        [subSkill.basicSkillTemplate removeSubSkillsTemplateObject:subSkill];
                    }
                    subSkill.basicSkillTemplate = skillTemplate;
                }
            }
        }
        
        [SkillTemplate saveContext:context];
        
        return skillTemplate;
    }
    
    return nil;
}

+(void)saveData:(SkillTemplate *)skillTemplate toPath:(NSString *)docPath;
{
    SkillTemplateDiskData *skillTemplateDisk = [SkillTemplateDiskData new];
    skillTemplateDisk.name = skillTemplate.name;
    skillTemplateDisk.skillEnumType = skillTemplate.skillEnumType;
    skillTemplateDisk.skillDescription = skillTemplate.skillDescription;
    skillTemplateDisk.skillRules = skillTemplate.skillRules;
    skillTemplateDisk.skillRulesExamples = skillTemplate.skillRulesExamples;
    skillTemplateDisk.defaultLevel = skillTemplate.defaultLevel;
    skillTemplateDisk.levelBasicBarrier = skillTemplate.levelBasicBarrier;
    skillTemplateDisk.levelGrowthGoesToBasicSkill = skillTemplate.levelGrowthGoesToBasicSkill;
    skillTemplateDisk.levelProgression = skillTemplate.levelProgression;
    skillTemplateDisk.nameForBasicSkillTemplate = skillTemplate.basicSkillTemplate.name;
    
    NSMutableArray *array = [NSMutableArray new];
    for (SkillTemplate *subSkill in skillTemplate.subSkillsTemplate) {
        [array addObject:subSkill.name];
    }
    skillTemplateDisk.namesForSubSkillTemplates = [NSArray arrayWithArray:array];
    
    BOOL success;
    if (docPath) {
        if ([SkillTemplateDiskData createDataPathWith:docPath]) {
            NSString *filePath = [docPath stringByAppendingString: [NSString stringWithFormat:@"/%@.plist",skillTemplateDisk.name]];
            
//            NSMutableData *data = [NSMutableData new];
//            NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//            [encoder encodeObject:skillTemplateDisk forKey:defaultTitle];
//            [encoder finishEncoding];
//            success = [data writeToFile:filePath atomically:true];
            
            NSDictionary *dictinary = [SkillTemplateDiskData dictionaryWithPropertiesOfObject:skillTemplateDisk];
            success = [dictinary writeToFile:filePath atomically:true];
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

+(void)deleteDocToPath:(NSString *)docPath
{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
}


+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Skill Templates"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

+(NSMutableArray *)loadSkillTemplates
{
    NSString *documentsDirectory = [SkillTemplateDiskData getPrivateDocsDir];
    NSLog(@"Loading bugs from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (!files) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    //create files
    NSMutableArray *retval = [NSMutableArray new];
    for (NSString *file in files) {
        NSString *path = [[SkillTemplateDiskData getPrivateDocsDir] stringByAppendingString:[NSString stringWithFormat:@"/%@",file]];
        SkillTemplate *skillTemplate = [SkillTemplateDiskData newSkillTemplateWithDocPath:path withContext:[MainContextObject sharedInstance].managedObjectContext];
        if (skillTemplate) {
            [retval addObject:skillTemplate];
        }
    }
    
    return retval;
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

+(SkillTemplateDiskData *)objectWithKeysOfDictionary:(NSDictionary *)dictionary;
{
    SkillTemplateDiskData *skillTemplateDiskData = [SkillTemplateDiskData new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [skillTemplateDiskData setValue:obj forKey:(NSString *)key];
    }];
    
    return skillTemplateDiskData;
}


#pragma mark NSCoding

#define kname @"name"
#define kskillEnumType @"skillEnumType"
#define kskillDescription @"skillDescription"
#define kskillRulesExamples @"skillRulesExamples"
#define kskillRules @"skillRules"
#define kskillStartingLvl @"skillStartingLvl"
#define klevelBasicBarrier @"levelBasicBarrier"
#define klevelProgression @"levelProgression"
#define klevelGrowthGoesToBasicSkill @"levelGrowthGoesToBasicSkill"
#define kskillsFromThisTemplate @"skillsFromThisTemplate"
#define kbasicSkillTemplate @"basicSkillTemplate"
#define ksubSkillsTemplate @"subSkillsTemplate"
#define kicon @"icon"

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:kname];
    [encoder encodeInt:self.skillEnumType forKey:kskillEnumType];
    [encoder encodeObject:self.skillDescription forKey:kskillDescription];
    [encoder encodeObject:self.skillRulesExamples forKey:kskillRulesExamples];
    [encoder encodeObject:self.skillRules forKey:kskillRules];
    [encoder encodeInt:self.defaultLevel forKey:kskillStartingLvl];
    [encoder encodeFloat:self.levelBasicBarrier forKey:klevelBasicBarrier];
    [encoder encodeFloat:self.levelGrowthGoesToBasicSkill forKey:klevelGrowthGoesToBasicSkill];
    [encoder encodeFloat:self.levelProgression forKey:klevelProgression];
    [encoder encodeObject:self.namesForSubSkillTemplates forKey:ksubSkillsTemplate];
    [encoder encodeObject:self.nameForBasicSkillTemplate forKey:kbasicSkillTemplate];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self.name = [decoder decodeObjectForKey:kname];
    self.skillEnumType = [decoder decodeIntForKey:kskillEnumType];
    self.skillDescription = [decoder decodeObjectForKey:kskillDescription];
    self.skillRulesExamples = [decoder decodeObjectForKey:kskillRulesExamples];
    self.skillRules = [decoder decodeObjectForKey:kskillRules];
    self.defaultLevel = [decoder decodeIntForKey:kskillStartingLvl];
    self.levelBasicBarrier = [decoder decodeFloatForKey:klevelBasicBarrier];
    self.levelGrowthGoesToBasicSkill = [decoder decodeFloatForKey:klevelGrowthGoesToBasicSkill];
    self.levelProgression = [decoder decodeFloatForKey:klevelProgression];
    self.namesForSubSkillTemplates = [decoder decodeObjectForKey:ksubSkillsTemplate];
    self.nameForBasicSkillTemplate = [decoder decodeObjectForKey:kbasicSkillTemplate];
    
    return self;
}

@end
