//
//  Skill.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 28.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "Skill.h"
#import "Character.h"
#import "Pic.h"
#import "Skill.h"
#import "SkillTemplate.h"
#import "WeaponMelee.h"
#import "WarhammerDefaultSkillSetManager.h"
#import "RRFactorial.h"


@implementation Skill

@dynamic dateXpAdded;
@dynamic skillId;
@dynamic thisLvl;
@dynamic thisLvlCurrentProgress;
@dynamic basicSkill;
@dynamic items;
@dynamic player;
@dynamic subSkills;
@dynamic skillTemplate;

//create
+(Skill *)newSkillWithTemplate:(SkillTemplate *)skillTemplate          
                  withSkillLvL:(short)skillLvL
                withBasicSkill:(Skill *)basicSkill
           withCurrentXpPoints:(float)curentPoints
                   withContextToHoldItUntilContextSaved:(NSManagedObjectContext *)context;
{
    if (skillTemplate)
    {
        
        Skill *skill = [NSEntityDescription insertNewObjectForEntityForName:@"Skill" inManagedObjectContext:context];
        skill.skillId = [NSString base64StringFromData:[skillTemplate.name dataUsingEncoding:NSUTF16StringEncoding] length:10];
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        
        if (basicSkill && skillTemplate.basicSkillTemplate == basicSkill.skillTemplate)
        {
            skill.basicSkill = basicSkill;
        }

        
        skill.thisLvl = skillLvL ? skillLvL : 0;
        skill.thisLvlCurrentProgress = curentPoints ? curentPoints : 0.0;
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        skill.skillTemplate = skillTemplate;
        
        
        return skill;
    }
    
    return nil;
}

+(NSArray *)newSetOfCoreSkillsWithContext:(NSManagedObjectContext *)context
{
    NSMutableArray *coreSkills = [NSMutableArray new];
    
    NSArray *skillsDictionaryTemplates = [[WarhammerDefaultSkillSetManager sharedInstance] allCharacterDefaultSkillTemplates];
    for (NSDictionary *dictionaryTemplate in skillsDictionaryTemplates)
    {
        SkillTemplate *coreSkillTemplate = [SkillTemplate newSkillTemplateWithTemplate:dictionaryTemplate withContext:context];
        Skill *coreSkill = [Skill newSkillWithTemplate:coreSkillTemplate withSkillLvL:0 withBasicSkill:nil withCurrentXpPoints:0 withContextToHoldItUntilContextSaved:context];
        
        if (coreSkill)
        {
            [coreSkills addObject:coreSkill];
        }
    }
    
    return coreSkills;
}

//update
+(Skill *)addSolidLvls:(int)levels
         toSkillWithId:(NSString *)skillId
           withContext:(NSManagedObjectContext *)context
{
    if (levels && skillId && levels > 0)
    {
        NSArray *skillArray = [Skill fetchSkillWithId:skillId withContext:context];
        if (skillArray.count!=0&&skillArray)
        {
            Skill *skill = [skillArray lastObject];
            
            //For basic skill
            if (skill.basicSkill)
            {
                int totalXpPoints = 0;
                
                for (int i = skill.thisLvl; i <= levels + skill.thisLvl; i++)
                {
                    totalXpPoints += i * skill.skillTemplate.thisSkillProgression + skill.skillTemplate.thisBasicBarrier;
                }
                
                totalXpPoints += totalXpPoints/skill.skillTemplate.basicSkillGrowthGoes - skill.thisLvlCurrentProgress;
                
                [Skill addXpPoints:totalXpPoints toSkillWithId:skill.skillId withContext:context];
            }
            else
            {
                skill.thisLvl = skill.thisLvl + levels;
            }
            return skill;
        }
    }
    return nil;
}



