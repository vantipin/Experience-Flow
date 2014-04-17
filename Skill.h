//
//  Skill.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataClass.h"

@class Skill, SkillTemplate, WeaponMelee;

@interface Skill : CoreDataClass

@property (nonatomic) NSTimeInterval dateXpAdded;
@property (nonatomic, retain) NSString * skillId;
@property (nonatomic) int16_t thisLvl;
@property (nonatomic) float thisLvlCurrentProgress;
@property (nonatomic, retain) Skill *basicSkill;
@property (nonatomic, retain) WeaponMelee *items;
@property (nonatomic, retain) NSManagedObject *skillSet;
@property (nonatomic, retain) SkillTemplate *skillTemplate;
@property (nonatomic, retain) NSSet *subSkills;
@end

@interface Skill (CoreDataGeneratedAccessors)

- (void)addSubSkillsObject:(Skill *)value;
- (void)removeSubSkillsObject:(Skill *)value;
- (void)addSubSkills:(NSSet *)values;
- (void)removeSubSkills:(NSSet *)values;


//create
+(Skill *)newSkillWithTemplate:(SkillTemplate *)skillTemplate
                withBasicSkill:(Skill *)basicSkill
           withCurrentXpPoints:(float)curentPoints
                   withContext:(NSManagedObjectContext *)context;

//fetch
+(NSArray *)fetchSkillWithId:(NSString *)skillId withContext:(NSManagedObjectContext *)context;

//delete
+(BOOL)deleteSkillWithId:(NSString *)skillId withContext:(NSManagedObjectContext *)context;


@end
