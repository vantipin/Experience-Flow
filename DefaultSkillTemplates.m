//
//  DefaultSkillTemplates.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 10.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "DefaultSkillTemplates.h"
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

#define physiqueName @"Physique"
#define intelligenceName @"Intelligence"

#define weaponSkillName @"Melee"
#define ballisticSkillName @"Range"

#define bluntName @"Crashing"
#define ordinaryName @"Cutting"
#define flailName @"Piercing"

#define bowName @"Bow"
#define blackpowderName @"Firearm"
#define crossbowName @"Crossbow"
#define thrownName @"Thrown"

#define strengthName @"Strength"
#define toughnessName @"Toughness"
#define agilityName @"Agility"

#define reasonName @"Reason"
#define disciplineName @"Control"
#define perceptionName @"Perception"

#define swimmingName @"Swim"
#define climbName @"Climb"

#define rideName @"Ride"
#define knaveryName @"Knavery"
#define stealthName @"Stealth"

#define senseMotiveName @"Sense Motive"

#define animalHandlingName @"Animal Handling"
#define bluffName          @"Bluff"

#define hackDeviceName @"Hack Device"
#define educationName @"Education"
#define healName @"Heal"
#define appraiseName @"Appraise"

static float defaultPhsAndMnsProgression = 10;
static float defaultPhsAndMnsBasicBarrier = 5;
static float defaultPhsAndMnsGrowhtGoes = 0.3;

static float defaultAdvGrowhtGoesHight = 0.7;
static float defaultAdvGrowhtGoesLow = 0.4;
static float defaultAdvBasicBarrierHight = 10;
static float defaultAdvBasicBarrierLow = 7;
static float defaultAdvProgression = 8;

static float defaultMeleeWeaponProgression = 12;
static float defaultMeleeWeaponBasicBarrier = 10;
static float defaultMeleeWeaponGrowhtGoes = 0.3;

static float defaultRangeWeaponProgression = 12;
static float defaultRangeWeaponBasicBarrier = 10;
static float defaultRangeWeaponGrowhtGoes = 0.3;

static int defaultEncumbrancePenalties = 20;

static DefaultSkillTemplates *instance = nil;

@interface DefaultSkillTemplates()
@property (nonatomic) NSManagedObjectContext *context;
@end

@implementation DefaultSkillTemplates

-(NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [[MainContextObject sharedInstance] managedObjectContext];
    }
    return _context;
}

+ (DefaultSkillTemplates *)sharedInstance {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        if (!instance) {
            instance = [[DefaultSkillTemplates alloc] init];
            //atexit(deallocSingleton);
        }
    });
    
    return instance;
}

-(NSArray *)allSkillTemplates
{
    NSArray *allDefaultSkills;
    
    allDefaultSkills = @[self.physique,
                         self.intelligence,
                         
                         self.weaponSkill,
                         self.ballisticSkill,
                         
                         self.blunt,
                         self.cutting,
                         self.piercing,
                         
                         self.bow,
                         self.blackpowder,
                         self.crossbow,
                         self.thrown,
                         
                         self.strength,
                         self.toughness,
                         self.agility,
                         self.reason,
                         self.control,
                         self.perception,
                         
                         self.stealth,
                         self.animalHandling,
                         self.education,
                         self.swimming,
                         self.climb,
                         self.knavery,
                         self.ride,
                         self.hackDevice,
                         self.heal,
                         self.senseMotive,
                         self.appraise,
                         self.bluff];
    
    return allDefaultSkills;
}


-(NSArray *)allBasicSkillTemplates;
{
    NSArray *allSkills = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"skillEnumType == %d",BasicSkillType] withContext:self.context];
    
    return allSkills;
}


-(NSArray *)allCoreSkillTemplates
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.weaponSkill,
                           self.ballisticSkill,
                           
                           self.strength,
                           self.toughness,
                           self.agility,
                           self.reason,
                           self.control,
                           self.perception,
                           
                           self.physique,
                           self.intelligence];
    
    return allCharacterSkills;
}

-(NSArray *)allMeleeCombatSkillTemplates
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.blunt,
                           self.cutting,
                           self.piercing];
    
    return allCharacterSkills;
}

-(NSArray *)allRangeCombatSkillTemplates
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.bow,
                           self.blackpowder,
                           self.crossbow,
                           self.thrown];
    
    return allCharacterSkills;
}

#pragma mark -
#pragma mark basic skills

//physique
-(SkillTemplate *)physique{
    if (!_physique){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",physiqueName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:physiqueName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Physique. Basic skill. Defines a character’s strenght, toughness and agility."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:14
                                                   withSkillProgression:7
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:BasicSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:nil
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _physique = skillTemplate;
        
    }
    return _physique;
}

