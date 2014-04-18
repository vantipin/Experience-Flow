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
#import "MainContextObject.h"
#import "SkillSet.h"
#import "DefaultSkillTemplates.h"
#import "CharacterConditionAttributes.h"
#import "ColorConstants.h"



static SkillManager *instance = nil;

@interface SkillManager()
@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) int currentOverallLevelValueForASkill;
@property (nonatomic) UIView *activeTipView;
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
        _context = [[MainContextObject sharedInstance] managedObjectContext];
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
            Hp = 5 * (skillLevel - value);
        }
        else if ([skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].physique.name]){
            Hp = 5 * (skillLevel - value);
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
        Hp += character.skillSet.bulk * 25;
        
        NSArray *skills = [character.skillSet.skills allObjects];
        NSMutableArray *skillNames = [NSMutableArray new];
        for (Skill *singleSkill in skills) {
            [skillNames addObject:singleSkill.skillTemplate.name];
        }
        
        NSArray *skillsTemplates = [[DefaultSkillTemplates sharedInstance] allCoreSkillTemplates];
        for (SkillTemplate *template in skillsTemplates)
        {
            Skill *skill = [self getOrAddSkillWithTemplate:template withCharacter:character];
            
            Hp += [self hitpointsForSkillWithTemplate:template withSkillLevel:skill.thisLvl];
        }
    }
    
    return Hp;
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


-(int)countUsableLevelValueForSkill:(Skill *)skill;
{
    self.currentOverallLevelValueForASkill = 0;
    [self encreaseCurrentOverallSkillValueForSkill:skill];
    return self.currentOverallLevelValueForASkill;
}

-(void)encreaseCurrentOverallSkillValueForSkill:(Skill *)skill
{
    self.currentOverallLevelValueForASkill += skill.thisLvl;
    if (skill.basicSkill) {
        [self encreaseCurrentOverallSkillValueForSkill:skill.basicSkill];
    }
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
        
        [self.delegateSkillChange addedSkill:skill toSkillSet:skillSet];
        
        [CoreDataClass saveContext:context];
        
        return skill;
    }
    return nil;
}

-(BOOL)removeSkillWithTemplate:(SkillTemplate *)skillTemplate
                  fromSkillSet:(SkillSet *)skillSet
                   withContext:(NSManagedObjectContext *)context;
{
    if (skillTemplate)
    {
        //check if skill with such name exist
        NSString *skillType = [SkillTemplate entityNameForSkillTemplate:skillTemplate];
        NSPredicate *predicateTemplate = [NSComparisonPredicate predicateWithFormat:@"(skillSet = %@) AND (skillTemplate.name = %@)",skillSet,skillTemplate.name];
        NSArray *alreadyExist = [CoreDataClass fetchRequestForObjectName:skillType withPredicate:predicateTemplate withContext:context];
        if (alreadyExist && alreadyExist.count!=0) {
            Skill *skill = [alreadyExist lastObject];
            NSArray *allSubSkills = [[skill.subSkills allObjects] copy];
            for (Skill *subSkill in allSubSkills) {
                if (subSkill) {
                    [self removeSkillWithTemplate:subSkill.skillTemplate fromSkillSet:skillSet withContext:context];
                }
            }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
            [skillSet removeSkillsObject:skill];
            [self.delegateSkillChange deletedSkill:skill fromSkillSet:skillSet];
            
            [context deleteObject:skill];
            [CoreDataClass saveContext:context];
            return true;
        }
    }
    return false;
}

-(void)checkAllCharacterCoreSkills:(Character *)character
{
    NSArray *coreSkillTemplates = [DefaultSkillTemplates sharedInstance].allCoreSkillTemplates;
    for (SkillTemplate *skillTemplate in coreSkillTemplates) {
        [self getOrAddSkillWithTemplate:skillTemplate withCharacter:character];
    }
}

-(SkillSet *)cloneSkillsWithSkillSet:(SkillSet *)skillSetToClone
{
    
    SkillSet *skillSet = [NSEntityDescription
                          insertNewObjectForEntityForName:@"SkillSet"
                          inManagedObjectContext:self.context];
    
    if (skillSetToClone) {
        skillSet.bulk = skillSetToClone.bulk;
        skillSet.modifierAMelee = skillSetToClone.modifierAMelee;
        skillSet.modifierARange = skillSetToClone.modifierARange;
        skillSet.modifierArmorSave = skillSetToClone.modifierArmorSave;
        skillSet.modifierHp = skillSetToClone.modifierHp;
        skillSet.pace = skillSetToClone.pace;
        
        for (Skill *skill in skillSetToClone.skills) {
            Skill *clonedSkill = [self addNewSkillWithTempate:skill.skillTemplate toSkillSet:skillSet withContext:self.context];
            clonedSkill.thisLvl = skill.thisLvl;
            clonedSkill.thisLvlCurrentProgress = skill.thisLvlCurrentProgress;
        }
    }
    
    return skillSet;
}

