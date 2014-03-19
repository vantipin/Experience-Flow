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
@dynamic skillDescription;
@dynamic thisBasicBarrier;
@dynamic thisSkillProgression;
@dynamic basicSkillGrowthGoes;
@dynamic skillsFromThisTemplate;
@dynamic basicSkillTemplate;
@dynamic subSkillsTemplate;
@dynamic icon;

+(SkillTemplate *)newSkilTemplateWithUniqName:(NSString *)name
                              withDescription:(NSString *)skillDescription
                                withSkillIcon:(UIImage *)icon
                           withBasicXpBarrier:(int)basicXpBarrier
                         withSkillProgression:(float)skillProgression
                     withBasicSkillGrowthGoes:(int)basicSkillGrowthGoes
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
