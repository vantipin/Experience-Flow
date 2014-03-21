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
                   withContextToHoldItUntilContextSaved:(NSManagedObjectContext *)context;
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

+(NSArray *)newSetOfCoreSkillsWithContext:(NSManagedObjectContext *)context
{
    NSMutableArray *coreSkills = [NSMutableArray new];
    
    NSArray *skillsDictionaryTemplates = [[WarhammerDefaultSkillSetManager sharedInstance] allCharacterDefaultSkillTemplates];
    for (SkillTemplate *skillTemplate in skillsDictionaryTemplates)
    {
        Skill *coreSkill = [Skill newSkillWithTemplate:skillTemplate withBasicSkill:nil withCurrentXpPoints:0 withContextToHoldItUntilContextSaved:context];
        
        if (coreSkill)
        {
            [coreSkills addObject:coreSkill];
        }
    }
    
    return coreSkills;
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

-(Skill *)addXpPoints:(float)xpPoints
          withContext:(NSManagedObjectContext *)context
{
    if (xpPoints)
    {
        
        Skill *skill = self;
        //calculate xp
        float thisCurrentXp = skill.thisLvlCurrentProgress;
        
        if (skill.skillTemplate.basicSkillGrowthGoes!=0&&skill.basicSkill)
        {
            float thisCurrentBasicXp = xpPoints/skill.skillTemplate.basicSkillGrowthGoes;
            thisCurrentXp = thisCurrentXp + xpPoints - thisCurrentBasicXp;
            skill.thisLvlCurrentProgress = thisCurrentBasicXp;
            
            skill.basicSkill.thisLvlCurrentProgress = thisCurrentBasicXp + skill.basicSkill.thisLvlCurrentProgress;
            [Skill calculateAddingXpPointsToSkill:skill.basicSkill withContext:context];
            skill.basicSkill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        }
        else
        {
            skill.thisLvlCurrentProgress = thisCurrentXp + xpPoints;
        }
        
        skill = [Skill calculateAddingXpPointsToSkill:skill withContext:context];
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        
        [Skill saveContext:context];
        
        return skill;

    }
    return nil;
}

//private methode for recursive calculating xp points
+(Skill *)calculateAddingXpPointsToSkill:(Skill *)skill withContext:(NSManagedObjectContext *)context
{
    
    //calculate xp
    
    int thisLvl = skill.thisLvl;
    float thisPrograssion = skill.skillTemplate.thisSkillProgression;
    int thisBasicBarrier = skill.skillTemplate.thisBasicBarrier;
    
    float xpNextLvl = (thisLvl)*thisPrograssion + thisBasicBarrier;
    
    float thisCurrentXp = skill.thisLvlCurrentProgress;
    if (thisCurrentXp >= xpNextLvl)
    {
        skill.thisLvlCurrentProgress = ABS(xpNextLvl - thisCurrentXp);
        skill.thisLvl = thisLvl + 1;
        skill = [Skill calculateAddingXpPointsToSkill:skill withContext:context]; //check if more than 1 lvl
    }
    
    return skill;
}

-(Skill *)removeXpPoints:(float)xpPoints
             withContext:(NSManagedObjectContext *)context
{
    if (xpPoints)
    {
        Skill *skill = self;
        
        
        float thisCurrentXp = skill.thisLvlCurrentProgress;
        
        if (skill.skillTemplate.basicSkillGrowthGoes!=0&&skill.basicSkill)
        {
            float thisCurrentBasicXp = xpPoints/skill.skillTemplate.basicSkillGrowthGoes;
            thisCurrentXp = thisCurrentXp - xpPoints + thisCurrentBasicXp;
            skill.thisLvlCurrentProgress = thisCurrentBasicXp;
            
            skill.basicSkill.thisLvlCurrentProgress = (skill.basicSkill.thisLvlCurrentProgress - thisCurrentBasicXp);
            [Skill calculateRemovingXpPointsFromSkill:skill.basicSkill withContext:context];
            skill.basicSkill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        }
        else
        {
            skill.thisLvlCurrentProgress = (thisCurrentXp - xpPoints);
        }
        
        
        skill = [Skill calculateRemovingXpPointsFromSkill:skill withContext:context];
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        
        [Skill saveContext:context];
        
        return skill;
    }
    return nil;
}

//private methode for recursive calculating xp points
+(Skill *)calculateRemovingXpPointsFromSkill:(Skill *)skill withContext:(NSManagedObjectContext *)context
{
    //calculate xp
    int thisLvl = skill.thisLvl;
    float thisPrograssion = skill.skillTemplate.thisSkillProgression;
    int thisBasicBarrier = skill.skillTemplate.thisBasicBarrier;
    
    float xpPrevLvl = (thisLvl-1)*thisPrograssion + thisBasicBarrier;
    
    float thisCurrentXp = skill.thisLvlCurrentProgress;
    if (thisCurrentXp < 0)
    {
        if (thisLvl<=0) //xp cannt be less than zero
        {
            skill.thisLvlCurrentProgress = 0;
        }
        else
        {
            skill.thisLvlCurrentProgress = (xpPrevLvl - ABS(thisCurrentXp));
            skill.thisLvl = (thisLvl - 1);
            if (skill.thisLvlCurrentProgress < 0) //if more then 1 lvl?
            {
                skill = [Skill calculateRemovingXpPointsFromSkill:skill withContext:context];
            }
        }
    }
    return skill;
}

-(Skill *)editSkillMetaWithName:(NSString *)name
               withDesription:(NSString *)description
                  withContext:(NSManagedObjectContext *)context
{
    if (name)
    {
        Skill *skill = self;
        skill.skillTemplate.name = name;
        skill.skillTemplate.skillDescription=description;
        
        [Skill saveContext:context];
        
        return skill;
    }
    return nil;
}

-(Skill *)editSkillWithBasicBarrier:(int)xpBarrier
        withLvLProgration:(float)lvlProgration
      withCurrentXpPoints:(float)currentPoints
              withContext:(NSManagedObjectContext *)context
{
    if (xpBarrier&&lvlProgration)
    {
        Skill *skill = self;
        skill.skillTemplate.thisBasicBarrier = xpBarrier;
        skill.skillTemplate.thisSkillProgression=lvlProgration;
        if (currentPoints)
        {
            skill.thisLvlCurrentProgress = currentPoints;
        }
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        
        [SkillTemplate saveContext:context];
        
        return skill;
    }
    return nil;
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
