//
//  DefaultSkillTemplates.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 10.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>

static int expectedMinLevelForCoreSkills = 2; //including combat skills
static int expectedMinLevelForToughness = 5;  //To most often 20% larger then others
static int expectedMinLevelForOtherAdvanced = 4;

@class RangeSkill,MagicSkill,MeleeSkill,AdvancedSkill,Skill,SkillTemplate,Character,CharacterConditionAttributes,SkillSet;

@interface DefaultSkillTemplates : NSObject

//default false. On true will reload current skillTemplates params from this obj
@property (nonatomic) BOOL shouldUpdate;

@property (nonatomic) SkillTemplate *physique;
@property (nonatomic) SkillTemplate *intelligence;

//advanced
@property (nonatomic) SkillTemplate *strength;
@property (nonatomic) SkillTemplate *toughness;
@property (nonatomic) SkillTemplate *agility;

@property (nonatomic) SkillTemplate *reason;
@property (nonatomic) SkillTemplate *control;
@property (nonatomic) SkillTemplate *perception;

@property (nonatomic) SkillTemplate *melee;
@property (nonatomic) SkillTemplate *range;

@property (nonatomic) SkillTemplate *swimming;
@property (nonatomic) SkillTemplate *climb;

@property (nonatomic) SkillTemplate *stealth;
@property (nonatomic) SkillTemplate *ride;
@property (nonatomic) SkillTemplate *knavery;
@property (nonatomic) SkillTemplate *escapeArtist;

@property (nonatomic) SkillTemplate *senseMotive;
@property (nonatomic) SkillTemplate *disguise;

@property (nonatomic) SkillTemplate *animalHandling;
@property (nonatomic) SkillTemplate *bluff;
@property (nonatomic) SkillTemplate *diplomacy;
@property (nonatomic) SkillTemplate *intimidate;

@property (nonatomic) SkillTemplate *hackDevice;
@property (nonatomic) SkillTemplate *heal;
@property (nonatomic) SkillTemplate *appraise;
@property (nonatomic) SkillTemplate *magic;


@property (nonatomic) SkillTemplate *crashing;
@property (nonatomic) SkillTemplate *cutting;
@property (nonatomic) SkillTemplate *piercing;

@property (nonatomic) SkillTemplate *bow;
@property (nonatomic) SkillTemplate *firearm;
@property (nonatomic) SkillTemplate *thrown;




+ (DefaultSkillTemplates *)sharedInstance;

-(NSArray *)allBasicSkillTemplates;
-(NSArray *)allCoreSkillTemplates;
-(NSArray *)allMeleeCombatSkillTemplates;
-(NSArray *)allRangeCombatSkillTemplates;

-(NSArray *)allSkillTemplates;

@end
