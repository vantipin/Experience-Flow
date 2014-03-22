//
//  Character.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 20.02.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CharacterConditionAttributes.h"
#import "CoreDataClass.h"

@class CharacterConditionAttributes, Pic, Skill, SkillTemplate;

@interface Character : CoreDataClass

@property (nonatomic) BOOL characterFinished;
@property (nonatomic) int16_t wounds;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic) NSTimeInterval dateModifed;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CharacterConditionAttributes *characterCondition;
@property (nonatomic, retain) Pic *icon;
@property (nonatomic, retain) NSString *characterId;
@property (nonatomic, retain) NSSet *skillSet;

@end

@interface Character (CoreDataGeneratedAccessors)

- (void)addSkillSetObject:(Skill *)value;
- (void)removeSkillSetObject:(Skill *)value;
- (void)addSkillSet:(NSSet *)values;
- (void)removeSkillSet:(NSSet *)values;


//methodes for work with object

//create
+(Character *)newCharacterWithContext:(NSManagedObjectContext *)context;
-(BOOL)saveCharacterWithContext:(NSManagedObjectContext *)context;

//update
-(Skill *)addNewSkillWithTempate:(SkillTemplate *)skillTemplate
                     withContext:(NSManagedObjectContext *)context;

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