+(Skill *)removeSolidLvls:(int)levels
            toSkillWithId:(NSString *)skillId
              withContext:(NSManagedObjectContext *)context
{
    if (levels && skillId && levels > 0)
    {
        NSArray *skillArray = [Skill fetchSkillWithId:skillId withContext:context];
        if (skillArray.count!=0&&skillArray)
        {
            Skill *skill = [skillArray lastObject];
            
            
            for (int i = 0; i < levels; i++)
            {
                //xp needed to gain this lvl
                int thisLvlXpWithoutBasicSkill = (skill.thisLvl-1) * skill.skillTemplate.thisSkillProgression + skill.skillTemplate.thisBasicBarrier;
                BOOL hasValidBasicSkill = (skill.skillTemplate.basicSkillGrowthGoes !=0 && skill.basicSkill);
                int thisLvlXp = hasValidBasicSkill ? thisLvlXpWithoutBasicSkill * skill.skillTemplate.basicSkillGrowthGoes : thisLvlXpWithoutBasicSkill;
                
                [Skill removeXpPoints:thisLvlXp fromSkillWithId:skillId withContext:context];
            }
            return skill;
        }
    }
    return nil;
}

+(Skill *)addXpPoints:(float)xpPoints
        toSkillWithId:(NSString *)skillId
          withContext:(NSManagedObjectContext *)context
{
    if (xpPoints&&skillId)
    {
        
        NSArray *skillArray = [Skill fetchSkillWithId:skillId withContext:context];
        if (skillArray.count!=0&&skillArray)
        {
            
            Skill *skill = [skillArray lastObject];
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
            return skill;
        }
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

+(Skill *)removeXpPoints:(float)xpPoints
         fromSkillWithId:(NSString *)skillId
             withContext:(NSManagedObjectContext *)context
{
    if (xpPoints&&skillId)
    {
        NSArray *skillArray = [Skill fetchSkillWithId:skillId withContext:context];
        if (skillArray.count!=0&&skillArray)
        {
            
            Skill *skill = [skillArray lastObject];
            
            
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
            return skill;
        }
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

+(Skill *)editSkillMetaWithId:(NSString *)skillId
                     withName:(NSString *)name
               withDesription:(NSString *)description
                  withContext:(NSManagedObjectContext *)context
{
    if (name)
    {
        NSArray *skillArray = [Skill fetchSkillWithId:skillId withContext:context];
        if (skillArray.count!=0&&skillArray)
        {
            Skill *skill = [skillArray lastObject];
            skill.skillTemplate.name = name;
            skill.skillTemplate.skillDescription=description;
            return skill;
        }
    }
    return nil;
}

+(Skill *)editSkillWithId:(NSString *)skillId
withGrowthBlockWithBasicBarrier:(int)xpBarrier
        withLvLProgration:(float)lvlProgration
      withCurrentXpPoints:(float)currentPoints
              withContext:(NSManagedObjectContext *)context
{
    if (xpBarrier&&lvlProgration)
    {
        NSArray *skillArray = [Skill fetchSkillWithId:skillId withContext:context];
        if (skillArray.count!=0&&skillArray)
        {
            Skill *skill = [skillArray lastObject];
            skill.skillTemplate.thisBasicBarrier = xpBarrier;
            skill.skillTemplate.thisSkillProgression=lvlProgration;
            if (currentPoints)
            {
                skill.thisLvlCurrentProgress = currentPoints;
            }
            skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
            return skill;
        }
    }
    return nil;
}


//fetch
+(NSArray *)fetchSkillWithId:(NSString *)skillId withContext:(NSManagedObjectContext *)context
{
    return [Skill fetchRequestForObjectName:@"Skill" withPredicate:[NSPredicate predicateWithFormat:@"skillId = %@",skillId] withContext:context];
}

//delete
+(BOOL)deleteSkillWithId:(NSString *)skillId withContext:(NSManagedObjectContext *)context
{
    return [Skill clearEntityForNameWithObjName:@"Skill" withPredicate:[NSPredicate predicateWithFormat:@"skillId = %@",skillId] withGivenContext:context];
}


@end
