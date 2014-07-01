//
//  SkillTemplate.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 28.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "SkillTemplate.h"
#import "Skill.h"
#import "SkillTemplate.h"
#import "Pic.h"
#import "SkillManager.h"
#import "DefaultSkillTemplates.h"

static NSString *needDefaultSkillsCheckKey = @"needDefualtSkillsCheck";

@implementation SkillTemplate

@dynamic name;
@dynamic skillEnumType;
@dynamic skillDescription;
@dynamic skillRulesExamples;
@dynamic skillRules;
@dynamic defaultLevel;
@dynamic levelBasicBarrier;
@dynamic levelProgression;
@dynamic levelGrowthGoesToBasicSkill;
@dynamic skillsFromThisTemplate;
@dynamic basicSkillTemplate;
@dynamic subSkillsTemplate;
@dynamic icon;

+(SkillTemplate *)newSkillTemplateWithUniqName:(NSString *)name
                                     withRules:(NSString *)rules
                             withRulesExamples:(NSString *)examples
                               withDescription:(NSString *)skillDescription
                                 withSkillIcon:(UIImage *)icon
                            withBasicXpBarrier:(float)basicXpBarrier
                          withSkillProgression:(float)skillProgression
                      withBasicSkillGrowthGoes:(float)basicSkillGrowthGoes
                                 withSkillType:(SkillClassesType)skillClassType
                        withDefaultStartingLvl:(int)startingLvl
                       withParentSkillTemplate:(SkillTemplate *)basicSkillTemplate
                                   withContext:(NSManagedObjectContext *)context;
{
    if (name && (basicXpBarrier || skillProgression))
    {
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withContext:context];
        if (existingSkillsWithThisName && existingSkillsWithThisName.count!=0)
        {
            skillTemplate = [existingSkillsWithThisName lastObject];
        }
        else {
            //create new one
            skillTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"SkillTemplate" inManagedObjectContext:context];
        }
        skillTemplate.name = name;
        skillTemplate.skillRules = rules;
        skillTemplate.skillRulesExamples = examples;
        skillTemplate.skillDescription = skillDescription;
        skillTemplate.levelBasicBarrier = basicXpBarrier;
        skillTemplate.levelProgression = skillProgression;
        skillTemplate.skillEnumType = skillClassType;
        skillTemplate.defaultLevel = startingLvl;
        
        if (icon)
        {
            skillTemplate.icon = [Pic addPicWithImage:icon];
        }
        
        if (basicSkillTemplate)
        {
            skillTemplate.basicSkillTemplate = basicSkillTemplate;
            skillTemplate.levelGrowthGoesToBasicSkill = basicSkillGrowthGoes;
        }
    
        NSLog(@"Created new template with name: %@",name);
        [SkillTemplate saveContext:context];
        
        //save it Here are
        //NSDictionary *objectToDictionary = [skillTemplate di];
        
        
        
        return skillTemplate;
    }
    
    return nil;
}

+(NSString *)entityNameForSkillEnum:(int16_t)skillEnum
{
    NSString *entityName;
    switch (skillEnum) {
        case 0:
            entityName = @"AdvancedSkill";
            break;
        case 1:
            entityName = @"MagicSkill";
            break;
        case 2:
            entityName = @"RangeSkill";
            break;
        case 3:
            entityName = @"MeleeSkill";
            break;
        case 4:
            entityName = @"PietySkill";
            break;
        case 5:
            entityName = @"BasicSkill";
            break;
        default:
            entityName = @"AdvancedSkill";
            break;
    }
    return entityName;
}

+(NSString *)entityNameForSkillTemplate:(SkillTemplate *)skillTemplate
{
    return [SkillTemplate entityNameForSkillEnum:skillTemplate.skillEnumType];
}

+(NSArray *)fetchAllSkillTemplatesWithContext:(NSManagedObjectContext *)context
{
    BOOL needDefaultSkillsChecking = [[NSUserDefaults standardUserDefaults] boolForKey:needDefaultSkillsCheckKey];
    if (needDefaultSkillsChecking)
    {
        [SkillTemplate checkDefaultSkillsAndCreateIfMissingWithContext:context];
    }
    return [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:nil withContext:context];
}


+(void)checkDefaultSkillsAndCreateIfMissingWithContext:(NSManagedObjectContext *)context
{
    DefaultSkillTemplates *defaultSkills = [DefaultSkillTemplates sharedInstance];
    [defaultSkills allSkillTemplates]; //should create all default skill templates if missed
}

+(NSArray *)fetchSkillTemplateForName:(NSString *)name withContext:(NSManagedObjectContext *)context;
{
    return [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name]  withContext:context];
}


+(BOOL)deleteSkillTemplateWithName:(NSString *)skillTemplateName withContext:(NSManagedObjectContext *)context
{
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:needDefaultSkillsCheckKey];
    return [SkillTemplate clearEntityForNameWithObjName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",skillTemplateName] withGivenContext:context];
}

@end
