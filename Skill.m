//
//  Skill.m
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
#import "Character.h"
#import "Pic.h"
#import "SkillTemplate.h"
#import "WeaponMelee.h"
#import "SkillManager.h"


@implementation Skill

@dynamic dateXpAdded;
@dynamic skillId;
@dynamic currentLevel;
@dynamic currentProgress;
@dynamic basicSkill;
@dynamic items;
@dynamic skillSet;
@dynamic skillTemplate;
@dynamic subSkills;

//create
+(Skill *)newSkillWithTemplate:(SkillTemplate *)skillTemplate
                withBasicSkill:(Skill *)basicSkill
           withCurrentXpPoints:(float)curentPoints
                   withContext:(NSManagedObjectContext *)context;
{
    if (skillTemplate)
    {
        NSString *entityName = [SkillTemplate entityNameForSkillTemplate:skillTemplate];
        
        Skill *skill = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        
        if (basicSkill && skillTemplate.basicSkillTemplate == basicSkill.skillTemplate)
        {
            skill.basicSkill = basicSkill;
        }
        
        skill.skillId = [NSString stringWithFormat:@"%@",skill.objectID];
        
        skill.currentLevel = skillTemplate.skillStartingLvl;
        skill.currentProgress = curentPoints ? curentPoints : 0.0;
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        skill.skillTemplate = skillTemplate;
        
        [Skill saveContext:context];
        
        NSLog(@"New skill created with name %@.",skill.skillTemplate.name);
        return skill;
    }
    
    return nil;
}

//fetch
+(NSArray *)fetchSkillWithId:(NSString *)skillId withContext:(NSManagedObjectContext *)context
{
    for (int16_t i = AdvancedSkillType; i < LastElementInEnum; i++) {
        NSArray *allSkillsArray = [Skill fetchRequestForObjectName:[SkillTemplate entityNameForSkillEnum:i] withPredicate:[NSPredicate predicateWithFormat:@"skillId = %@",skillId] withContext:context];
        if (allSkillsArray && allSkillsArray.count != 0) {
            return allSkillsArray;
        }
    }
    return nil;
}

//delete
+(BOOL)deleteSkillWithId:(NSString *)skillId withContext:(NSManagedObjectContext *)context
{
    BOOL result = false;
    for (int16_t i = AdvancedSkillType; i < LastElementInEnum; i++) {
        BOOL temp = [Skill clearEntityForNameWithObjName:[SkillTemplate entityNameForSkillEnum:i] withPredicate:[NSPredicate predicateWithFormat:@"skillId = %@",skillId] withGivenContext:context];
        result = temp ? temp : result;
    }
    return result;
}


@end
