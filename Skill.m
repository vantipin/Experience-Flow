//
//  Skill.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 28.01.14.
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
#import "WarhammerDefaultSkillSetManager.h"


@implementation Skill

@dynamic dateXpAdded;
@dynamic thisLvl;
@dynamic thisLvlCurrentProgress;
@dynamic basicSkill;
@dynamic items;
@dynamic player;
@dynamic subSkills;
@dynamic skillTemplate;
@dynamic skillId;

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
        
        skill.thisLvl = skillTemplate.skillStartingLvl;
        skill.thisLvlCurrentProgress = curentPoints ? curentPoints : 0.0;
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        skill.skillTemplate = skillTemplate;
        
        [Skill saveContext:context];
        
        NSLog(@"New skill created with name %@.",skill.skillTemplate.name);
        return skill;
    }
    
    return nil;
}

//update
-(Skill *)addSolidLvls:(int)levels
           withContext:(NSManagedObjectContext *)context
{
    if (levels && levels > 0)
    {
        Skill *skill = self;
        
        //For basic skill
        if (skill.basicSkill)
        {
            int totalXpPoints = 0;
            
            for (int i = skill.thisLvl; i <= levels + skill.thisLvl; i++)
            {
                totalXpPoints += i * skill.skillTemplate.thisSkillProgression + skill.skillTemplate.thisBasicBarrier;
            }
            
            totalXpPoints += totalXpPoints/skill.skillTemplate.basicSkillGrowthGoes - skill.thisLvlCurrentProgress;
            
            [skill addXpPoints:totalXpPoints withContext:context];
        }
        else
        {
            skill.thisLvl = skill.thisLvl + levels;
        }
        
        [SkillTemplate saveContext:context];
        
        return skill;
    }
    return nil;
}



-(Skill *)removeSolidLvls:(int)levels
              withContext:(NSManagedObjectContext *)context
{
    if (levels && levels > 0)
    {
        Skill *skill = self;
        
        
        for (int i = 0; i < levels; i++)
        {
            //xp needed to gain this lvl
            int thisLvlXpWithoutBasicSkill = (skill.thisLvl-1) * skill.skillTemplate.thisSkillProgression + skill.skillTemplate.thisBasicBarrier;
            BOOL hasValidBasicSkill = (skill.skillTemplate.basicSkillGrowthGoes !=0 && skill.basicSkill);
            int thisLvlXp = hasValidBasicSkill ? thisLvlXpWithoutBasicSkill * skill.skillTemplate.basicSkillGrowthGoes : thisLvlXpWithoutBasicSkill;
            
            [skill removeXpPoints:thisLvlXp withContext:context];
        }
        
        [SkillTemplate saveContext:context];
        
        return skill;
    }
    return nil;
}

-(float)xpPointsForSkill:(float)xpPoints
{
    float resultXpPoints = xpPoints;
    if (self.basicSkill) {
        resultXpPoints -= [self xpPointsForBasicSkill:xpPoints];
    }
    return resultXpPoints;
}

-(float)xpPointsForBasicSkill:(float)xpPoints
{
    float resultXpPoints = 0;
    float safeFilter = (self.skillTemplate.basicSkillGrowthGoes > 1) ? 1 : self.skillTemplate.basicSkillGrowthGoes;
    resultXpPoints = safeFilter * xpPoints;
    return resultXpPoints;
}


-(Skill *)addXpPoints:(float)xpPoints
          withContext:(NSManagedObjectContext *)context
{
    if (xpPoints)
    {
        
        Skill *skill = self;
        //calculate xp
        if (skill.skillTemplate.basicSkillGrowthGoes != 0 && skill.basicSkill) {
            [skill.basicSkill addXpPoints:[self xpPointsForBasicSkill:xpPoints] withContext:context];
        }
        
        skill.thisLvlCurrentProgress += [self xpPointsForSkill:xpPoints];
        skill = [skill calculateAddingXpPointsWithContext:context];
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        
        [Skill saveContext:context];
        
        return skill;

    }
    return nil;
}

-(Skill *)calculateAddingXpPointsWithContext:(NSManagedObjectContext *)context
{
    float xpNextLvl = self.thisLvl * self.skillTemplate.thisSkillProgression + self.skillTemplate.thisBasicBarrier;

    if (self.thisLvlCurrentProgress >= xpNextLvl) {
        self.thisLvlCurrentProgress -= xpNextLvl;
        self.thisLvl ++;
        [self calculateAddingXpPointsWithContext:context]; //check if more than 1 lvl
    }
    
    return self;
}

-(Skill *)removeXpPoints:(float)xpPoints
             withContext:(NSManagedObjectContext *)context
{
    if (xpPoints)
    {
        Skill *skill = self;
        
        if (skill.skillTemplate.basicSkillGrowthGoes != 0 && skill.basicSkill) {
            [skill.basicSkill removeXpPoints:[self xpPointsForBasicSkill:xpPoints] withContext:context];
        }
        
        skill.thisLvlCurrentProgress -= [self xpPointsForSkill:xpPoints];
        skill = [skill calculateRemovingXpPointsWithContext:context];
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        
        [Skill saveContext:context];
        
        return skill;
    }
    return nil;
}

-(Skill *)calculateRemovingXpPointsWithContext:(NSManagedObjectContext *)context
{
    if (self.thisLvl == 0) {
        self.thisLvlCurrentProgress = (self.thisLvlCurrentProgress < 0) ? 0 : self.thisLvlCurrentProgress;
        return self;
    }
    if (self.thisLvlCurrentProgress < 0) {
        self.thisLvl --;
        float xpPrevLvl = self.thisLvl * self.skillTemplate.thisSkillProgression + self.skillTemplate.thisBasicBarrier;
        self.thisLvlCurrentProgress += xpPrevLvl;
        [self calculateRemovingXpPointsWithContext:context];
    }

    return self;
}

//fetch
+(NSArray *)fetchSkillWithId:(NSString *)skillId withContext:(NSManagedObjectContext *)context
{
    for (int16_t i = StandartSkillType; i < LastElementInEnum; i++) {
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
    for (int16_t i = StandartSkillType; i < LastElementInEnum; i++) {
        BOOL temp = [Skill clearEntityForNameWithObjName:[SkillTemplate entityNameForSkillEnum:i] withPredicate:[NSPredicate predicateWithFormat:@"skillId = %@",skillId] withGivenContext:context];
        result = temp ? temp : result;
    }
    return result;
}


@end
