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
@property (nonatomic) UIView *activeTipView;
@property (nonatomic) NSMutableArray *subscribersForSkillsChangeNotifications;
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

-(NSMutableArray *)subscribersForSkillsChangeNotifications
{
    if (!_subscribersForSkillsChangeNotifications) {
        _subscribersForSkillsChangeNotifications = [NSMutableArray new];
    }
    
    return _subscribersForSkillsChangeNotifications;
}

-(NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [[MainContextObject sharedInstance] managedObjectContext];
    }
    return _context;
}

#pragma mark -
#pragma mark subscribe methods
-(void)subscribeForSkillsChangeNotifications:(id<SkillChangeProtocol>)objectToSubscribe
{
    if (![self.subscribersForSkillsChangeNotifications containsObject:objectToSubscribe]) {
        [self.subscribersForSkillsChangeNotifications addObject:objectToSubscribe];
    }
}

-(void)unsubscribeForSkillChangeNotifications:(id<SkillChangeProtocol>)objectToUnsubscribe {
    if ([self.subscribersForSkillsChangeNotifications containsObject:objectToUnsubscribe]) {
        [self.subscribersForSkillsChangeNotifications removeObject:objectToUnsubscribe];
    }
}

-(void)didChangeSkillLevel:(Skill *)skill
{
    for (id object in self.subscribersForSkillsChangeNotifications) {
        if ([object respondsToSelector:@selector(didChangeSkillLevel:)]) {
            [object didChangeSkillLevel:skill];
        }
    }
}

-(void)didChangeExperiencePointsForSkill:(Skill *)skill
{
    for (id object in self.subscribersForSkillsChangeNotifications) {
        if ([object respondsToSelector:@selector(didChangeExperiencePointsForSkill:)]) {
            [object didChangeExperiencePointsForSkill:skill];
        }
    }
}

-(void)didFinishChangingExperiencePointsForSkill:(Skill *)skill
{
    for (id object in self.subscribersForSkillsChangeNotifications) {
        if ([object respondsToSelector:@selector(didFinishChangingExperiencePointsForSkill:)]) {
            [object didFinishChangingExperiencePointsForSkill:skill];
        }
    }
}

-(void)addedSkill:(Skill *)skill toSkillSet:(SkillSet *)skillSet
{
    for (id object in self.subscribersForSkillsChangeNotifications) {
        if ([object respondsToSelector:@selector(addedSkill:toSkillSet:)]) {
            [object addedSkill:skill toSkillSet:skillSet];
        }
    }
}

-(void)deletedSkill:(Skill *)skill fromSkillSet:(SkillSet *)skillSet
{
    for (id object in self.subscribersForSkillsChangeNotifications) {
        if ([object respondsToSelector:@selector(deletedSkill:fromSkillSet:)]) {
            [object deletedSkill:skill fromSkillSet:skillSet];
        }
    }
}

#pragma mark -

#pragma mark game mechanics interpretation methods

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
            
            Hp += [self hitpointsForSkillWithTemplate:template withSkillLevel:skill.currentLevel];
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
            int skillLvl = [[SkillManager sharedInstance] countUsableLevelValueForSkill:skill];
            if (skillLvl > 3) {
                tempWs += skillLvl - 3;
                tempWsCount ++;
            }
        }
        
        if (tempWs) {
            tempWs = tempWs / tempWsCount;
            bonus = tempWs / 2;
        }
    }
        
    return bonus;
}

-(int)countAttacksForRangeSkill:(RangeSkill *)skill;
{
    int bonus = 0;
    
    if (skill) {
        int skillLvl = [[SkillManager sharedInstance] countUsableLevelValueForSkill:skill];
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
            
            int skillLvl = [[SkillManager sharedInstance] countUsableLevelValueForSkill:skill];
            ws += skillLvl;
            if (skillLvl > 4) {
                int tempSkill = skillLvl;
                if (!(tempSkill % 2)) {
                    tempSkill --; //even
                }
                wsPenalty += tempSkill / 3;
                wsPenaltiesCount ++;
            }
        }
        
        if (wsPenalty) {
            wsPenalty = wsPenalty / wsPenaltiesCount;
        }
        ws = ws / skillsArray.count;
        ws -= wsPenalty;
    }
    
    return ws;
}

