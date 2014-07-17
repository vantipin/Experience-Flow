///Users/v.antipin/Projects/PlayerProgressTracker/Character.h
//  Character.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "Skill.h"
#import "MagicSkill.h"
#import "RangeSkill.h"
#import "MeleeSkill.h"
#import "PietySkill.h"
#import "SkillManager.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataClass.h"

@class CharacterConditionAttributes, Pic, SkillSet, Skill, MeleeSkill, RangeSkill, MagicSkill, PietySkill;

@interface Character : CoreDataClass

@property (nonatomic) BOOL characterFinished;
@property (nonatomic, retain) NSString * characterId;
@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic) NSTimeInterval dateModifed;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t wounds;
@property (nonatomic) int16_t pace;
@property (nonatomic) int16_t bulk;
@property (nonatomic, retain) CharacterConditionAttributes *characterCondition;
@property (nonatomic, retain) Pic *icon;
@property (nonatomic, retain) SkillSet *skillSet;

//methodes for work with object

//create
+(Character *)newCharacterWithContext:(NSManagedObjectContext *)context;
-(BOOL)saveCharacterWithContext:(NSManagedObjectContext *)context;

//update
-(MeleeSkill *)addToCurrentMeleeSkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
-(MeleeSkill *)removeFromCurrentMeleeSkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
-(RangeSkill *)setCurrentRangeSkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
-(MagicSkill *)setCurrentMagicSkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
-(PietySkill *)setCurrentPietySkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;

//fetch
+(NSArray *)fetchCharacterWithId:(NSString *)characterId withContext:(NSManagedObjectContext *)context;
+(NSArray *)fetchFinishedCharacterWithContext:(NSManagedObjectContext *)context;
+(NSArray *)fetchUnfinishedCharacterWithContext:(NSManagedObjectContext *)context;

//delete
+(BOOL)deleteCharacterWithId:(NSString *)characterId withContext:(NSManagedObjectContext *)context;



@end