//intelligence
-(SkillTemplate *)intelligence{
    if (!_intelligence){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",intelligenceName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:intelligenceName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Intelligence. Basic skill. Defines character’s intelligence, willpower and sociability."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:14
                                                   withSkillProgression:7
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:BasicSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:nil
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _intelligence = skillTemplate;
        
    }
    return _intelligence;
}

//weaponSkill
-(SkillTemplate *)weaponSkill{
    if (!_weaponSkill){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",weaponSkillName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:weaponSkillName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Weapon skill. Basic skill. Covers the basic use, care and maintenance of a variety of melee weapons. Weapon skill is a broad category and governs fighting unarmed to using small weapons like knives or clubs to larger weapons like two-handed swords, great axes or halberds. The ability to parry with an equipped melee weapon is also based on a character’s Weapon Skill."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:15
                                                   withSkillProgression:15
                                               withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.physique
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _weaponSkill = skillTemplate;
        
    }
    return _weaponSkill;
}

//ballisticSkill
-(SkillTemplate *)ballisticSkill{
    if (!_ballisticSkill){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",ballisticSkillName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:ballisticSkillName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Weapon skill. Basic skill. Covers the basic use, care and maintenance of ranged weapons. This includes thrown weapons like balanced knives and javelins, as well as bows, crossbows, and slings. Also covers the basics of blackpowder weapon care and operation. It is a combination of hand-eye coordination, accuracy, and training with ranged items."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:15
                                                   withSkillProgression:15
                                               withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.physique
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _ballisticSkill = skillTemplate;
        
    }
    return _ballisticSkill;
}

#pragma mark -
#pragma mark advanced skills
//strength
-(SkillTemplate *)strength{
    if (!_strength){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",strengthName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:strengthName
                                                              withRules:@"Rules:\n- Every time you hit the opponent in close combat minimal resulting damage increase accordingly. This skill opposes enemy Toughness skill.\n- Overall character carring capacity equal to level of this skill  multiplied by 2. If character overload this capacity he/she gain 1 fatigue point for every 2 point of excess encumbrance until character decide free his/her inventory. Dungeon master can increase encumbrance value of item, if character got no efficient way to carry it. \n- You can gain adrenaline points up to the half of this skill level."
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. Covers general physical prowess and applying strength and conditioning to a task. This skill is used when trying to perform tasks relying on physical conditioning and athleticism, such as climbing, swimming. The ability to efficiently lift, push or pull heavy objects and drag more stuff around."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultPhsAndMnsBasicBarrier
                                                   withSkillProgression:defaultPhsAndMnsProgression
                                               withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.physique
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _strength = skillTemplate;
    }
    return _strength;
}

//resilience
-(SkillTemplate *)toughness{
    if (!_toughness){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",toughnessName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:toughnessName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. A character’s fitness, vigour, and ability to bounce back from strain and damage. Also covers use of a shield to bear the brunt of an attack and absorb the punishment. Resilience is often used to recover from wounds or fatigue over time, such as after bed rest. Specialisation options: Block, recover fatigue, resist disease, resist poison, resist starvation."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultPhsAndMnsBasicBarrier
                                                   withSkillProgression:defaultPhsAndMnsProgression
                                               withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.physique
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _toughness = skillTemplate;
    }
    return _toughness;
}

//agility
-(SkillTemplate *)agility{
    if (!_agility){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",agilityName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:agilityName
                                                              withRules:@"Rules: \n- For jumping, traversing narrow or treacherous surfaces pass the Agility test*.\n- When falling down from less then 6 meters you can attempt to land on feet taking same damage with 0 Strength.\n- Using a balancing pole (two hands) while traversing a narrow surface grants +1 to Agility check.\n- If you use a pole as part of a running jump, you gain a +2 bonus on your Agility check (but must let go of the pole in the process)."
                                                      withRulesExamples:@"*Here are examples of tasks and their stats:\nLevel 1. d6 test. Move on narrow surface or uneven ground without falling at half speed. Running Jump with distance equal to the half of your movement. Running distance must be more or equal to jumping distance. Land on a feet falling from 1 meter height.\nLevel 2. d8 test. Jump from a place with distance equal to the half of your movement. Land on a feet falling from 2 meter height.\nLevel 3. d10 test. Running Jump with distance equal to your movement. Running distance must be more or equal to jumping distance. Land on a feet falling from 3 meter height.\nLevel 4. d12 test. Move(at full speed)/Fight on narrow surface or uneven ground without falling. Land on a feet falling from 4 meter height.\nLevel 5. d20 test. Jump from a place with distance equal to your movement. Land on a feet falling from 5 meter height."
                                                        withDescription:@"Advanced skill. Describe a skill and grace in physical movement. Keeping balance while traversing narrow or treacherous surfaces. You can also dive, flip, jump, and roll, avoiding attacks and confusing your opponents."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultPhsAndMnsBasicBarrier
                                                   withSkillProgression:defaultPhsAndMnsProgression
                                               withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.physique
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _agility = skillTemplate;
    }
    return _agility;
}