-(int)countBSforRangeSkill:(RangeSkill *)skill
{
    int bs = [[SkillManager sharedInstance] countUsableLevelValueForSkill:skill];
    
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
        int skillLvl = [[SkillManager sharedInstance] countUsableLevelValueForSkill:skill];
        if (skillLvl > 3) {
            int temp = skillLvl - 3;
            bonus = temp / 2;
        }
    }
    
    return bonus;
}

-(int)countUsableLevelValueForSkill:(Skill *)skill
{
    int overAllLevel = skill.currentLevel + (skill.basicSkill ? [self countUsableLevelValueForSkill:skill.basicSkill] : 0);
    return overAllLevel;
}

-(int)countPositionYInATreeForSkill:(SkillTemplate *)skillTemplate;
{
    int numberOfSkills = 1 + (skillTemplate.basicSkillTemplate ? [self countPositionYInATreeForSkill:skillTemplate.basicSkillTemplate] : 0);
    return numberOfSkills;
}

-(float)countXpNeededForNextLevel:(Skill *)skill;
{
    return (skill.currentLevel * skill.skillTemplate.levelProgression + skill.skillTemplate.levelBasicBarrier);
}

-(NSInteger)countPositionXInATreeForSkill:(SkillTemplate *)skillTemplate;
{
    NSInteger position = 0;
    if (skillTemplate.basicSkillTemplate) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
        NSArray *sortedArray = [skillTemplate.basicSkillTemplate.subSkillsTemplate sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        position = [sortedArray indexOfObject:skillTemplate] + [self countNumberOfSiblingsInTreeBeforeSkill:skillTemplate];
    }
    return position;
}

-(NSInteger)countNumberOfSiblingsInTreeBeforeSkill:(SkillTemplate *)skill
{
    NSInteger siblings = 0;
    if (skill.basicSkillTemplate) {
        siblings += skill.basicSkillTemplate.subSkillsTemplate.count + [self countNumberOfSiblingsInTreeBeforeSkill:skill.basicSkillTemplate];
    }
    return siblings;
}

-(SkillTemplate *)getRootSkillWithSkill:(SkillTemplate *)skill
{
    SkillTemplate *root = skill;
    if (skill.basicSkillTemplate) {
        root = [self getRootSkillWithSkill:skill.basicSkillTemplate];
    }
    return root;
}

#pragma mark smart adding/removing methods
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
        
        //[self.delegateSkillChange addedSkill:skill toSkillSet:skillSet];
        [self addedSkill:skill toSkillSet:skillSet];
        
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
            //[self.delegateSkillChange deletedSkill:skill fromSkillSet:skillSet];
            [self deletedSkill:skill fromSkillSet:skillSet];
            
            [context deleteObject:skill];
            [CoreDataClass saveContext:context];
            return true;
        }
    }
    return false;
}

-(void)checkAllCharacterCoreSkills:(Character *)character
{
    //TODO allCoreSkillTemplates replaced with allSkillTemplates
    NSArray *coreSkillTemplates = [DefaultSkillTemplates sharedInstance].allSkillTemplates;
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
            clonedSkill.currentLevel = skill.currentLevel;
            clonedSkill.currentProgress = skill.currentProgress;
        }
    }
    
    return skillSet;
}

#pragma mark -
#pragma mark skill raising methods

