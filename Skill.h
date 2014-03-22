//
//  Skill.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 28.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataClass.h"

@class Character, Pic, Skill, SkillTemplate, WeaponMelee;

@interface Skill : CoreDataClass

@property (nonatomic) NSTimeInterval dateXpAdded;
@property (nonatomic) int16_t thisLvl;
@property (nonatomic) float thisLvlCurrentProgress;
@property (nonatomic, retain) Skill *basicSkill;
@property (nonatomic, retain) NSString *skillId;

@property (nonatomic, retain) WeaponMelee *items;
@property (nonatomic, retain) Character *player;
@property (nonatomic, retain) NSSet *subSkills;
@property (nonatomic, retain) SkillTemplate *skillTemplate;

@end

@interface Skill (CoreDataGeneratedAccessors)

- (void)addSubSkillsObject:(Skill *)value;
- (void)removeSubSkillsObject:(Skill *)value;
- (void)addSubSkills:(NSSet *)values;
- (void)removeSubSkills:(NSSet *)values;

//methodes for work with object

//create

//name basicXpBarrier lvlPropgrassion are requierd
+(Skill *)newSkillWithTemplate:(SkillTemplate *)skillTemplate
                withBasicSkill:(Skill *)basicSkill
           withCurrentXpPoints:(float)curentPoints
                   withContext:(NSManagedObjectContext *)context;

//update
-(Skill *)addSolidLvls:(int)levels
           withContext:(NSManagedObjectContext *)context;
-(Skill *)removeSolidLvls:(int)levels
              withContext:(NSManagedObjectContext *)context;
-(Skill *)addXpPoints:(float)xpPoints
          withContext:(NSManagedObjectContext *)context;
-(Skill *)removeXpPoints:(float)xpPoints
             withContext:(NSManagedObjectContext *)context;


//fetch
+(NSArray *)fetchSkillWithId:(NSString *)skillId withContext:(NSManagedObjectContext *)context;

//delete
+(BOOL)deleteSkillWithId:(NSString *)skillId withContext:(NSManagedObjectContext *)context;


@end