//reason
-(SkillTemplate *)reason{
    if (!_reason){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",reasonName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:reasonName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. Defines a character’s general intellect, reasoning, and powers of deduction. Intelligence is used for a variety of academic and knowledge-based skills, and is important for arcane spellcasting."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultPhsAndMnsBasicBarrier
                                                   withSkillProgression:defaultPhsAndMnsProgression
                                               withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.intelligence
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _reason = skillTemplate;
    }
    return _reason;
}

//discipline
-(SkillTemplate *)control{
    if (!_control){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",disciplineName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:disciplineName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. This skill is used to resist the startling effects of surprising events, show resolve in the face of danger, and maintain composure when confronted by supernatural or terrify- ing situations. Discipline is also the ability to maintain one’s state of mind and resist the rigours of stress or attempts to manipulate one’s thoughts or feelings. Specialisation options: Resist charm, resist guile, resist intimidation, resist fear, resist terror, resist torture."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultPhsAndMnsBasicBarrier
                                                   withSkillProgression:defaultPhsAndMnsProgression
                                               withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.intelligence
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _control = skillTemplate;
    }
    return _control;
}

//perception
-(SkillTemplate *)perception{
    if (!_perception){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",perceptionName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:perceptionName
                                                              withRules:@"Rules:\nYou should declare that your character search for any small details, clues etc. You character still can automaticly notice those objects, but in that case difficulty of the test increased by 1 level*.  \n\nThis skill gives you following advantages: You automatically begin to notice little details on clothes, pick up on subtle clues and surrounding witch others will miss, like a spot on a jacket or an old coin on a floor.  \nLevel 10 etc. every level - You gain an ability to perfectly remember small images, icon. If character know how to read he can do it faster (read faster then usual person times equal to current level). With level size of image or text to instantly remember growths accordingly."
                                                      withRulesExamples:@"*Here are examples of surroundings and their stats:\nLevel 1. d10 test. Normal well-lit place. \nLevel 2. 2d8 test. Poorly-lit place. \nLevel 3. 2d12 test. Dark place."
                                                        withDescription:@"Advanced skill. Using your senses to perceive your surroundings. It can also be used to spot traps, pitfalls, and other physical dangers. Perception opposes other characters’ attempts at Stealth, or to otherwise avoid detection. Specialisation options: Eavesdropping, tracking, keen vision, minute details."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultPhsAndMnsBasicBarrier
                                                   withSkillProgression:defaultPhsAndMnsProgression
                                               withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.intelligence
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _perception = skillTemplate;
    }
    return _perception;
}

//swimming
-(SkillTemplate *)swimming{
    if (!_swimming){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",swimmingName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:swimmingName
                                                              withRules:[NSString stringWithFormat:@"Rules: \n- Your swimming or flounder speed equals to the level of this skill plus your physique. \n- For every %d points of encumbrance (counting equipment you are wearing) your swim level decreased by 1, if it got below 1 you still can flounder with speed of your physique, but every turn you must pass swim test or begin to drown. \n- If you need to save someone who's drowning you should carry unlucky by yourself his/her encumbrance will be half of target Toughness multiplied by its bulk plus the half of it's equpment weight. Resulting encumbrance can vary depending on the nature of the water. \n- Being, at least, half submerged to perform physique related actions you need to pass swim test. \nYou can hold your breath up to your Toughness level   rounds. After that you will suffer automatically 1 fatigue point each round.\n - Walking in a current character might fall down if fails standart fall test against level* of the current. If character moves against water current his movement lowers accordingly to the level of the flow. \n- Characters which using smashing or blunt type of weapon can't deal damage underwater. \n\nThis skill gives you following advantages: You know how to keep afloat and won't sink until overloaded or tired.",defaultEncumbrancePenalties]
                                                      withRulesExamples:@"*Here are examples of water current and their stats:\nLevel 0. d4 test. Quiet water.\nLevel 1. d6 test. Calm water.\nLevel 2. d8 test. Rough water.\nLevel 3. d10 test. Stormy water.\nLevel 3-4. d12/d20 test. Very rapid flow."
                                                        withDescription:@"Advanced skill. The ability to keep afloat and efficiently control your body in a water. Specialisation options: diving, front crawl, backstroke."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierLow
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.strength
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _swimming = skillTemplate;
    }
    return _swimming;
}

