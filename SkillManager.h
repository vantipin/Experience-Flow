//
//  SkillManager.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 25.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatSet.h"

@class RangeSkill,MagicSkill,MeleeSkill,RegularSkill,Skill,SkillTemplate,Character,StatSet,CharacterConditionAttributes;

//TODO core data

@interface SkillManager : NSObject

@property (nonatomic) SkillTemplate *movement;
@property (nonatomic) SkillTemplate *weaponSkill;
@property (nonatomic) SkillTemplate *ballisticSkill;
@property (nonatomic) SkillTemplate *strenght;
@property (nonatomic) SkillTemplate *toughness;
@property (nonatomic) SkillTemplate *agility;
@property (nonatomic) SkillTemplate *willpower;
@property (nonatomic) SkillTemplate *intelligence;
@property (nonatomic) SkillTemplate *charisma;

//sub WS
@property (nonatomic) SkillTemplate *unarmed;
@property (nonatomic) SkillTemplate *ordinary;
@property (nonatomic) SkillTemplate *flail;
@property (nonatomic) SkillTemplate *greatWeapon;
@property (nonatomic) SkillTemplate *polearm;
@property (nonatomic) SkillTemplate *cavalry;
@property (nonatomic) SkillTemplate *fencing;
@property (nonatomic) SkillTemplate *staff;
@property (nonatomic) SkillTemplate *spear;

//sub BS
@property (nonatomic) SkillTemplate *bow;
@property (nonatomic) SkillTemplate *blackpowder;
@property (nonatomic) SkillTemplate *crossbow;
@property (nonatomic) SkillTemplate *thrown;
@property (nonatomic) SkillTemplate *sling;

//advanced
@property (nonatomic) SkillTemplate *athletics;
@property (nonatomic) SkillTemplate *stealth;
@property (nonatomic) SkillTemplate *resilience;
@property (nonatomic) SkillTemplate *discipline;
@property (nonatomic) SkillTemplate *perception;

+ (SkillManager *)sharedInstance;


-(int)countHpWithStatSet:(StatSet *)statSet;
-(int)countHpWithCharacter:(Character *)character;

-(int)countAttacksForMeleeSkill:(NSSet *)skills;
-(int)countAttacksForRangeSkill:(RangeSkill *)skill;
-(int)countWSforMeleeSkill:(NSSet *)skill;
-(int)countBSforRangeSkill:(RangeSkill *)skill;
-(int)countDCBonusForRangeSkill:(RangeSkill *)skill;

-(id)checkedSkillWithTemplate:(SkillTemplate *)skillName withCharacter:(Character *)character;


-(void)checkAllCharacterCoreSkills:(Character *)character;
-(void)setCharacterSkills:(Character *)character withStatSet:(StatSet *)statset;
-(StatSet *)statSetFromCharacterSkills:(Character *)character;

-(NSArray *)allCoreSkillTemplates;
-(NSArray *)allMeleeCombatSkills;
-(NSArray *)allRangeCombatSkills;

-(NSArray *)allNoneCoreSkillTemplates;

//Intimidate (S) Basic skill.
/*A character’s ability to cow, unnerve, or bully someone. Also covers the ability to convey a sense of dominance or superiority over others. Often carries the implied or over threat of physical violence. Can escalate a tense situation into hostility, or possibly cause a threat to back down if properly cowed.
 Specialisation options: Violence, combat, interrogation, politics*/

//channelling(?)
/*
 Advanced skill. Reflects a character’s ability to successfully harness the Winds of Magic to glean power to fuel arcane spells. The arcane equivalent of the divine skill Piety.
 Specialisation options: Below capacity, overchannelling, conserva- tive, reckless, by college order
 //*/

//Charm (?)
/*Basic skill. Charisma and interaction on a friendly level. Charm can be used to manipulate others, create a favourable impression or interact good-naturedly with others. Charm can also be used to change the minds of individuals and small groups, to cajole, flatter, and gossip to glean information. Charm also includes seduction. Checks that involve convincing someone to do some- thing unusual or against his nature are generally opposed by the target’s Discipline.
Specialisation options: Etiquette, gossip, diplomacy, haggling, seduction
//*/

//Coordination (?)
/*Basic skill. Applying one’s manual dexterity and fine motor skills to specific tasks. Use this skill to perform feats of acrobatics, balance along narrow surfaces, or slip from bonds. It also reflects delicacy and precision while manipulating objects.
Specialisation options: Dodge, balance, acrobatics, juggling, dance, knots & ropework
 //*/

//Education (?) Advanced skill.
/*This skill is a broad category covering a variety of knowledges and disciplines. Training in education confers basic literacy. This skill is used to recall facts about specific topics, rely on book-learned knowledge, or show appreciation and understanding of various schools of thought or philosophies.
Specialisation options: History, geography, reason, language skills, philosophy
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
/*The ability to trust instincts about people, places, and things. The gut feeling that lets a character know if someone is lying, or if there’s a subtle threat implied in someone’s tone or posture. Also covers the ability to make reason- ably accurate estimations and evaluate an item’s worth or purpose. Can be used to size up and opponent and get a general sense of their abilities or intentions, in which case it is opposed by the target’s Discipline.
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

//Ride (?) Basic skill.
/*Defines a character’s ability to ride or care for a horse or other common mount, as well as drive and manage a wagon or carriage, and provide maintenance and care for the equipment associated with horses, mules and other riding or team animals. This skill also covers the ability to manage such animals and keep them calm under duress or spur them to greater action.
Specialisation options: Horsemanship, trick riding, wagons, mount- ed combat, long distance travel
 */

//Skulduggery (?) Basic skill.
/*Covers thieving and a variety of illicit, underhanded skills. Use this skill to subtly pry open a door, pick a lock, set or disable a trap, pick someone’s target, or perform some comparable act of thievery or burglary. Depending on the application, Skullduggery checks may be opposed by a target’s Observation or Intuition.
Specialisation options: Pick pockets, pick locks, set traps, disable traps, palm objects
 */

//Spellcraft (?) Advanced skill.
/*Covers knowledge and under- standing of basic magical principles and history, as well as the fun- damental concepts of the Winds of Magic. Also used to take arcane power and convert it into a spell effect, thus Spellcraft is used for the casting portion of arcane magic. The arcane equivalent of the divine skill Invocation.
 Specialisation options: History of Magic, Colleges of Magic, Rank 1 spells, Rank 2 spells, Rank 3 spells, Rank 4 spells, Rank 5 spells
 */

//Tradecraft (?) Advanced skill.
/*Tradecraft is a collection of skills related to professional dedication and learning of an applied trade. General training covers evaluation and understanding of the basics of trade as a business and component of Empire life. Specialisation introduces focus on one particular type of trade or livelihood. The characteristic used depends on the demands of the trade, as determined by the GM.
 Specialisation options: Smithing, carpentry, jewellery making, brewing, engineering, performance
*/
@end