#pragma mark -
#pragma mark skill raising methods
//-(void)setSolidLvls:(int)levels
//            toSkill:(Skill *)skill
//        withContext:(NSManagedObjectContext *)context;
//{
//    for (Skill *subSkill in skill.subSkills) {
//        [self nullifyProgressOfSubskillsWithSkill:subSkill];
//    }
//    
//    float xpPointsNeeded = 0;
//    for (int level = 0; level < skill.thisLvl; level ++) {
//        float xpPointsForThisLevel = skill.skillTemplate.thisBasicBarrier + level * skill.skillTemplate.thisSkillProgression;
//        if (skill.skillTemplate.basicSkillGrowthGoes != 0) {
//            xpPointsForThisLevel = xpPointsForThisLevel / skill.skillTemplate.basicSkillGrowthGoes;
//        }
//        
//        xpPointsNeeded += xpPointsForThisLevel;
//    }
//    [self removeXpPoints:xpPointsNeeded toSkill:skill withContext:context];
//    
//    // TODO the difficlt part how set the chain of skills to one value?
//    [self encreaseValueOfSkill:skill to:levels withContext:context];
//
//}
//
//
//-(void)encreaseValueOfSkill:(Skill *)skill to:(int)level withContext:(NSManagedObjectContext *)context {
//    
//    int currentLevels = [self countUsableLevelValueForSkill:skill];
//    
//    while (currentLevels < level) {
//        [self addXpPoints:1 toSkill:skill withContext:context];
//        currentLevels = [self countUsableLevelValueForSkill:skill];
//    }
//}
//
//-(void)nullifyProgressOfSubskillsWithSkill:(Skill *)skill
//{
//    if (skill.thisLvl != 0 || skill.thisLvlCurrentProgress != 0) {
//        skill.thisLvlCurrentProgress = 0;
//        skill.thisLvl = 0;
//        
//        for (Skill *subSkill in skill.subSkills) {
//            [self nullifyProgressOfSubskillsWithSkill:subSkill];
//        }
//    }
//}


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
        [self changeAddXpPoints:xpPoints toSkill:skill withContext:context];
        [Skill saveContext:context];
        [self.delegateSkillChange didFinishChangingExperiencePointsForSkill:skill];
    }
}


-(void)changeAddXpPoints:(float)xpPoints
                 toSkill:(Skill *)skill
             withContext:(NSManagedObjectContext *)context;
{
    //calculate xp
    if (skill.skillTemplate.basicSkillGrowthGoes != 0 && skill.basicSkill) {
        [self changeAddXpPoints:[self xpPoints:xpPoints forBasicSkillOfSkill:skill] toSkill:skill.basicSkill withContext:context];
    }
    
    skill.thisLvlCurrentProgress += [self xpPoints:xpPoints forSkill:skill];
    skill = [self calculateAddingXpPointsForSkill:skill WithContext:context];
    skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
    
    [self.delegateSkillChange didChangeExperiencePointsForSkill:skill];
}

-(Skill *)calculateAddingXpPointsForSkill:(Skill *)skill WithContext:(NSManagedObjectContext *)context
{
    float xpNextLvl = skill.thisLvl * skill.skillTemplate.thisSkillProgression + skill.skillTemplate.thisBasicBarrier;
    
    if (skill.thisLvlCurrentProgress >= xpNextLvl) {
        skill.thisLvlCurrentProgress -= xpNextLvl;
        skill.thisLvl ++;
        [self.delegateSkillChange didChangeSkillLevel:skill];
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
        [self changeRemoveXpPoints:xpPoints toSkill:skill withContext:context];
        [Skill saveContext:context];
        [self.delegateSkillChange didFinishChangingExperiencePointsForSkill:skill];
    }
}

-(void)changeRemoveXpPoints:(float)xpPoints
                    toSkill:(Skill *)skill
                withContext:(NSManagedObjectContext *)context;
{
    if (skill.skillTemplate.basicSkillGrowthGoes != 0 && skill.basicSkill) {
        [self changeRemoveXpPoints:[self xpPoints:xpPoints forBasicSkillOfSkill:skill] toSkill:skill.basicSkill withContext:context];
    }
    
    skill.thisLvlCurrentProgress -= [self xpPoints:xpPoints forSkill:skill];
    skill = [self calculateRemovingXpPointsForSkill:skill WithContext:context];
    skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
    
    [self.delegateSkillChange didChangeExperiencePointsForSkill:skill];
}

