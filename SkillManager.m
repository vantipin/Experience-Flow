//
//  SkillManager.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 25.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "SkillManager.h"
#import "Character.h"
#import "Skill.h"
#import "SkillTemplate.h"
#import "RangeSkill.h"
#import "MeleeSkill.h"
#import "MagicSkill.h"
#import "PietySkill.h"
#import "BasicSkill.h"
#import "CoreDataViewController.h"
#import "SkillSet.h"
#import "DefaultSkillTemplates.h"
#import "CharacterConditionAttributes.h"



static SkillManager *instance = nil;

@interface SkillManager()
@property (nonatomic) NSManagedObjectContext *context;
@end


@implementation SkillManager

+ (SkillManager *)sharedInstance {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        if (!instance) {
            instance = [[SkillManager alloc] init];
            //atexit(deallocSingleton);
        }
    });
    
    return instance;
}

-(NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [[CoreDataViewController sharedInstance] managedObjectContext];
    }
    return _context;
}

#pragma mark -

-(int)hitpointsForSkillWithTemplate:(SkillTemplate *)skillTemplate withSkillLevel:(int)skillLevel
{
    NSInteger Hp = 0;
    
    NSInteger value = skillTemplate.skillStartingLvl;
    if (value < skillLevel){
        if ([skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].toughness.name]){
            Hp = 10 * (skillLevel - value);
        }
        else{
            Hp = 1 * (skillLevel - value);
        }
        
    }
    
    return (int)Hp;
}

-(int)countHpWithCharacter:(Character *)character
{
    int Hp = 0;
    
    if (character)
    {
        Hp += character.skillSet.wounds * 25;
        
        //check if players coreskillset if full
        //he always must have certain skills!!
        NSArray *skills = [character.skillSet.skills allObjects];
        NSMutableArray *skillNames = [NSMutableArray new];
        for (Skill *singleSkill in skills)
        {
            [skillNames addObject:singleSkill.skillTemplate.name];
        }
        
        NSArray *skillsTemplates = [[DefaultSkillTemplates sharedInstance] allCoreSkillTemplates];
        for (SkillTemplate *template in skillsTemplates)
        {
            Skill *skill = [self checkedSkillWithTemplate:template withCharacter:character];
            
            Hp += [self hitpointsForSkillWithTemplate:template withSkillLevel:skill.thisLvl];
        }
    }
    
    return Hp;
}

-(id)checkedSkillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character
{
    Skill *skill;
    NSString *skillName = skillTemplate.name;
    NSArray *objects = [Skill fetchRequestForObjectName:[SkillTemplate entityNameForSkillTemplate:skillTemplate] withPredicate:[NSPredicate predicateWithFormat:@"(skillTemplate.name == %@) AND (skillSet.character == %@)",skillName,character] withContext:self.context];
    skill = [objects lastObject];
    
    if (!skill)
    {
        NSLog(@"Warning! Skill with name ""%@"" is missing for character with id %@!",skillTemplate.name,character.characterId);
        if (!character.skillSet) {
            character.skillSet = [NSEntityDescription insertNewObjectForEntityForName:@"SkillSet" inManagedObjectContext:self.context];
        }
        skill = [self addNewSkillWithTempate:skillTemplate toSkillSet:character.skillSet withContext:self.context];
    }
    
    return skill;
}


-(int)countAttacksForMeleeSkill:(NSSet *)skills
{
    int bonus = 0;
    
    if (skills) {
        NSArray *skillsArray = [skills allObjects];
        int tempWs = 0;
        int tempWsCount = 0;
        for (Skill *skill in skillsArray) {
            int skillLvl = skill.thisLvl + (skill.basicSkill ? skill.basicSkill.thisLvl : 0);
            if (skillLvl > 3) {
                tempWs += skillLvl - 3;
                tempWsCount ++;
            }
        }
        tempWs = tempWs / tempWsCount;
        bonus = tempWs / 2;
    }
        
    return bonus;
}

-(int)countAttacksForRangeSkill:(RangeSkill *)skill;
{
    int bonus = 0;
    
    if (skill) {
        int skillLvl = skill.thisLvl + (skill.basicSkill ? skill.basicSkill.thisLvl : 0);
        if (skillLvl > 3) {
            int temp = skillLvl- 3;
            bonus = temp / 3;
        }
    }
    
    return bonus;
}

-(int)countWSforMeleeSkill:(NSSet *)skills
{
    int ws = 0;// = skill.thisLvl;
    
    if (skills) {
        NSArray *skillsArray = [skills allObjects];
        int wsPenalty = 0;
        int wsPenaltiesCount = 0;
        for (Skill *skill in skillsArray) {
            int skillLvl = skill.thisLvl + (skill.basicSkill ? skill.basicSkill.thisLvl : 0);
            ws += skillLvl;
            if (skillLvl > 3) {
                int tempSkill = skillLvl;
                if (tempSkill % 2) {
                    tempSkill --; //odd
                }
                wsPenalty += tempSkill / 3;
                wsPenaltiesCount ++;
            }
        }
        wsPenalty = wsPenalty / wsPenaltiesCount;
        ws = ws / skillsArray.count;
        ws -= wsPenalty;
    }
    
    return ws;
}