//climb
-(SkillTemplate *)climb{
    if (!_climb){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",climbName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:climbName
                                                              withRules:[NSString stringWithFormat:@"Rules:\n- You climbing speed equals to the skill level plus your physique. \n- If obstacle is hard to climb then climbing speed lower by obstacle level* in addition for every %d points of encumbrance (counting equipment you are wearing) your climb level decreased by 1, if you climbing speed drops below the skill level you can still climb with the speed of your physique but every turn you should pass climb test or fall down. \n- To perform any other physique related actions you need to pass climb test.",defaultEncumbrancePenalties]
                                                      withRulesExamples:@"*Here are examples of obsticles and their stats:\nLevel 1. d6 test. A slope too steep to walk up, or a knotted rope with a wall to brace against. Or living obstacle which move with speed of 1-2.  \nLevel 2. d8 test. A surface with ledges to hold on to and stand on, such as a very rough wall or a ship’s rigging. Any surface with adequate handholds and footholds (natural or artificial), such as a very rough natural rock surface or a tree, or an unknotted rope, or pulling yourself up when dangling by your hands. Or living obstacle which move with speed of 3-5. \nLevel 3. d10 test. An uneven surface with some narrow handholds and footholds, such as a typical wall in a dungeon or ruins. Or living obstacle which move with speed of 6-9.\nLevel 4. d12 test. A rough surface, such as a natural rock wall or a brick wall. Or an overhang or ceiling with handholds but no footholds. Or living obstacle which move with speed of 10 and more."
                                                        withDescription:@"Advanced skill. The ability to quickly climb slope too steep to walk, knotted rope etc. Specialisation options: climb rope, climb wall, climb ladder. \n\n \n\n"
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierLow
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.strength
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _climb = skillTemplate;
    }
    return _climb;
}

//stealth
-(SkillTemplate *)stealth{
    if (!_stealth){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",stealthName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:stealthName
                                                              withRules:[NSString stringWithFormat:@"Rules:\n- For every %d points of encumbrance (counting equipment you are wearing) your stealth level decreased by 1. \n- If you trying to  sneak up someone from behind by default you'll need to pass test depending on surroundings*. If you fail opponent can make perseption check to notice you. \n- If you trying to sneak past your opponent crossing his sight of vision you need to pass test* against opponent perseption. \n\nThis skill gives you following advantages: You know how to remain quiet for a long time, something many others will lack, even if their lives depends on it. While standing still you can be noticed only if you aren't fully hidden from the sight of opponent passes perception check against you stealth.",defaultEncumbrancePenalties]
                                                      withRulesExamples:@"*Here are examples of surroundings and their stats:\nLevel 1. d8 test. Normal surface/Dark room. \nLevel 2. d12 test. Noisy surface(scree, shallow or deep bog, undergrowth, dense rubble)/Poorly-lit room. \nLevel 3. d20 test. Very noisy(dense undergrowth, deep snow)/Well-lit room"
                                                        withDescription:@"Advanced skill. The ability to keep from being seen or heard, this skill combines hiding with being quiet. With level you gain understanding how move very quiet and pick up a matirials to make clothes to make as little sound as possible. Specialisation options: Silent movement: rural, silent movement: wilderness, hide, ambush."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierLow
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.agility
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _stealth = skillTemplate;
    }
    return _stealth;
}