-(void)setLevelOfSkill:(Skill *)skill toLevel:(float)level;
{
    if (skill.basicSkill) {
        //phase 1
        //get statistic
        NSMutableArray *skillsToWorkWith = [NSMutableArray new];
        NSMutableArray *requiredLevels = [NSMutableArray new];
        Skill *parentSkill = skill.basicSkill;
        
        for (Skill* subSkill in parentSkill.subSkills) {
            BOOL isValidTriggerSkill = subSkill == skill && level != 0;
            BOOL skillNotNil = subSkill.currentLevel || subSkill.currentProgress;
            if (isValidTriggerSkill || skillNotNil) {
                [skillsToWorkWith addObject:subSkill];
                
                float levelRequired = (skill == subSkill) ? level : subSkill.currentLevel + parentSkill.currentLevel;
                [requiredLevels addObject:@(levelRequired)];
            }
        }
        
        //count xp for the big one to weed off unable req
        for (int basicSkillLevel = 1; basicSkillLevel < 10; basicSkillLevel++) {
            
            float xpPointsForBasicSkill = 0;
            NSMutableArray *xpPointsForEachSkill = [NSMutableArray new];
            
            NSMutableArray *xpForLevelsOfEachSkill = [NSMutableArray new];
            float summOfLevelsXp = 0;
            
            //phase 1 (common)
            for (int index = 0; index < skillsToWorkWith.count; index++) {
                Skill *subSkill = skillsToWorkWith[index];
                float subSkillLevel = [requiredLevels[index] floatValue] - basicSkillLevel;
                //subSkillLevel = subSkillLevel < 0 ? 0 : subSkillLevel;
                
                float xpPointsForSkill = subSkill.skillTemplate.levelBasicBarrier * subSkillLevel + subSkill.skillTemplate.levelProgression / 2 *subSkillLevel * (subSkillLevel - 1);

                
                //counted for phase 2
                float xpForLevelForThisSkill = subSkill.skillTemplate.levelBasicBarrier + subSkillLevel * subSkill.skillTemplate.levelProgression;
                [xpForLevelsOfEachSkill addObject:@(xpForLevelForThisSkill)];
                summOfLevelsXp += xpForLevelForThisSkill;
                //
                
                xpPointsForBasicSkill += subSkill.skillTemplate.levelGrowthGoesToBasicSkill * xpPointsForSkill;
                
                //round it?
                xpPointsForSkill = [[NSString stringWithFormat:@"%0.3f",xpPointsForSkill] floatValue];
                [xpPointsForEachSkill addObject:@(xpPointsForSkill)];
            }
            
            float indicator = xpPointsForBasicSkill - parentSkill.skillTemplate.levelBasicBarrier * basicSkillLevel - parentSkill.skillTemplate.levelProgression / 2 * basicSkillLevel * (basicSkillLevel - 1);
            
            
            if (indicator < (parentSkill.skillTemplate.levelBasicBarrier + basicSkillLevel * parentSkill.skillTemplate.levelProgression)) {
                //if solution found
                //phase 2
                if (indicator <= 0) {
                    //if solution needs adjustment
                    indicator *= -1;
                    float modifierForBasicSkill = 0;
                    for (int i = 0; i < xpPointsForEachSkill.count; i++) {

                        float xpForSkill = [xpPointsForEachSkill[i] floatValue];
                        
                        float xpModifier = indicator * xpForSkill / summOfLevelsXp;
                        //float xpModifier = indicator * xpForSkill / xpPointsForBasicSkill;
                        Skill *subSkill = skillsToWorkWith[i];

                        
                        if (xpModifier > xpForSkill) {
                            NSLog(@"xpModifier %f! for skill %@",xpModifier,subSkill.skillTemplate.name);
                            return;
                        }
                        
                        xpForSkill += xpModifier;
                        xpPointsForEachSkill[i] = @(xpForSkill);
                        
                        modifierForBasicSkill += subSkill.skillTemplate.levelGrowthGoesToBasicSkill * xpModifier;
                        
                    }
                    xpPointsForBasicSkill += modifierForBasicSkill;
                }
                
                parentSkill.currentLevel = 0;
                parentSkill.currentProgress = 0;
                
                
                //process and implement current solution
                parentSkill.currentProgress = xpPointsForBasicSkill;
                [self calculateAddingXpPointsForSkill:parentSkill];
                
                //hard fix data
                NSMutableArray *hardFix = [NSMutableArray new]; //need better solution
                BOOL needEncreaseLevel = false;
                BOOL needEncreaseParentSkill = true;
                //
                
                for (int i = 0; i < xpPointsForEachSkill.count; i++) {
                    Skill *subSkill = skillsToWorkWith[i];
                    subSkill.currentLevel = 0;
                    subSkill.currentProgress = 0;
                    float xpPointsForSkill = [xpPointsForEachSkill[i] floatValue];
                    if (xpPointsForSkill < 0) {
                        NSLog(@"xpPointsForSkill %f!",xpPointsForSkill);
                        continue;
                    }
                    
                    subSkill.currentProgress = xpPointsForSkill;
                    [self calculateAddingXpPointsForSkill:subSkill];
                    
                    //hard fix calculation
                    int req = [requiredLevels[i] intValue];
                    [hardFix addObject:@(req - (subSkill.currentLevel + parentSkill.currentLevel))];
                    if (i) {
                        int prev = [hardFix[i - 1] intValue];
                        if (req) {
                            needEncreaseLevel = true;
                            if (prev != req) {
                                needEncreaseParentSkill = false;
                            }
                        }
                    }
                    //
                    
                    if (!needEncreaseLevel) {
                        [self didChangeExperiencePointsForSkill:subSkill];
                    }
                    
                }
                
                if (needEncreaseLevel) {
                    if (needEncreaseParentSkill) {
                        int modifier = [[hardFix lastObject] intValue];
                        parentSkill.currentLevel += modifier;
                        NSLog(@"modify parent skill %@ by %d",parentSkill.skillTemplate.name,modifier);
                        [self didChangeExperiencePointsForSkill:parentSkill];
                    }
                    else {
                        for (int i = 0; i < hardFix.count; i++) {
                            Skill *skill = skillsToWorkWith[i];
                            int modifier = [hardFix[i] intValue];
                            skill.currentLevel += modifier;
                            NSLog(@"modify skill %@ by %d",skill.skillTemplate.name,modifier);
                            [self didChangeExperiencePointsForSkill:skill];
                        }
                    }
                }
                
                [Skill saveContext:self.context];
                return;
                
            }
        }
        [Skill saveContext:self.context];
    }
}



