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
#import "WarhammerDefaultSkillSetManager.h"

static NSString *needDefaultSkillsCheckKey = @"needDefualtSkillsCheck";

@implementation SkillTemplate

@dynamic name;
@dynamic skillEnumType;
@dynamic skillDescription;
@dynamic skillStartingLvl;
@dynamic thisBasicBarrier;
@dynamic thisSkillProgression;
@dynamic basicSkillGrowthGoes;
@dynamic skillsFromThisTemplate;
@dynamic basicSkillTemplate;
@dynamic subSkillsTemplate;
@dynamic icon;

+(SkillTemplate *)newSkillTemplateWithUniqName:(NSString *)name
                               withDescription:(NSString *)skillDescription
                                 withSkillIcon:(UIImage *)icon
                            withBasicXpBarrier:(int)basicXpBarrier
                          withSkillProgression:(float)skillProgression
                      withBasicSkillGrowthGoes:(int)basicSkillGrowthGoes
                                 withSkillType:(SkillClassesType)skillClassType
                        withDefaultStartingLvl:(int)startingLvl
                       withParentSkillTemplate:(SkillTemplate *)basicSkillTemplate
                                   withContext:(NSManagedObjectContext *)context;
{
    if (name && (basicXpBarrier || skillProgression))
    {
        NSArray *existingSkillsWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withContext:context];
        if (existingSkillsWithThisName && existingSkillsWithThisName.count!=0)
        {
            return [existingSkillsWithThisName lastObject];
        }
    
        //create new one
        SkillTemplate *skillTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"SkillTemplate" inManagedObjectContext:context];
        
        skillTemplate.name = name;
        skillTemplate.skillDescription = skillDescription;
        skillTemplate.thisBasicBarrier = basicXpBarrier;
        skillTemplate.thisSkillProgression = skillProgression;
        skillTemplate.skillEnumType = skillClassType;
        skillTemplate.skillStartingLvl = startingLvl;
        
        if (icon)
        {
            skillTemplate.icon = [Pic addPicWithImage:icon];
        }
        
        if (basicSkillTemplate)
        {
            skillTemplate.basicSkillTemplate = basicSkillTemplate;
            skillTemplate.basicSkillGrowthGoes = basicSkillGrowthGoes;
        }
    
        NSLog(@"Created new template with name: %@",name);
        [SkillTemplate saveContext:context];
        
        return skillTemplate;
    }
    
    return nil;
}

+(SkillTemplate *)editSkillTemplateWithName:(NSString *)name
                         withNewDescription:(NSString *)skillDescription
                           withNewSkillIcon:(UIImage *)icon
                      withNewBasicXpBarrier:(int)basicXpBarrier
                    withNewSkillProgression:(float)skillProgression
                withNewBasicSkillGrowthGoes:(int)basicSkillGrowthGoes
                 withNewParentSkillTemplate:(SkillTemplate *)basicSkillTemplate
                                withContext:(NSManagedObjectContext *)context;
{
    if (name)
    {
        NSArray *existingSkillsWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withContext:context];
        if (existingSkillsWithThisName && existingSkillsWithThisName.count!=0)
        {
            SkillTemplate *skillTemplate = [existingSkillsWithThisName lastObject];
            
            skillTemplate.skillDescription = skillDescription;
            
            if (basicXpBarrier || skillProgression)
            {
                skillTemplate.thisBasicBarrier = basicXpBarrier;
                skillTemplate.thisSkillProgression = skillProgression;
            }
            
            if (icon)
            {
                skillTemplate.icon = [Pic addPicWithImage:icon];
            }
            
            if (basicSkillTemplate)
            {
                skillTemplate.basicSkillTemplate = basicSkillTemplate;
                skillTemplate.basicSkillGrowthGoes = basicSkillGrowthGoes;
            }
            [SkillTemplate saveContext:context];
            
            return skillTemplate;
        }
    }
    
    return nil;
}

+(NSString *)entityNameForSkillEnum:(int16_t)skillEnum
{
    NSString *entityName;
    switch (skillEnum) {
        case 0:
            entityName = @"Skill";
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
        default:
            entityName = @"Skill";
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
    WarhammerDefaultSkillSetManager *defaultSkills = [WarhammerDefaultSkillSetManager sharedInstance];
    [defaultSkills allSystemDefaultSkillTemplates]; //should create all default skill templates if missed
}

+(BOOL)deleteSkillTemplateWithName:(NSString *)skillTemplateName withContext:(NSManagedObjectContext *)context
{
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:needDefaultSkillsCheckKey];
    return [SkillTemplate clearEntityForNameWithObjName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",skillTemplateName] withGivenContext:context];
}

@end