//ride
-(SkillTemplate *)ride{
    if (!_ride){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",rideName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:rideName
                                                              withRules:[NSString stringWithFormat:@"Rules:\n- You should perform ride test on every ride related action*.\n- You can gain bonuses or penalties to the skill level depending on quality of saddle or pose you choose to ride the mount. A good saddle gives +2 to the skill level. Riding bareback gives -4 to riding. \n- For every %d points of encumbrance (counting equipment you are wearing) your ride level decreased by 1.\n- You should use Animal Handling skill Test Value for your mount for discipline tests if needed. \n\nThis skill gives you following advantages: \nLevel 6 etc. - Typical riding actions don’t require checks. You can saddle, mount, ride, and dismount from a mount without a problem.",defaultEncumbrancePenalties]                                                      withRulesExamples:@"*Here are examples of tasks and their stats:\nLevel 1. d8 test. Guide with knees. You can react instantly to guide your mount with your knees so that you can use both hands in combat. Make your Ride check at the start of your turn. If you fail, you can use only one hand this round because you need to use the other to control your mount. \nLevel 1. d8 test. Stay in Saddle. You can react instantly to try to avoid falling when your mount rears or bolts unexpectedly or when you take damage. This usage does not take an action. \nLevel 2. d10 test. Cover. You can react instantly to drop down and hang alongside your mount, using it as cover. You can’t attack or cast spells while using your mount as cover. If you fail your Ride check, you don’t get the cover benefit. This usage does not take an action. \nLevel 2. d10 test. Soft fall. You can react instantly to try to take no damage when you fall off a mount — when it is killed or when it falls, for example. If you fail your Ride check, you take d6 falling damage. This usage does not take an action. \nLevel 2. d10 test. Leap. You can get your mount to leap obstacles as part of its movement. If you fail your Ride check, you fall off the mount when it leaps and take the appropriate falling damage (at least d6 points). This usage does not take an action, but is part of the mount’s movement. \nLevel 2. d10 test. Spur Mount. You can spur your mount to greater speed with an action. A successful Ride check increases the mount’s speed twice for 1 round but deals 1 fatigue to the creature. \nLevel 3. d12 test. Control mount in battle. As an action, you can attempt to control a light horse, pony, heavy horse, or other mount not trained for combat riding while in battle. If you fail the Ride check, you can do nothing else in that round. You do not need to roll for warhorses or warponies. \nLevel 3. d12 test. Fast mount or dismount. You can attempt to mount or dismount from a mount of up to one size category larger than yourself as a free action, provided that you still have an action available that round. If you fail the Ride check, mounting or dismounting is an action. You can’t use fast mount or dismount on a mount more than one size category larger than yourself. \nLevel 4. 2d8 test. Stand on mount. This allows you to stand on your mount’s back even during movement or combat. You take no penalties to actions while doing so. \nLevel 5. d20 test. Unconscious Control. As a free action, you can attempt to control a light horse, pony, or heavy horse while in combat. If the character fails, you control the mount with action point. You do not need to roll for warhorses or warponies. \nLevel 5. d20 test. Attack from Cover. You can react instantly to drop down and hang alongside your mount, using it as one-half cover. You can attack and cast spells while using your mount as cover without penalty. If you fail, you don’t get the cover benefit."
                                                        withDescription:@"Advanced skill. Defines a character’s ability to ride or care for a horse or other common mount, as well as drive and manage a wagon or carriage, and provide maintenance and care for the equipment associated with horses, mules and other riding or team animals. This skill also covers the ability to manage such animals and keep them calm under duress or spur them to greater action. Specialisation options: trample, trick riding, mounted archery, long distance travel."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierLow
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.agility
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _ride = skillTemplate;
    }
    return _ride;
}

//knavery
-(SkillTemplate *)knavery{
    if (!_knavery){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",knaveryName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:knaveryName
                                                              withRules:[NSString stringWithFormat:@"Rules:\n- You should perform knavery test on every knavery related action*.\n- For every %d points of encumbrance (counting equipment you are wearing) your knavery level decreased by 1.\n- If you are trying to perform skill while someone watching you closely - to remain unnoticed you should pass knavery test against opponent perception.\n\nThis skill gives you following advantages: \nYou are able to be cool about legerdemain and now opponent will watch closely only if he expect a trick and get a good position to expose your knavery. In other situation you should easily find a moment to perform knavery.",defaultEncumbrancePenalties]
                                                      withRulesExamples:@"*Here are examples of tasks and their stats:\nLevel 1. d8 test. Palm a coin-sized object, make a coin disappear. \nLevel 3. d12 test. Lift a small object from a person. \nLevel 5. d20 test. Lift a sheathed weapon from another creature and hide it on the character’s person, if the weapon is no more than one size category larger than the character’s own size. \nLevel 7. 2d12 test. Make an adjacent, willing creature or object of the character’s size or smaller “disappear” while in plain view. In fact, the willing creature or object is displaced up to 10 feet away—make a separate knavery test to determine how well the “disappeared” creature or object is hidden."
                                                        withDescription:@"Advanced skill. Your training allows you to pick pockets, draw hidden weapons, and take a variety of actions without being noticed. Specialisation options: pick pockets, draw hidden weapons, show a trick."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierLow
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.agility
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _knavery = skillTemplate;
    }
    return _knavery;
}

//Sence motive
-(SkillTemplate *)senseMotive{
    if (!_senseMotive){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",senseMotiveName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:senseMotiveName
                                                              withRules:@"Rules:\n- Hunch. You can get the feeling from another's behavior that something is wrong, such as when you're talking to an impostor. Alternatively, you can get the feeling that someone is trustworthy.\n- Sense Enchantment. If have no levels in Magic skill you gain -4 penalty. You can tell that someone's behavior is being influenced by an enchantment effect even if that person isn't aware of it.\n- Discern Secret Message. You may use Sense Motive to detect that a hidden message is being transmitted via the Bluff skill. In this case, your Sense Motive check is opposed by the Bluff check of the character transmitting the message. For each piece of information relating to the message that you are missing, you take a -2 penalty on your Sense Motive check."
                                                      withRulesExamples:@"\n2d8 test. Discern Secret Message.\nd20 test. Sence Enchantment."
                                                        withDescription:@"Advanced skill. This skill is opposed to enemy's Bluff. You usually don't make a roll instead enemy get penalties to his Bluff against you. Sense Motive generally takes at least 1 minute, and you could spend a whole evening trying to get a sense of the people around you."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierLow
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.perception
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _senseMotive = skillTemplate;
    }
    return _senseMotive;
}