-(void)setSkill:(Skill *)skill toLevel:(float)level;
{
    float xpPoints = [self xpPointsToSetSkill:skill toLevel:level];
    skill.currentProgress = xpPoints;
    if (xpPoints > 0) {
        [self calculateAddingXpPointsForSkill:skill];
    }
    else if (xpPoints < 0) {
        [self calculateRemovingXpPointsForSkill:skill];
    }
}


-(float)xpPointsToSetSkill:(Skill *)skill toLevel:(float)requiredLevel
{
    float xpPoints = 0;
    if (skill.currentLevel != requiredLevel) {
        int indicatorAddOrRemovePoints = (skill.currentLevel < requiredLevel) ? 1 : -1;
        
        BOOL isReqGreater = (skill.currentLevel < requiredLevel);
        float eachLevelCore = isReqGreater ? skill.currentLevel : requiredLevel;
        float diffBetweenLevels = isReqGreater ? requiredLevel - skill.currentLevel : skill.currentLevel - requiredLevel;
        float progression = 0;
        for (int i = 0; i < diffBetweenLevels; i++) {
            progression += i;
        }
        xpPoints = (eachLevelCore * diffBetweenLevels + progression) * skill.skillTemplate.levelProgression + skill.skillTemplate.levelBasicBarrier * diffBetweenLevels;
        xpPoints *= indicatorAddOrRemovePoints;
    }
    return xpPoints;
}


-(float)xpPoints:(float)xpPoints forSkill:(Skill *)skill
{
    return xpPoints;
}

-(float)xpPoints:(float)xpPoints forBasicSkillOfSkill:(Skill *)skill
{
    float resultXpPoints = 0;
    float safeFilter = (skill.skillTemplate.levelGrowthGoesToBasicSkill > 1) ? 1 : skill.skillTemplate.levelGrowthGoesToBasicSkill;
    resultXpPoints = safeFilter * xpPoints;
    return resultXpPoints;
}


-(void)addXpPoints:(float)xpPoints
           toSkill:(Skill *)skill;
{
    if (xpPoints) {
        [self changeAddXpPoints:xpPoints toSkill:skill];
        [Skill saveContext:self.context];
        //[self.delegateSkillChange didFinishChangingExperiencePointsForSkill:skill];
        [self didFinishChangingExperiencePointsForSkill:skill];
    }
}


-(void)changeAddXpPoints:(float)xpPoints
                 toSkill:(Skill *)skill;
{
    //calculate xp
    if (skill.skillTemplate.levelGrowthGoesToBasicSkill != 0 && skill.basicSkill) {
        [self changeAddXpPoints:[self xpPoints:xpPoints forBasicSkillOfSkill:skill] toSkill:skill.basicSkill];
    }
    
    skill.currentProgress += [self xpPoints:xpPoints forSkill:skill];
    skill = [self calculateAddingXpPointsForSkill:skill];
    skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
    
    //[self.delegateSkillChange didChangeExperiencePointsForSkill:skill];
    [self didChangeExperiencePointsForSkill:skill];
}

-(Skill *)calculateAddingXpPointsForSkill:(Skill *)skill
{
    float xpNextLvl = [self countXpNeededForNextLevel:skill];
    
    if (skill.currentProgress >= xpNextLvl) {
        skill.currentProgress -= xpNextLvl;
        skill.currentLevel ++;
        [self didChangeSkillLevel:skill];
        [self calculateAddingXpPointsForSkill:skill]; //check if more than 1 lvl
    }
    else if (skill.currentLevel < skill.skillTemplate.skillStartingLvl) {
        skill.currentLevel = skill.skillTemplate.skillStartingLvl;
    }
    
    return skill;
}