-(int)countBSforRangeSkill:(RangeSkill *)skill
{
    int bs = skill.thisLvl + (skill.basicSkill ? skill.basicSkill.thisLvl : 0);;
    
    if (skill) {
        if (bs > 3) {
            int tempSkill = bs;
            if (tempSkill % 2) {
                tempSkill --; //odd
            }
            bs -= tempSkill / 3;
        }
    }
    
    return bs;
}

-(int)countDCBonusForRangeSkill:(RangeSkill *)skill
{
    int bonus = 0;
    
    if (skill) {
        int skillLvl = skill.thisLvl + (skill.basicSkill ? skill.basicSkill.thisLvl : 0);
        if (skillLvl > 3) {
            int temp = skillLvl - 3;
            bonus = temp / 2;
        }
    }
    
    return bonus;
}


-(Skill *)addNewSkillWithTempate:(SkillTemplate *)skillTemplate
                      toSkillSet:(SkillSet *)skillSet
                     withContext:(NSManagedObjectContext *)context;
{
    if (skillTemplate)
    {
        //check if skill with such name exist and deny update
        NSString *skillType = [SkillTemplate entityNameForSkillTemplate:skillTemplate];
        NSPredicate *predicateTemplate = [NSComparisonPredicate predicateWithFormat:@"(skillSet = %@) AND (skillTemplate.name = %@)",skillSet,skillTemplate.name];
        NSArray *alreadyExist = [CoreDataClass fetchRequestForObjectName:skillType withPredicate:predicateTemplate withContext:context];
        if (alreadyExist && alreadyExist.count!=0) {
            return [alreadyExist lastObject];
        }
        
        
        Skill *skill = [Skill newSkillWithTemplate:skillTemplate withBasicSkill:nil withCurrentXpPoints:0 withContext:context];
        [skillSet addSkillsObject:skill];
        skill.skillSet = skillSet;
        
        //check if skill has any parent skills for this character created and link them
        //if not - in addition create parent skill
        if (skillTemplate.basicSkillTemplate)
        {
            Skill *basicSkill = [self addNewSkillWithTempate:skillTemplate.basicSkillTemplate toSkillSet:skillSet withContext:context];
            skill.basicSkill = basicSkill;
            [basicSkill addSubSkillsObject:skill];
        }
        
        [CoreDataClass saveContext:context];
        
        return skill;
    }
    return nil;
}

-(void)checkAllCharacterCoreSkills:(Character *)character
{
    NSArray *coreSkillTemplates = [DefaultSkillTemplates sharedInstance].allCoreSkillTemplates;
    for (SkillTemplate *skillTemplate in coreSkillTemplates) {
        [self checkedSkillWithTemplate:skillTemplate withCharacter:character];
    }
}

-(SkillSet *)cloneSkillsWithSkillSet:(SkillSet *)skillSetToClone
{
    
    SkillSet *skillSet = [NSEntityDescription
                          insertNewObjectForEntityForName:@"SkillSet"
                          inManagedObjectContext:self.context];
    
    if (skillSetToClone) {
        skillSet.wounds = skillSetToClone.wounds;
        skillSet.modifierAMelee = skillSetToClone.modifierAMelee;
        skillSet.modifierARange = skillSetToClone.modifierARange;
        skillSet.modifierArmorSave = skillSetToClone.modifierArmorSave;
        skillSet.modifierHp = skillSetToClone.modifierHp;
        
        for (Skill *skill in skillSetToClone.skills) {
            Skill *clonedSkill = [self addNewSkillWithTempate:skill.skillTemplate toSkillSet:skillSet withContext:self.context];
            clonedSkill.thisLvl = skill.thisLvl;
        }
    }
    
    return skillSet;
}

#pragma mark -
#pragma mark skill raising methods
//update
-(void)addSolidLvls:(int)levels
            toSkill:(Skill *)skill
        withContext:(NSManagedObjectContext *)context;
{
    if (levels && levels > 0) {
        //For basic skill
        if (skill.basicSkill) {
            int totalXpPoints = 0;
            
            for (int i = skill.thisLvl; i <= levels + skill.thisLvl; i++) {
                totalXpPoints += i * skill.skillTemplate.thisSkillProgression + skill.skillTemplate.thisBasicBarrier;
            }
            
            totalXpPoints += totalXpPoints/skill.skillTemplate.basicSkillGrowthGoes - skill.thisLvlCurrentProgress;
            
            [self addXpPoints:totalXpPoints toSkill:skill withContext:context];
        }
        else {
            skill.thisLvl = skill.thisLvl + levels;
        }
        
        [SkillTemplate saveContext:context];
    }
}



