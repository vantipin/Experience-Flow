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
        
        [SkillTemplate saveContext:context];
    
        NSLog(@"Created template with name: %@",name);
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

+(SkillTemplate *)newSkillTemplateWithTemplate:(NSDictionary *)templateDictionary withContext:(NSManagedObjectContext *)context
{
    SkillTemplate *skillTemplate;
    
    if (templateDictionary && ([templateDictionary isKindOfClass:[NSDictionary class]] || [templateDictionary isKindOfClass:[NSMutableDictionary class]]))
    {
        /*
         @{@"name": @"",
         @"skillDescription": @"",
         @"thisBasicBarrier": @"",
         @"thisSkillProgression": @"",
         @"basicSkillGrowthGoes": @"",
         @"basicSkill": @"",
         @"icon": @""};
         */
        
        NSString *name = [templateDictionary valueForKey:@"name"];
        NSString *skillDescription = [templateDictionary valueForKey:@"skillDescription"];
        UIImage *icon = [UIImage imageNamed:[templateDictionary valueForKey:@"icon"]];
        int basicBarrier = [[templateDictionary valueForKey:@"thisBasicBarrier"] intValue];
        float skillProgression = [[templateDictionary valueForKey:@"thisSkillProgression"] floatValue];
        int basicSkillGrowthGoes = [[templateDictionary valueForKey:@"basicSkillGrowthGoes"] intValue];
        
        NSDictionary *basicSkillTemplateDictionary = [templateDictionary valueForKey:@"basicSkill"];
        SkillTemplate *basicSkillTemplate = [SkillTemplate newSkillTemplateWithTemplate:basicSkillTemplateDictionary withContext:context];
        
        skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:name withDescription:skillDescription withSkillIcon:icon withBasicXpBarrier:basicBarrier withSkillProgression:skillProgression withBasicSkillGrowthGoes:basicSkillGrowthGoes withParentSkillTemplate:basicSkillTemplate withContext:context];
    }

    return skillTemplate;
}

+(void)checkDefaultSkillsAndCreateIfMissingWithContext:(NSManagedObjectContext *)context
{
    WarhammerDefaultSkillSetManager *defaultSkills = [WarhammerDefaultSkillSetManager sharedInstance];
    NSArray *allDefaultSkills = [defaultSkills allSystemDefaultSkillTemplates];
    for (NSDictionary *template in allDefaultSkills)
    {
        NSString *name = [template valueForKey:@"name"];
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withContext:context];
        if (existingSkillsTemplateWithThisName && existingSkillsTemplateWithThisName.count!=0)
        {
            [SkillTemplate newSkillTemplateWithTemplate:template withContext:context];
        }
    }
}

+(BOOL)deleteSkillTemplateWithName:(NSString *)skillTemplateName withContext:(NSManagedObjectContext *)context
{
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:needDefaultSkillsCheckKey];
    return [SkillTemplate clearEntityForNameWithObjName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",skillTemplateName] withGivenContext:context];
}

@end
