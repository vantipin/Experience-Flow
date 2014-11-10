//
//  SkillTemplate.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 28.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataClass.h"

@class Skill, SkillTemplate, CoreDataClass, Pic;

@interface SkillTemplate : CoreDataClass;

typedef enum SkillClassType : int16_t
{
    AdvancedSkillType = 0,
    MagicSkillType = 1,
    RangeSkillType = 2,
    MeleeSkillType = 3,
    PietySkillType = 4,
    BasicSkillType = 5,
    LastElementInEnum = 6,
} SkillClassesType;

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nameForDisplay;
@property (nonatomic, retain) NSString * skillDescription;
@property (nonatomic, retain) NSString * skillRules;
@property (nonatomic, retain) NSString * skillRulesExamples;
@property (nonatomic, retain) Pic *icon;
@property (nonatomic) float levelBasicBarrier;
@property (nonatomic) float levelProgression;
@property (nonatomic) float levelGrowthGoesToBasicSkill;
@property (nonatomic) int16_t defaultLevel;
@property (nonatomic) SkillClassesType skillEnumType;
@property (nonatomic, retain) NSSet *skillsFromThisTemplate;
@property (nonatomic, retain) SkillTemplate *basicSkillTemplate;
@property (nonatomic, retain) NSSet *subSkillsTemplate;
@property (nonatomic) BOOL isMediator;
@end

@interface SkillTemplate (CoreDataGeneratedAccessors)

- (void)addSkillsFromThisTemplateObject:(Skill *)value;
- (void)removeSkillsFromThisTemplateObject:(Skill *)value;
- (void)addSkillsFromThisTemplate:(NSSet *)values;
- (void)removeSkillsFromThisTemplate:(NSSet *)values;

- (void)addSubSkillsTemplateObject:(SkillTemplate *)value;
- (void)removeSubSkillsTemplateObject:(SkillTemplate *)value;
- (void)addSubSkillsTemplate:(NSSet *)values;
- (void)removeSubSkillsTemplate:(NSSet *)values;

+(SkillTemplate *)newSkillTemplateWithUniqName:(NSString *)name
                            withNameForDisplay:(NSString *)nameForDisplay
                                     withRules:(NSString *)rules
                             withRulesExamples:(NSString *)examples
                               withDescription:(NSString *)skillDescription
                                 withSkillIcon:(Pic *)icon
                            withBasicXpBarrier:(float)basicXpBarrier
                          withSkillProgression:(float)skillProgression
                      withBasicSkillGrowthGoes:(float)basicSkillGrowthGoes
                                 withSkillType:(SkillClassesType)skillClassType
                        withDefaultStartingLvl:(int)startingLvl
                       withParentSkillTemplate:(SkillTemplate *)basicSkillTemplate
                                   withContext:(NSManagedObjectContext *)context;

+(SkillTemplate *)newSkillTemplateWithUniqName:(NSString *)name
                            withNameForDisplay:(NSString *)nameForDisplay
                                     withRules:(NSString *)rules
                             withRulesExamples:(NSString *)examples
                               withDescription:(NSString *)skillDescription
                                 withSkillIcon:(Pic *)icon
                            withBasicXpBarrier:(float)basicXpBarrier
                          withSkillProgression:(float)skillProgression
                      withBasicSkillGrowthGoes:(float)basicSkillGrowthGoes
                                 withSkillType:(SkillClassesType)skillClassType
                        withDefaultStartingLvl:(int)startingLvl
                       withParentSkillTemplate:(SkillTemplate *)basicSkillTemplate
                                    isMediator:(BOOL)isMediatorSkill
                                   withContext:(NSManagedObjectContext *)context;

+(NSArray *)fetchAllSkillTemplatesWithContext:(NSManagedObjectContext *)context;

+(BOOL)deleteSkillTemplateWithName:(NSString *)skillTemplateName withContext:(NSManagedObjectContext *)context;

+(NSArray *)fetchSkillTemplateForName:(NSString *)name withContext:(NSManagedObjectContext *)context;

+(NSString *)entityNameForSkillTemplate:(SkillTemplate *)skillTemplate;
+(NSString *)entityNameForSkillEnum:(int16_t)skillEnum;
@end
