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
-(void)didChangeSkillLevel;
@end

@interface SkillManager : NSObject

@property (nonatomic,assign) id<SkillChangeProtocol> delegate;

+ (SkillManager *)sharedInstance;

-(int)countHpWithCharacter:(Character *)character;

-(int)countAttacksForMeleeSkill:(NSSet *)skills;
-(int)countAttacksForRangeSkill:(RangeSkill *)skill;
-(int)countWSforMeleeSkill:(NSSet *)skill;
-(int)countBSforRangeSkill:(RangeSkill *)skill;
-(int)countDCBonusForRangeSkill:(RangeSkill *)skill;

-(id)checkedSkillWithTemplate:(SkillTemplate *)skillName withCharacter:(Character *)character;

-(Skill *)addNewSkillWithTempate:(SkillTemplate *)skillTemplate
                      toSkillSet:(SkillSet *)skillSet
                     withContext:(NSManagedObjectContext *)context;

-(void)checkAllCharacterCoreSkills:(Character *)character;

-(SkillSet *)cloneSkillsWithSkillSet:(SkillSet *)skillSetToClone;

//update skill levels
-(void)addSolidLvls:(int)levels
            toSkill:(Skill *)skill
        withContext:(NSManagedObjectContext *)context;
-(void)removeSolidLvls:(int)levels
               toSkill:(Skill *)skill
           withContext:(NSManagedObjectContext *)context;
-(void)addXpPoints:(float)xpPoints
           toSkill:(Skill *)skill
       withContext:(NSManagedObjectContext *)context;
-(void)removeXpPoints:(float)xpPoints
              toSkill:(Skill *)skill
          withContext:(NSManagedObjectContext *)context;



@end