-(void)removeXpPoints:(float)xpPoints
              toSkill:(Skill *)skill;
{
    BOOL isLevelContainAnyXpToRemove = (skill.currentProgress || skill.currentLevel);
    if (xpPoints && isLevelContainAnyXpToRemove)
    {
        [self changeRemoveXpPoints:xpPoints toSkill:skill];
        [Skill saveContext:self.context];
        [self didFinishChangingExperiencePointsForSkill:skill];
    }
}

-(void)changeRemoveXpPoints:(float)xpPoints
                    toSkill:(Skill *)skill;
{
    if (skill.skillTemplate.levelGrowthGoesToBasicSkill != 0 && skill.basicSkill) {
        [self changeRemoveXpPoints:[self xpPoints:xpPoints forBasicSkillOfSkill:skill] toSkill:skill.basicSkill];
    }
    
    skill.currentProgress -= [self xpPoints:xpPoints forSkill:skill];
    skill = [self calculateRemovingXpPointsForSkill:skill];
    skill.dateXpAdded = [[NSDate date] timeIntervalSince1970];
    
    //[self.delegateSkillChange didChangeExperiencePointsForSkill:skill];
    [self didChangeExperiencePointsForSkill:skill];
}

-(Skill *)calculateRemovingXpPointsForSkill:(Skill *)skill
{
    if (skill.currentLevel == skill.skillTemplate.skillStartingLvl) {
        skill.currentProgress = (skill.currentProgress < 0) ? 0 : skill.currentProgress;
        return skill;
    }
    
    if (skill.currentProgress < 0) {
        skill.currentLevel --;
        //[self.delegateSkillChange didChangeSkillLevel:skill];
        [self didChangeSkillLevel:skill];
        float xpPrevLvl = [self countXpNeededForNextLevel:skill];
        skill.currentProgress += xpPrevLvl;
        [self calculateRemovingXpPointsForSkill:skill];
    }

    return skill;
}


#pragma mark FETCH objects from Core Data

-(id)getOrAddSkillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character
{
    Skill *skill = [self getSkillWithTemplate:skillTemplate withCharacter:character];
    
    if (!skill)
    {
        //NSLog(@"Warning! Skill with name ""%@"" is missing for character with id %@!",skillTemplate.name,character.name);
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

-(NSArray *)fetchAllSkillsForSkillSet:(SkillSet *)skillSet;
{
    NSMutableArray *allCollection = [NSMutableArray new];
    for (SkillTemplate *skillTemplate in [[DefaultSkillTemplates sharedInstance] allSkillTemplates]) {
        Skill *skill = [self getSkillWithTemplate:skillTemplate withSkillSet:skillSet];
        if (skill) {
            [allCollection addObject:skill];
        }
    }
    return allCollection;
}


-(NSArray *)fetchAllNoneBasicSkillsForSkillSet:(SkillSet *)skillSet;
{
    NSMutableArray *allCollection = [NSMutableArray new];
    for (SkillTemplate *skillTemplate in [[DefaultSkillTemplates sharedInstance] allSkillTemplates]) {
        if (skillTemplate.skillEnumType != BasicSkillType) {
            Skill *skill = [self getSkillWithTemplate:skillTemplate withSkillSet:skillSet];
            if (skill) {
                [allCollection addObject:skill];
            }
        }
    }
    return allCollection;
}

-(void)clearSkillTemplate;
{
    [SkillTemplate clearEntityForNameWithObjName:@"SkillTemplate" withPredicate:nil withGivenContext:self.context];
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
    
    NSString *description = @"";
    
    if (skillTemplate.skillDescription) {
        description = [description stringByAppendingString:skillTemplate.skillDescription];
    }
    if (skillTemplate.skillRules) {
        description = [description stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",skillTemplate.skillRules]];
    }
    if (skillTemplate.skillRulesExamples) {
        description = [description stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",skillTemplate.skillRulesExamples]];
    }
    
    [tipTextView setText:description];
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
    [self.activeTipView setBackgroundColor:kRGB(220, 220, 220, 0.3)];
    tipTextView.center = parentView.center;
    
    CALayer *imageLayer = tipTextView.layer;
    [imageLayer setCornerRadius:15];
    [imageLayer setMasksToBounds:YES];
    
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
