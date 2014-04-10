//
//  SkillSet.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataClass.h"

@class Character, Skill;

@interface SkillSet : CoreDataClass

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t wounds;
@property (nonatomic) int16_t modifierArmorSave;
@property (nonatomic) int16_t modifierAMelee;
@property (nonatomic) int16_t modifierARange;
@property (nonatomic) int16_t modifierHp;
@property (nonatomic, retain) NSSet *skills;
@property (nonatomic, retain) Character *character;
@end

@interface SkillSet (CoreDataGeneratedAccessors)

- (void)addSkillsObject:(Skill *)value;
- (void)removeSkillsObject:(Skill *)value;
- (void)addSkills:(NSSet *)values;
- (void)removeSkills:(NSSet *)values;

/**
 Create copy of character skills and stats.
 */

+(NSArray *)fetchNamelessAndCharacterlessSkillSetsWithContext:(NSManagedObjectContext *)context;
+(NSArray *)fetchCharacterlessSkillSetsWithContext:(NSManagedObjectContext *)context;
+(NSArray *)fetchSkillSetWithName:(NSString *)name withContext:(NSManagedObjectContext *)context;

+(BOOL)deleteSkillSetWithName:(NSString *)name withContext:(NSManagedObjectContext *)context;
+(void)deleteSkillSet:(SkillSet *)set withContext:(NSManagedObjectContext *)context;

@end
