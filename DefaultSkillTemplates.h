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

@property (nonatomic) SkillTemplate *senseMotive;

@property (nonatomic) SkillTemplate *animalHandling;
@property (nonatomic) SkillTemplate *bluff;
@property (nonatomic) SkillTemplate *diplomacy;
@property (nonatomic) SkillTemplate *intimidate;

@property (nonatomic) SkillTemplate *education;
@property (nonatomic) SkillTemplate *heal;
@property (nonatomic) SkillTemplate *appraise;




@property (nonatomic) SkillTemplate *weaponSkill;
//sub WS
@property (nonatomic) SkillTemplate *blunt;
@property (nonatomic) SkillTemplate *cutting;
@property (nonatomic) SkillTemplate *piercing;

@property (nonatomic) SkillTemplate *ballisticSkill;
//sub BS
@property (nonatomic) SkillTemplate *bow;
@property (nonatomic) SkillTemplate *blackpowder;
@property (nonatomic) SkillTemplate *crossbow;
@property (nonatomic) SkillTemplate *thrown;


//Intimidate (S) Basic skill.
/*A character’s ability to cow, unnerve, or bully someone. Also covers the ability to convey a sense of dominance or superiority over others. Often carries the implied or over threat of physical violence. Can escalate a tense situation into hostility, or possibly cause a threat to back down if properly cowed.
 Specialisation options: Violence, combat, interrogation, politics*/

//channelling(?)
/*
 Advanced skill. Reflects a character’s ability to successfully harness the Winds of Magic to glean power to fuel arcane spells. The arcane equivalent of the divine skill Piety.
 Specialisation options: Below capacity, overchannelling, conserva- tive, reckless, by college order
 //*/

//First Aid (?) Basic skill.
/*Covers the basics in rendering care, tending to injury, splinting, and helping someone survive until better care is available, as well as evaluating the severity of wounds or trying to identify infections or sources of injuries. The more seri- ously injured the target is, the more challenging it is to treat them. Treating injured characters is covered in detail on page 64.
 Specialisation options: combat surgery, long term care, tending criti- cal wounds, tending normal wounds
 //*/

//Folklore (?) Basic skill.
/*General knowledge and information, common sense, and an understanding of the way the Empire and its society operate, and related topics. Folklore relies on experience, savvy, and second-hand knowledge moreso than refined education or information gleaned from books. It also encompasses knowledge of regional customs, colourful local myths and superstitions and the opinions of the common man.
 Specialisation options: creature lore, Reikland lore, geography, superstitions, local customs
 //*/

//Guile (?) Basic skill.
/*Sneaky, cunning, and surreptitious social interaction. Use this skill to deceive, lie, confuse, or sow seeds of doubt. Also covers using non-verbal innuendo and cues. Guile checks that involve duping, misleading, or fooling someone are generally opposed by the target’s Intuition. Guile checks aimed at rattling, deceiving, or distracting someone are generally opposed by the target’s Discipline.
 Specialisation options: Deception, blather, con games, innuendo, appear innocent
 //*/

//Intuition (?) Basic skill.
/*The ability to trust instincts about people, places, and things. The gut feeling that lets a character know if someone is lying, or if tHere are’s a subtle threat implied in someone’s tone or posture. Also covers the ability to make reason- ably accurate estimations and evaluate an item’s worth or purpose. Can be used to size up and opponent and get a general sense of their abilities or intentions, in which case it is opposed by the target’s Discipline.
 Specialisation options: Detect lies, estimate sums, evaluation, gauge opponent
 //*/

//Invocation (?) Advanced skill.
/*Invocation is an important aspect to performing divine miracles; characters use Invocation to intercede with patron gods to perform works on their behalf. The divine equivalent of the arcane skill spellcraft.
 Specialisation options: Each deity has its own specialisation, tradi- tions, rituals, tenets
 //*/

//Leadership (?) Basic skill.
/*A character’s ability to lead, motivate, direct, and manage the actions of others. Whether done by chas- tisement, ridicule, or camaraderie, leadership can help coordinate efforts among groups of people. If the leadership attempt would require a person to do something strongly against their nature, or is under especially dire circumstances, it may be opposed by the target’s Discipline.
 Specialisation options: Military leadership, politician, logistics, spiritual leader
 //*/

//Magical Sight (?) Advanced skill.
/*Magical sight is a skill pos- sessed by nearly all wizards and very few other people. It allows characters to observe the winds of magic by a focused act of will. For a more detailed description of this skill, see page 35 in the Tome of Mysteries.
 Specialisation options: Observe specific wind, identify spell, locate aura, dark magic, gauge strength
 //*/

//Medicine (?) Advanced skill.
/*The knowledge of the mortal body and how to care for it when seriously injured. This skill takes heal- ing and treatment beyond the scope of First Aid, and can produce more dramatic results. Also covers rudiments of surgery, amputa- tions, cauterisation, treating poisons and disease, suturing and long-term medical care. Treating injured characters is covered in detail on page 64.
 Specialisation options: critical wounds, poison, disease, long- term care, surgery
 //*/

//Nature Lore (?) Basic skill.
/*Wilderness savvy and the ability to withstand the rigours of nature and interpret its subtle clues. This skill also covers subsisting in the wild. It includes such activities as fishing, locating potable water, finding edible food, or identify- ing animal tracks. This skill also covers familiarity with plants, animals, weather patterns, and life outside the civilised areas.
 Specialisation options: Locate shelter, locate food, locate water, identify animal, identify plant
 //*/

//Piety (?) Advanced skill.
/*blend of knowledge and intuition on what will be pleasing and appropriate to the gods. Also reflects a character’s ability to successfully curry favour with his chosen god, generating the favour needed to fuel divine blessings. The divine equivalent of the arcane skill channelling.
 Specialisation options: Below capacity, conservative, reckless, urgent need
 */

//Spellcraft (?) Advanced skill.
/*Covers knowledge and under- standing of basic magical principles and history, as well as the fun- damental concepts of the Winds of Magic. Also used to take arcane power and convert it into a spell effect, thus Spellcraft is used for the casting portion of arcane magic. The arcane equivalent of the divine skill Invocation.
 Specialisation options: History of Magic, Colleges of Magic, Rank 1 spells, Rank 2 spells, Rank 3 spells, Rank 4 spells, Rank 5 spells
 */

//Tradecraft (?) Advanced skill.
/*Tradecraft is a collection of skills related to professional dedication and learning of an applied trade. General training covers evaluation and understanding of the basics of trade as a business and component of Empire life. Specialisation introduces focus on one particular type of trade or livelihood. The characteristic used depends on the demands of the trade, as determined by the GM.
 Specialisation options: Smithing, carpentry, jewellery making, brewing, engineering, performance
 */
+ (DefaultSkillTemplates *)sharedInstance;

-(NSArray *)allBasicSkillTemplates;
-(NSArray *)allCoreSkillTemplates;
-(NSArray *)allMeleeCombatSkillTemplates;
-(NSArray *)allRangeCombatSkillTemplates;

-(NSArray *)allSkillTemplates;

@end