//bluff
-(SkillTemplate *)bluff{
    if (!_bluff){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",bluffName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:bluffName
                                                              withRules:@"Rules:\n- Deceive Someone. Attempting to deceive someone takes at least 1 round, but can possibly take longer if the lie is elaborate.\n- Feint in Combat. Feinting in combat is a standard action. Roll to hit dice twice and choose which one to use.\n- Deliver Secret Message. You can use Bluff to pass hidden messages to another character without others understanding your true meaning. Delivering a secret message generally takes twice as long as the message would otherwise take to relay."
                                                      withRulesExamples:@"The target wants to believe you +3\nThe lie is believable 	              +3\nThe lie is unlikely 	               0\nThe lie is far-fetched 	             -3\nThe lie is impossible 	             -10\nThe target is drunk or impaired 	 +3\nYou possess convincing proof 	    up to +5  Here are examples of tasks and their stats:\nd8 test. Deceive Someone.\nd12 test. Feint in Combat.\n2d8 test. Deliver Secret Message. Roll multiple times for complex message."
                                                        withDescription:@"Advanced skill. Bluff is an opposed skill check against your opponentís Sense Motive skill. If you use Bluff to fool someone, with a successful check you convince your opponent that what you are saying is true. Bluff checks are modified depending upon the believability of the lie. The following modifiers are applied to the roll of the creature attempting to tell the lie. Note that some lies are so improbable that it is impossible to convince anyone that they are true."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierLow
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.control
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _bluff = skillTemplate;
    }
    return _bluff;
}


//appraise
-(SkillTemplate *)appraise{
    if (!_appraise){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",appraiseName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:appraiseName
                                                              withRules:@"Rules:\n- Determine the price of non-magical goods that contain precious metals or gemstones, the value of a common item\n- Determine if the item has magic properties. Get -4 penalty if character has no levels in Magic skill.\n- Additional attempts to Appraise an item reveal the same result."
                                                      withRulesExamples:@"*Here are examples of tasks and their stats:\nd10 test against rarity level of item. On success get item price. On fail price modified accordingly to value of the the dice multiplied by item rarity level. "
                                                        withDescription:@"Advanced skill. An item is worth only what someone will pay for it. To an art collector, a canvas covered in daubs of random paint may be a masterpiece; a priestess might believe a weatHere ared jawbone is a holy relic of a saint.\nThe Appraise skill allows a character to accurately value an object. However, the fine arts of the jeweler, antiquarian, and bibliophile are complex. Valuable paintings may be concealed by grime, and books of incredible rarity may be bound in tattered leather covers. Because failure means an inaccurate estimate, the GM should attempt this skill check in secret."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierLow
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.reason
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _appraise = skillTemplate;
    }
    return _appraise;
}


//pickALock
-(SkillTemplate *)hackDevice{
    if (!_hackDevice){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",hackDeviceName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:hackDeviceName
                                                              withRules:@"Rules:\n- You should perform hack device test on every hack related action* Usually all checks goes against the level of task. \nSome type of devices will require having specific tools lack of which will make hacking task hard (if not imposible) to perform - if you haven't got a right tool you may at best get a penalty to your hacking level equal to the level of the task. Commonly to pick a lock you will require a lockpick or even a full set of thieving tools.  \n- Performing this skill in a difficult condition may increase level of the task. \n- To perform this skill character require number of 30 sec equal to level of the task.  \n- Failing tests usually doesn't affect the character (aside from wasting his/her time and wear disabling tools), but in some cases it can trigger an action, depending on a type of device. \n\nThis skill gives you following advantages: \nHaving an expirience in disabling devices make you character more inventing in finding and collecting a right tools. If haven't already know someone to sell you right instruments you can buy different goods (and maybe alter them a little bit) to use as a hacking tools. Sometimes you can even find suiting objects for hacking with a perception check. Finding the right tool works only for tasks which level less or equal to the level of the skill."
                                                      withRulesExamples:@"*Here are examples of tasks and their stats:\nLevel 2. d6 test. Jam a lock. \nLevel 4. d8 test. Sabotage a wagon wheel. Lockpick a simple constructed lock. \nLevel 6. d10 test. Disarm a trap, reset a trap. Lockpick a average constructed lock. \nLevel 8. d12 test. Disarm a complex trap, cleverly sabotage a clockwork device. Lockpick a good constructed lock. \nLevel 10. 2d8 test. Sabotage ingeniously crafted mechanism. Lockpick an amazingly constructed or very exotic lock."
                                                        withDescription:@"Advanced skill. You are skilled at disarming traps and opening locks. In addition, this skill lets you sabotage simple mechanical devices, such as catapults, wagon wheels, and doors. Specialisation options: open locks, sabotage mechanisms, disable traps."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierLow
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.reason
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _hackDevice = skillTemplate;
    }
    return _hackDevice;
}