-(void)removeSolidLvls:(int)levels
               toSkill:(Skill *)skill
           withContext:(NSManagedObjectContext *)context;
{
    if (levels && levels > 0) {
        for (int i = 0; i < levels; i++) {
            //xp needed to gain this lvl
            int thisLvlXpWithoutBasicSkill = (skill.thisLvl-1) * skill.skillTemplate.thisSkillProgression + skill.skillTemplate.thisBasicBarrier;
            BOOL hasValidBasicSkill = (skill.skillTemplate.basicSkillGrowthGoes !=0 && skill.basicSkill);
            int thisLvlXp = hasValidBasicSkill ? thisLvlXpWithoutBasicSkill * skill.skillTemplate.basicSkillGrowthGoes : thisLvlXpWithoutBasicSkill;
            
            [self removeXpPoints:thisLvlXp toSkill:skill withContext:context];
        }
        
        [SkillTemplate saveContext:context];
    }
}

-(float)xpPoints:(float)xpPoints forSkill:(Skill *)skill
{
    float resultXpPoints = xpPoints;
    if (skill.basicSkill) {
        resultXpPoints -= [self xpPoints:xpPoints forBasicSkillOfSkill:skill];
    }
    return resultXpPoints;
}

-(float)xpPoints:(float)xpPoints forBasicSkillOfSkill:(Skill *)skill
{
    float resultXpPoints = 0;
    float safeFilter = (skill.skillTemplate.basicSkillGrowthGoes > 1) ? 1 : skill.skillTemplate.basicSkillGrowthGoes;
    resultXpPoints = safeFilter * xpPoints;
    return resultXpPoints;
}


-(void)addXpPoints:(float)xpPoints
           toSkill:(Skill *)skill
       withContext:(NSManagedObjectContext *)context;
{
    if (xpPoints) {
        //calculate xp
        if (skill.skillTemplate.basicSkillGrowthGoes != 0 && skill.basicSkill) {
            [self addXpPoints:[self xpPoints:xpPoints forBasicSkillOfSkill:skill] toSkill:skill.basicSkill withContext:context];
        }
        
        skill.thisLvlCurrentProgress += [self xpPoints:xpPoints forSkill:skill];
        skill = [self calculateAddingXpPointsForSkill:skill WithContext:context];
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        
        [Skill saveContext:context];
    }
}

-(Skill *)calculateAddingXpPointsForSkill:(Skill *)skill WithContext:(NSManagedObjectContext *)context
{
    float xpNextLvl = skill.thisLvl * skill.skillTemplate.thisSkillProgression + skill.skillTemplate.thisBasicBarrier;
    
    if (skill.thisLvlCurrentProgress >= xpNextLvl) {
        skill.thisLvlCurrentProgress -= xpNextLvl;
        skill.thisLvl ++;
        [self.delegate didChangeSkillLevel];
        [self calculateAddingXpPointsForSkill:skill WithContext:context]; //check if more than 1 lvl
    }
    
    return skill;
}

-(void)removeXpPoints:(float)xpPoints
              toSkill:(Skill *)skill
          withContext:(NSManagedObjectContext *)context;
{
    if (xpPoints)
    {
        if (skill.skillTemplate.basicSkillGrowthGoes != 0 && skill.basicSkill) {
            [self removeXpPoints:[self xpPoints:xpPoints forBasicSkillOfSkill:skill] toSkill:skill.basicSkill withContext:context];
        }
        
        skill.thisLvlCurrentProgress -= [self xpPoints:xpPoints forSkill:skill];
        skill = [self calculateRemovingXpPointsForSkill:skill WithContext:context];
        skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
        
        [Skill saveContext:context];
    }
}

-(Skill *)calculateRemovingXpPointsForSkill:(Skill *)skill WithContext:(NSManagedObjectContext *)context
{
    if (skill.thisLvl == 0) {
        skill.thisLvlCurrentProgress = (skill.thisLvlCurrentProgress < 0) ? 0 : skill.thisLvlCurrentProgress;
        return skill;
    }
    if (skill.thisLvlCurrentProgress < 0) {
        skill.thisLvl --;
        [self.delegate didChangeSkillLevel];
        float xpPrevLvl = skill.thisLvl * skill.skillTemplate.thisSkillProgression + skill.skillTemplate.thisBasicBarrier;
        skill.thisLvlCurrentProgress += xpPrevLvl;
        [self calculateRemovingXpPointsForSkill:skill WithContext:context];
    }
    
    return skill;
}
@end
