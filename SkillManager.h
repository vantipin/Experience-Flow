//
//  SkillManager.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 25.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RangeSkill,MagicSkill,MeleeSkill,AdvancedSkill,Skill,SkillTemplate,Character,CharacterConditionAttributes,SkillSet;

@protocol SkillChangeProtocol <NSObject>
@optional
-(void)didChangeSkillLevel;
@end

@interface SkillManager : NSObject

@property (nonatomic,assign) id<SkillChangeProtocol> delegateSkillChange;

+ (SkillManager *)sharedInstance;

-(int)countHpWithCharacter:(Character *)character;

-(int)countAttacksForMeleeSkill:(NSSet *)skills;
-(int)countAttacksForRangeSkill:(RangeSkill *)skill;
-(int)countWSforMeleeSkill:(NSSet *)skill;
-(int)countBSforRangeSkill:(RangeSkill *)skill;
-(int)countDCBonusForRangeSkill:(RangeSkill *)skill;
-(int)countUsableLevelValueForSkill:(Skill *)skill;

/**
 Add skill to chosen set of skills and return reference pointing on that skill object. If skill with such template already exist - will return old skill.
 */
-(Skill *)addNewSkillWithTempate:(SkillTemplate *)skillTemplate
                      toSkillSet:(SkillSet *)skillSet
                     withContext:(NSManagedObjectContext *)context;
/**
 Remove skill from set of skills and return true if delete war successful. If skill with such template doesn't exist - will return false.
 */
-(BOOL)removeSkillWithTemplate:(SkillTemplate *)skillTemplate
                  fromSkillSet:(SkillSet *)skillSet
                   withContext:(NSManagedObjectContext *)context;


-(void)checkAllCharacterCoreSkills:(Character *)character;

-(SkillSet *)cloneSkillsWithSkillSet:(SkillSet *)skillSetToClone;


/**
 Add expirience points to recieve needed level. Warning! Will reset all child skills.
 */
//-(void)setSolidLvls:(int)levels
//            toSkill:(Skill *)skill
//        withContext:(NSManagedObjectContext *)context;
-(void)addXpPoints:(float)xpPoints
           toSkill:(Skill *)skill
       withContext:(NSManagedObjectContext *)context;
-(void)removeXpPoints:(float)xpPoints
              toSkill:(Skill *)skill
          withContext:(NSManagedObjectContext *)context;


//FETCH
-(id)getOrAddSkillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character;
-(id)getSkillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character;
-(id)getSkillWithTemplate:(SkillTemplate *)skillTemplate withSkillSet:(SkillSet *)skillSet;
-(NSArray *)fetchAllNoneBasicSkillsForSkillSet:(SkillSet *)skillSet;


/**
 *Show scrollable text view to display description for chosen skill. View will disappear on pan outside of text view. 
 */
-(void)showDescriptionForSkillTemplate:(SkillTemplate *)skillTemplate inView:(UIView *)parentView;

@end