//education
-(SkillTemplate *)education{
    if (!_education){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",educationName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:educationName
                                                              withRules:@"Rules:\n- By passing varied education tests you might recall facts about actual topic which can help the situation.\n- When you can call to reason of a person to reassure or convince him change his mind you can use education for this test. \n\nThis skill gives you following advantages: \nLevel 1 - Training in education confers basic literacy. Now you can read and have basic knowledge in arithmetics. With level you gain more rear and complex knowledge.  \nLevel 2 etc. every level - You can tutor others in any skill more efficient - time between skill tests goes shorter by times equal to education level (default 1 hour - 1 test)."
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. This skill is a broad category covering a variety of knowledges and disciplines. Specialisation options: History, geography, reason, language skills, philosophy."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierLow
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesHight
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.reason
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _education = skillTemplate;
    }
    return _education;
}

//heal
-(SkillTemplate *)heal{
    if (!_heal){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",healName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:healName
                                                              withRules:@"Rules:\n- You need a few items and supplies (bandages, salves, and so on) that are easy to come by in settled lands. A healer’s kit gives you a +2 bonus to Heal skill. Depending on a quality of the kit bonus can vary. \n- Trying again. Varies. Generally speaking, you can’t try a Heal check again without witnessing proof of the original check’s failure. You can always retry a check to provide first aid, assuming the target of the previous attempt is still alive.\n- Long-Term Care. 8 hours of light activity. Providing long-term care means treating a wounded person for a day or more. If your Heal check is successful, the patient recovers hit points at twice the normal rate. In any case treated character get +1 to recovered hit points.\n- Treat Injuries. 1 round. You can remove negative effects from wounds by making Healing check against level of injury.\n- Treat Poison.  Every time the poisoned character makes a saving throw against the poison, you make a Heal check against poison level. If you pass the test character get +4 for recovery test and doesn't take penalties for now. On fail if you would pass with double value of Heal character get only half of penalties.\n- Treat Disease. 10 min each check. Every time the diseased character makes a saving throw against disease effects, you make a Heal check against disease level. If you pass the test character get +4 for recovery test and doesn't take penalties for now. On fail if you would pass with double value of Heal character get only half of penalties.\n- Although the Heal skill is traditionally used to aid the injured, treat poison and disease, and otherwise provide comfort to the wounded and infirm, the anatomic knowledge granted by this skill allows it to be used for far more nefarious uses as well. Any character may attempt to torture a living target with physical and mental anguish; the results of such torture can be determined with a Heal check.\n- Prevent Recovery. A victim in the care of a torturer can be prevented from naturally healing from wounds by worrying the victimís wounds, keeping him malnourished, and using various substances to promote prolonged sickness. Preventing recovery counts as light activity for the torturer, and requires an hourís work per day per victim. A victim successfully treated with this form of torture does not heal hit point naturally from rest for that day.\n- Torture. Over the course of an hour, you can torture a victim with intent to subdue or kill. If the Heal check is successful, victim get up to you ""Heal"" level stress attempts or damage points. If check fail roll d6 - on 1,2,3 victim get less damage/stress by rolled values, on 4,5,6 victim gets extra points of damage/stress equal to 1,2,3 accordingly.  "
                                                      withRulesExamples:@"Here are examples of tasks and their stats:\nd10 test. Treat Poison. Treat Disease. Treat Injuries. Long-Term Care..."
                                                        withDescription:@"Advanced skill. Providing first aid, treating a wound, or treating poison. Treating a disease or tending a creature wounded. Treating deadly wounds takes 1 hour of work. Providing long-term care requires 8 hours of light activity."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierHight
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.reason
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _heal = skillTemplate;
    }
    return _heal;
}

