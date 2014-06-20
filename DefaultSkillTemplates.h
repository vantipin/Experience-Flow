//
//  DefaultSkillTemplates.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 10.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RangeSkill,MagicSkill,MeleeSkill,AdvancedSkill,Skill,SkillTemplate,Character,CharacterConditionAttributes,SkillSet;

@interface DefaultSkillTemplates : NSObject

@property (nonatomic) SkillTemplate *physique;
@property (nonatomic) SkillTemplate *intelligence;

//advanced
@property (nonatomic) SkillTemplate *strength;
@property (nonatomic) SkillTemplate *toughness;
@property (nonatomic) SkillTemplate *agility;

@property (nonatomic) SkillTemplate *reason;
@property (nonatomic) SkillTemplate *control;
@property (nonatomic) SkillTemplate *perception;

@property (nonatomic) SkillTemplate *swimming;
@property (nonatomic) SkillTemplate *climb;

@property (nonatomic) SkillTemplate *stealth;
@property (nonatomic) SkillTemplate *ride;
@property (nonatomic) SkillTemplate *knavery;
@property (nonatomic) SkillTemplate *hackDevice;
@property (nonatomic) SkillTemplate *escapeArtist;

@property (nonatomic) SkillTemplate *senseMotive;
@property (nonatomic) SkillTemplate *disguise;

@property (nonatomic) SkillTemplate *animalHandling;
@property (nonatomic) SkillTemplate *bluff;
@property (nonatomic) SkillTemplate *diplomacy;
@property (nonatomic) SkillTemplate *intimidate;

@property (nonatomic) SkillTemplate *education;
@property (nonatomic) SkillTemplate *heal;
@property (nonatomic) SkillTemplate *appraise;



@property (nonatomic) SkillTemplate *magic;

@property (nonatomic) SkillTemplate *dhar;
//sub magic
@property (nonatomic) SkillTemplate *ghyran;
@property (nonatomic) SkillTemplate *aqshy;
@property (nonatomic) SkillTemplate *hysh;

@property (nonatomic) SkillTemplate *weaponSkill;
//sub melee
@property (nonatomic) SkillTemplate *blunt;
@property (nonatomic) SkillTemplate *cutting;
@property (nonatomic) SkillTemplate *piercing;

@property (nonatomic) SkillTemplate *ballisticSkill;
//sub range
@property (nonatomic) SkillTemplate *bow;
@property (nonatomic) SkillTemplate *blackpowder;
@property (nonatomic) SkillTemplate *thrown;




+ (DefaultSkillTemplates *)sharedInstance;

-(NSArray *)allBasicSkillTemplates;
-(NSArray *)allCoreSkillTemplates;
-(NSArray *)allMeleeCombatSkillTemplates;
-(NSArray *)allRangeCombatSkillTemplates;

-(NSArray *)allSkillTemplates;

@end
