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
-(void)didChangeSkillLevel:(Skill *)skill;

/**
 *Will be called each time some skill xp changed.
 */
-(void)didChangeExperiencePointsForSkill:(Skill*)skill;

/**
 *Will be called only when whole chain of changing xp points finished.
 */
-(void)didFinishChangingExperiencePointsForSkill:(Skill*)skill;
-(void)addedSkill:(Skill *)skill toSkillSet:(SkillSet *)skillSet;
-(void)deletedSkill:(Skill *)skill fromSkillSet:(SkillSet *)skillSet; //call right before deleting
@end


@interface SkillManager : NSObject <SkillChangeProtocol>

//@property (nonatomic,assign) id<SkillChangeProtocol> delegateSkillChange;

+ (SkillManager *)sharedInstance;

-(void)subscribeForSkillsChangeNotifications:(id<SkillChangeProtocol>)objectToSubscribe;
-(void)unsubscribeForSkillChangeNotifications:(id<SkillChangeProtocol>)objectToUnsubscribe;


-(int)countUsableLevelValueForSkill:(Skill *)skill;
-(float)countXpNeededForNextLevel:(Skill *)skill;
-(float)countXpSpentOnSkillWithTemplate:(SkillTemplate *)skillTemplate forCharacter:(Character *)character;

-(int)countPositionYInATreeForSkill:(SkillTemplate *)skillTemplate;
-(NSInteger)countPositionXInATreeForSkill:(SkillTemplate *)skillTemplate;
-(SkillTemplate *)getRootSkillWithSkill:(SkillTemplate *)skill;
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
-(void)setLevelOfSkill:(Skill *)skill
               toLevel:(float)level;
-(void)addXpPoints:(float)xpPoints
           toSkill:(Skill *)skill;
-(void)removeXpPoints:(float)xpPoints
              toSkill:(Skill *)skill;

/**
 Add xp points without counting parent skills. Use for archiving.
 */
-(Skill *)calculateAddingXpPointsForSkill:(Skill *)skill;
-(Skill *)calculateRemovingXpPointsForSkill:(Skill *)skill;


//FETCH
-(id)getOrAddSkillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character;
-(id)getSkillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character;
-(id)getSkillWithTemplate:(SkillTemplate *)skillTemplate withSkillSet:(SkillSet *)skillSet;
-(NSArray *)fetchAllNoneBasicSkillsForSkillSet:(SkillSet *)skillSet;
-(NSArray *)fetchAllSkillsForSkillSet:(SkillSet *)skillSet;


//currently method used in development purposes only
-(void)clearSkillTemplateWithName:(NSString *)name;
@end