-(Skill *)calculateRemovingXpPointsForSkill:(Skill *)skill WithContext:(NSManagedObjectContext *)context
{
    if (skill.thisLvl == 0) {
        skill.thisLvlCurrentProgress = (skill.thisLvlCurrentProgress < 0) ? 0 : skill.thisLvlCurrentProgress;
        return skill;
    }
    if (skill.thisLvlCurrentProgress < 0) {
        skill.thisLvl --;
        [self.delegateSkillChange didChangeSkillLevel:skill];
        float xpPrevLvl = skill.thisLvl * skill.skillTemplate.thisSkillProgression + skill.skillTemplate.thisBasicBarrier;
        skill.thisLvlCurrentProgress += xpPrevLvl;
        [self calculateRemovingXpPointsForSkill:skill WithContext:context];
    }

    return skill;
}


#pragma mark FETCH objects from Core Data

-(id)getOrAddSkillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character
{
    Skill *skill = [self getSkillWithTemplate:skillTemplate withCharacter:character];
    
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

-(id)getSkillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character
{
    Skill *skill;
    NSString *skillName = skillTemplate.name;
    NSArray *objects = [Skill fetchRequestForObjectName:[SkillTemplate entityNameForSkillTemplate:skillTemplate] withPredicate:[NSPredicate predicateWithFormat:@"(skillTemplate.name == %@) AND (skillSet.character == %@)",skillName,character] withContext:self.context];
    skill = [objects lastObject];
    
    return skill;
}

-(id)getSkillWithTemplate:(SkillTemplate *)skillTemplate withSkillSet:(SkillSet *)skillSet
{
    Skill *skill;
    NSString *skillName = skillTemplate.name;
    NSArray *objects = [Skill fetchRequestForObjectName:[SkillTemplate entityNameForSkillTemplate:skillTemplate] withPredicate:[NSPredicate predicateWithFormat:@"(skillTemplate.name == %@) AND (skillSet == %@)",skillName,skillSet] withContext:self.context];
    skill = [objects lastObject];
    
    return skill;
}

-(NSArray *)fetchAllNoneBasicSkillsForSkillSet:(SkillSet *)skillSet;
{
    NSMutableArray *allCollection = [NSMutableArray new];
    for (SkillTemplate *skillTemplate in [[DefaultSkillTemplates sharedInstance] allNoneCoreSkillTemplates]) {
        if (skillTemplate.skillEnumType != BasicSkillType) {
            Skill *skill = [self getSkillWithTemplate:skillTemplate withSkillSet:skillSet];
            if (skill) {
                [allCollection addObject:skill];
            }
        }
    }
    return allCollection;
}

#pragma mark tips and descriptions

-(void)showDescriptionForSkillTemplate:(SkillTemplate *)skillTemplate inView:(UIView *)parentView
{
    CGRect closingAreaFrame = parentView.bounds;
    
    float defaultWidht = parentView.bounds.size.width * 0.8;
    float defaultHeight = 10;
    CGRect tipFrame = CGRectMake(0,
                                 0,
                                 defaultWidht,
                                 defaultHeight);
    
    
    UITextView *tipTextView = [[UITextView alloc] initWithFrame:tipFrame];
    [tipTextView setText:skillTemplate.skillDescription];
    [tipTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [tipTextView sizeToFit];
    tipTextView.frame = CGRectMake(tipTextView.frame.origin.x, tipTextView.frame.origin.y, tipTextView.frame.size.width, (tipTextView.frame.size.height > parentView.frame.size.height * 0.8) ? parentView.frame.size.height * 0.8 : tipTextView.frame.size.height);
    tipTextView.scrollEnabled = true;
    
    tipTextView.backgroundColor = [UIColor whiteColor];
    tipTextView.editable = false;
    tipTextView.selectable = false;
    
    UIView *closingAreaView = [[UIView alloc] initWithFrame:closingAreaFrame];
    closingAreaView.opaque = false;
    closingAreaView.backgroundColor = [UIColor clearColor];
    
    self.activeTipView = [[UIView alloc] initWithFrame:closingAreaFrame];
    [self.activeTipView addSubview:closingAreaView];
    [self.activeTipView addSubview:tipTextView];
    [self.activeTipView bringSubviewToFront:tipTextView];
    [self.activeTipView setBackgroundColor:kRGB(220, 220, 220, 0.7)];
    tipTextView.center = parentView.center;
    
    //UITapGestureRecognizer *tapRecognizer;
    //tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTip)];
    //[self.activeTipView addGestureRecognizer:tapRecognizer];
    UIPanGestureRecognizer *panRecognizer;
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeTip)];
    [self.activeTipView addGestureRecognizer:panRecognizer];
    
    
    self.activeTipView.alpha = 0;
    [parentView addSubview:self.activeTipView];
    [parentView bringSubviewToFront:self.activeTipView];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.activeTipView.alpha = 1;
    }];
}

-(void)closeTip
{
    
    if (self.activeTipView) {
        [UIView animateWithDuration:0.15 animations:^{
            self.activeTipView.alpha = 0;
        }];
        
        [self.activeTipView removeFromSuperview];
        self.activeTipView = nil;
    }
}

@end