//animalHandling
-(SkillTemplate *)animalHandling{
    if (!_animalHandling){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",animalHandlingName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:animalHandlingName
                                                              withRules:@"Rules:\nTo interract with animals in a way that suits you you'll need to pass animal handling test. It can be harder if you deal with exotic animal, or animal suffer from penalties. \n\nOn every even number of skill's levels you gain bonuses. This skill gives you following advantages: You begin to understand and replicate very basic intentions of most common animals. You can show or read such emotions as aggression and calm. With levels you will understand more complex emotions or uncommon animals.  \nLevel 7 - You gain a pet with maximum of bulk 1. You can choose a quest for baby of a larger animal, it should be more dangerous (and harder to find) then just to get a common dog.\nLevel 9 etc. on uneven - You gain an additional pet with max bulk of 1 OR your baby pet growths larger by a bulk of 2 (other pet's stats should growths accordingly!)."
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. Covers the ability to handle and care for animals, as well as get them to respond to training and commands. Animal handling can also be used to try and calm an aggressive animal, or get a sense of an animal’s disposition. Specialisation options: Command, train, sense disposition, calm animal."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultAdvBasicBarrierHight
                                                   withSkillProgression:defaultAdvProgression
                                               withBasicSkillGrowthGoes:defaultAdvGrowhtGoesLow
                                                          withSkillType:AdvancedSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.control
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _animalHandling = skillTemplate;
    }
    return _animalHandling;
}

#pragma mark melee weapons skills
//blunt
-(SkillTemplate *)blunt{
    if (!_blunt){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",bluntName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:bluntName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. Covers the skill of using crushing potential of weapon in melee combat."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultMeleeWeaponBasicBarrier
                                                   withSkillProgression:defaultMeleeWeaponProgression
                                               withBasicSkillGrowthGoes:defaultMeleeWeaponGrowhtGoes
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.weaponSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _blunt = skillTemplate;
    }
    return _blunt;
}

//cutting
-(SkillTemplate *)cutting{
    if (!_cutting){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",ordinaryName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:ordinaryName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. Covers the skill of using cutting potential of weapon in melee combat."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultMeleeWeaponBasicBarrier
                                                   withSkillProgression:defaultMeleeWeaponProgression
                                               withBasicSkillGrowthGoes:defaultMeleeWeaponGrowhtGoes
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.weaponSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _cutting = skillTemplate;
    }
    return _cutting;
}

//piercing
-(SkillTemplate *)piercing{
    if (!_piercing){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",flailName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:flailName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. Covers the skill of using piercing potential of weapon in melee combat."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultMeleeWeaponBasicBarrier
                                                   withSkillProgression:defaultMeleeWeaponProgression
                                               withBasicSkillGrowthGoes:defaultMeleeWeaponGrowhtGoes
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.weaponSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _piercing = skillTemplate;
    }
    return _piercing;
}

#pragma mark ranged weapons skills
//bow
-(SkillTemplate *)bow{
    if (!_bow){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",bowName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:bowName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of short and long bows."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultRangeWeaponBasicBarrier
                                                   withSkillProgression:defaultRangeWeaponProgression
                                               withBasicSkillGrowthGoes:defaultRangeWeaponGrowhtGoes
                                                          withSkillType:RangeSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.ballisticSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _bow = skillTemplate;
    }
    return _bow;
}

//blackpowder
-(SkillTemplate *)blackpowder{
    if (!_blackpowder){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",blackpowderName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:blackpowderName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of blunderbusses, handguns, Hochland long rifles, pistols, repeater handguns and repeater pistols."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultRangeWeaponBasicBarrier
                                                   withSkillProgression:defaultRangeWeaponProgression
                                               withBasicSkillGrowthGoes:defaultRangeWeaponGrowhtGoes
                                                          withSkillType:RangeSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.ballisticSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _blackpowder = skillTemplate;
    }
    return _blackpowder;
}

//crossbow
-(SkillTemplate *)crossbow{
    if (!_crossbow){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",crossbowName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:crossbowName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of crossbows, crossbow pistols and repeater crossbows."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultRangeWeaponBasicBarrier
                                                   withSkillProgression:defaultRangeWeaponProgression
                                               withBasicSkillGrowthGoes:defaultRangeWeaponGrowhtGoes
                                                          withSkillType:RangeSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.ballisticSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _crossbow = skillTemplate;
    }
    return _crossbow;
}

//thrown
-(SkillTemplate *)thrown{
    if (!_thrown){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",thrownName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:thrownName
                                                              withRules:nil
                                                      withRulesExamples:nil
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of javelins, lasso, nets, spear, throwing axes/hammers/daggers/stars, whips, slings and staff slings."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:defaultRangeWeaponBasicBarrier
                                                   withSkillProgression:defaultRangeWeaponProgression
                                               withBasicSkillGrowthGoes:defaultRangeWeaponGrowhtGoes
                                                          withSkillType:RangeSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.ballisticSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _thrown = skillTemplate;
    }
    return _thrown;
}


@end
