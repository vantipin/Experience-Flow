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
#import "Pic.h"

#define physiqueName       @"Physique"
#define physiqueKey        @"Physique"
#define intelligenceName   @"Intelligence"
#define intelligenceKey    @"Intelligence"

#define weaponSkillName    @"Melee"
#define weaponSkillKey     @"Melee"
#define ballisticSkillName @"Range"
#define ballisticSkillKey  @"Range"

#define bluntName          @"Blunt"
#define ordinaryName       @"Cutting"
#define flailName          @"Piercing"
#define bluntKey           @"Crashing"
#define ordinaryKey        @"Cutting"
#define flailKey           @"Piercing"

#define bowName            @"Bow"
#define blackpowderName    @"Firearm"
#define thrownName         @"Thrown"
#define bowKey             @"Bow"
#define blackpowderKey     @"Firearm"
#define thrownKey          @"Thrown"

#define strengthName       @"Strength"
#define toughnessName      @"Toughness"
#define agilityName        @"Agility"
#define strengthKey        @"Strength"
#define toughnessKey       @"Toughness"
#define agilityKey         @"Agility"

#define reasonName         @"Reason"
#define disciplineName     @"Control"
#define perceptionName     @"Perception"
#define reasonKey          @"Reason"
#define disciplineKey      @"Control"
#define perceptionKey      @"Perception"

#define swimmingName       @"Swim"
#define climbName          @"Climb"
#define swimmingKey        @"Swim"
#define climbKey           @"Climb"

#define rideName           @"Ride"
#define knaveryName        @"Sleight Of Hand"
#define stealthName        @"Stealth"
#define escapeArtistName   @"Escape Artist"
#define rideKey            @"Ride"
#define knaveryKey         @"Knavery"
#define stealthKey         @"Stealth"
#define escapeArtistKey    @"Escape Artist"

#define senseMotiveName    @"Sense Motive"
#define disguiseName       @"Disguise"
#define survivalName       @"Survival"
#define senseMotiveKey     @"Sense Motive"
#define disguiseKey        @"Disguise"
#define survivalKey        @"Survival"

#define animalHandlingName @"Handle Animal"
#define bluffName          @"Bluff"
#define diplomacyName      @"Diplomacy"
#define intimidateName     @"Intimidate"
#define wishMagicName      @"Ritual Magic"
#define animalHandlingKey  @"Handle Animal"
#define bluffKey           @"Bluff"
#define diplomacyKey       @"Diplomacy"
#define intimidateKey      @"Intimidate"
#define wishMagicKey       @"Ritual Magic"

#define hackDeviceName     @"Hack Device"
#define healName           @"Heal"
#define appraiseName       @"Appraise"
#define craftName          @"Craft"
#define magicName          @"Dragon Magic"
#define alchemyName        @"Alchemy"
#define hackDeviceKey      @"Hack Device"
#define healKey            @"Heal"
#define appraiseKey        @"Appraise"
#define craftKey           @"Craft"
#define magicKey           @"Azure Magic"
#define alchemyKey         @"Alchemy"


//first level skills
static float defaultCoreSkillProgression = 3;
static float defaultCoreSkillBarrier = 14;

//second level skills
static float defaultPhsAndMnsProgression = 4.8;
static float defaultPhsAndMnsBasicBarrier = 4.8;
static float defaultPhsAndMnsGrowhtGoes = 0.14;

static float toughnessBasicBarrier = 4;
static float toughnessProgression = 4;

static float mentalSkillHightBasicBarrier = 4.8;
static float mentalSkillHightProgression = 4.8;

//third level skills
static float defaultAdvGrowhtGoes = 0.4;
static float defaultAdvBasicBarrierHight = 7;
static float defaultAdvBasicBarrierLow = 5;
static float defaultAdvProgression = 4;

static float veryLowBasicBarrier = 3;
static float veryLowProgression = 2;

static float defaultMagicProgression = 4;
static float defaultMagicBasicBarrier = 6;

static float defaultMeleeWeaponProgression = 5;
static float defaultMeleeWeaponBasicBarrier = 8;
static float defaultMeleeWeaponGrowhtGoes = 0.3;

static float defaultRangeWeaponProgression = 4;
static float defaultRangeWeaponBasicBarrier = 6;
static float defaultRangeWeaponGrowhtGoes = 0.3;

static float defaultRangeWeaponProgressionFirearm = 2;
static float defaultRangeWeaponBasicBarrierFirearm = 4;
static float defaultRangeWeaponGrowhtGoesFirearm = 0.3;


static int defaultEncumbrancePenalties = 10;
static int minutesToLooseStress = 2;

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
        }
    });
    
    return instance;
}

-(NSArray *)allSkillTemplates
{
    NSArray *allDefaultSkills;
    
    allDefaultSkills = @[self.physique,
                         self.intelligence,
                         
                         self.melee,
                         self.range,
                         self.strength,
                         self.toughness,
                         self.agility,
                         self.reason,
                         self.control,
                         self.perception,
                         
                         
                         self.crashing,
                         self.cutting,
                         self.piercing,
                         self.bow,
                         self.firearm,
                         self.thrown,
                         
                         self.swimming,
                         self.climb,
                         
                         self.stealth,
                         self.escapeArtist,
                         self.knavery,
                         self.ride,
                         
                         self.hackDevice,
                         self.heal,
                         self.appraise,
                         self.craft,
                         self.magic,
                         self.alchemy,
                         
                         self.bluff,
                         self.diplomacy,
                         self.intimidate,
                         self.animalHandling,
                         self.wishMagic,
                         
                         self.disguise,
                         self.senseMotive,
                         self.survival];
    
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
    
    allCharacterSkills = @[self.melee,
                           self.range,
                           self.strength,
                           self.toughness,
                           self.agility,
                           self.reason,
                           self.control,
                           self.perception,
                           self.magic,
                           self.physique,
                           self.intelligence];
    
    return allCharacterSkills;
}

-(NSArray *)allMeleeCombatSkillTemplates
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.crashing,
                           self.cutting,
                           self.piercing];
    
    return allCharacterSkills;
}

-(NSArray *)allRangeCombatSkillTemplates
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.bow,
                           self.firearm,
                           self.thrown];
    
    return allCharacterSkills;
}


-(SkillTemplate *)newSkillTemplateWithUniqName:(NSString *)name
                                nameForDisplay:(NSString *)nameForDisplay
                                     withRules:(NSString *)rules
                             withRulesExamples:(NSString *)examples
                               withDescription:(NSString *)skillDescription
                                 withSkillIcon:(NSString *)icon
                            withBasicXpBarrier:(float)basicXpBarrier
                          withSkillProgression:(float)skillProgression
                      withBasicSkillGrowthGoes:(float)basicSkillGrowthGoes
                                 withSkillType:(SkillClassesType)skillClassType
                        withDefaultStartingLvl:(int)startingLvl
                       withParentSkillTemplate:(SkillTemplate *)basicSkillTemplate
                                   withContext:(NSManagedObjectContext *)context;
{
    return [self newSkillTemplateWithUniqName:name
                               nameForDisplay:nameForDisplay
                                    withRules:rules
                            withRulesExamples:examples
                              withDescription:skillDescription
                                withSkillIcon:icon
                           withBasicXpBarrier:basicXpBarrier
                         withSkillProgression:skillProgression
                     withBasicSkillGrowthGoes:basicSkillGrowthGoes
                                withSkillType:skillClassType
                       withDefaultStartingLvl:startingLvl
                      withParentSkillTemplate:basicSkillTemplate
                                   isMediator:false withContext:context];
}

-(SkillTemplate *)newSkillTemplateWithUniqName:(NSString *)name
                                nameForDisplay:(NSString * )nameForDisplay
                                     withRules:(NSString *)rules
                             withRulesExamples:(NSString *)examples
                               withDescription:(NSString *)skillDescription
                                 withSkillIcon:(NSString *)icon
                            withBasicXpBarrier:(float)basicXpBarrier
                          withSkillProgression:(float)skillProgression
                      withBasicSkillGrowthGoes:(float)basicSkillGrowthGoes
                                 withSkillType:(SkillClassesType)skillClassType
                        withDefaultStartingLvl:(int)startingLvl
                       withParentSkillTemplate:(SkillTemplate *)basicSkillTemplate
                                    isMediator:(BOOL)isMediatorSkill
                                   withContext:(NSManagedObjectContext *)context;
{
    
    SkillTemplate *skillTemplate;
    Pic *pic = [Pic picWithPath:icon];
    NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withContext:self.context];
    
    if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
        skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:name
                                                 withNameForDisplay:nameForDisplay
                                                          withRules:rules
                                                  withRulesExamples:examples
                                                    withDescription:skillDescription
                                                      withSkillIcon:pic
                                                 withBasicXpBarrier:basicXpBarrier
                                               withSkillProgression:skillProgression
                                           withBasicSkillGrowthGoes:basicSkillGrowthGoes
                                                      withSkillType:skillClassType
                                             withDefaultStartingLvl:startingLvl
                                            withParentSkillTemplate:basicSkillTemplate
                                                         isMediator:isMediatorSkill
                                                        withContext:context];
    }
    else{
        skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        skillTemplate.name = name;
        skillTemplate.nameForDisplay = nameForDisplay;
        skillTemplate.skillRules = rules;
        skillTemplate.skillRulesExamples = examples;
        skillTemplate.skillDescription = skillDescription;
        skillTemplate.icon = pic;
        skillTemplate.levelBasicBarrier = basicXpBarrier;
        skillTemplate.levelProgression = skillProgression;
        skillTemplate.defaultLevel = startingLvl;
        skillTemplate.isMediator = isMediatorSkill;
    }

    return skillTemplate;
}

#pragma mark -
#pragma mark basic skills

//physique
-(SkillTemplate *)physique{
    if (!_physique){
        SkillTemplate *skillTemplate;
        
        skillTemplate = [self newSkillTemplateWithUniqName:physiqueKey
                                            nameForDisplay:physiqueName
                                                 withRules:@"Rules:\n- Character get 1 xp point to a certain skill, whenever he uses this skill. Character will get 1 xp point for check, no matter was that check successful or not. Success or Fail describe whenever character is progress thought the game.\n - Any weapon skills usually doesn't require checks and give static bonus. Character get experience bonus whenever he choose to fight. In a battle every turn player fight - he get xp point, according to the weapon or battle style he uses.\n- Training skill outside real-time mode (like saying that “my character swing a sword for 2 hours”) will give him 1 xp point per 3 hours. This rule works unless skill description or rules notice otherwise. Craft, for example, give 1 xp point per day (12 hours). Skill that require check against opponent skill will require someone to participate."
                                         withRulesExamples:nil
                                           withDescription:@"Boost character’s strenght, toughness, agility and weapon skills."
                                             withSkillIcon:@"physique"
                                        withBasicXpBarrier:defaultCoreSkillBarrier
                                      withSkillProgression:defaultCoreSkillProgression
                                  withBasicSkillGrowthGoes:0
                                             withSkillType:BasicSkillType
                                    withDefaultStartingLvl:2
                                   withParentSkillTemplate:nil
                                                isMediator:true
                                               withContext:self.context];
        
        _physique = skillTemplate;
        
    }
    return _physique;
}

//intelligence
-(SkillTemplate *)intelligence{
    if (!_intelligence){
        SkillTemplate *skillTemplate;
        
        skillTemplate = [self newSkillTemplateWithUniqName:intelligenceKey
                                            nameForDisplay:intelligenceName
                                                 withRules:@"Rules:\n- Character get 1 xp point to a certain skill, whenever he uses this skill. Character will get 1 xp point for check, no matter was that check successful or not. Success or Fail describe whenever character is progress thought the game.\n- Training skill outside real-time mode will give him 1 xp point per 3 hours. This rule works unless skill description or rules notice otherwise. Craft, for example, give 1 xp point per day (12 hours). Skill that require check against opponent skill will require someone to participate."
                                         withRulesExamples:nil
                                           withDescription:@"Boost character’s reason, perception and control."
                                             withSkillIcon:@"intellegence"
                                        withBasicXpBarrier:defaultCoreSkillBarrier
                                      withSkillProgression:defaultCoreSkillProgression
                                  withBasicSkillGrowthGoes:0
                                             withSkillType:BasicSkillType
                                    withDefaultStartingLvl:2
                                   withParentSkillTemplate:nil
                                                isMediator:true
                                               withContext:self.context];
        
        _intelligence = skillTemplate;
        
    }
    return _intelligence;
}

//weaponSkill
-(SkillTemplate *)melee{
    if (!_melee){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:weaponSkillKey
                                            nameForDisplay:weaponSkillName
                                                 withRules:@"Rules:\n- All melee attacks hit automatically. Roll d6 “to hit” dice. This is not skill check. Value on “to hit” dice represent quality of the strike. So assuming opponent aim to hit vulnerable parts – higher value means opponent hit less protected body part, lower – more protected. 1,2,3 – will lower damage class by 3,2,1. On 4,5,6 your damage class remains.\n- Every weapon has +2 (5,6 on “to hit”) to stun an opponent. Opponent loses 1 Action and 1 Initiative point for each stunning attack in the Next round. Blunt weapon has +4 to stun an opponent (3,4,5,6).\n- Everyone can pick only one card to represent his tactic for the turn. At the start of the turn all involved in a conflict start to pick cards starting with those of low Initiative.\n- Some cards will allow to change them during the battle or to combine them with others – this can be decided, during the battle. Usually penalties or cost for this may outweigh the tactical benefits.\n- During the battle, after “to hit” dices was rolled opponent is free to change defensive reaction if action card allow it. Then effect of the action card and blows calculated."
                                         withRulesExamples:nil
                                           withDescription:@"Weapon skill. Boost a variety of melee weapons."
                                             withSkillIcon:@"meele"
                                        withBasicXpBarrier:8
                                      withSkillProgression:8
                                  withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.physique
                                                isMediator:true
                                               withContext:self.context];
        
        _melee = skillTemplate;
        
    }
    return _melee;
}

//ballisticSkill
-(SkillTemplate *)range{
    if (!_range){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:ballisticSkillKey
                                            nameForDisplay:ballisticSkillName
                                                 withRules:@"Rules:\n- On successful hit, roll d6 “to hit” dice. This is not skill check. Value on “to hit” dice represent quality of the strike. So assuming opponent aim to hit vulnerable parts – higher value means opponent hit less protected body part, lower – more protected. 1,2,3 – will lower damage class by 3,2,1. On 4,5,6 your damage class remains.\n- Every weapon has +2 (5,6 on “to hit”) to stun an opponent. Opponent loses 1 Action and 1 Initiative point for each stunning attack in the Next round. Blunt weapon has +4 to stun an opponent (3,4,5,6).\n- Everyone can pick only one card to represent his tactic for the turn. At the start of the turn all involved in a conflict start to pick cards starting with those of low Initiative."
                                         withRulesExamples:nil
                                           withDescription:@"Weapon skill. Boost a variety of ranged weapons."
                                             withSkillIcon:@"range"
                                        withBasicXpBarrier:8
                                      withSkillProgression:8
                                  withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.physique
                                                isMediator:true
                                               withContext:self.context];
        
        _range = skillTemplate;
        
    }
    return _range;
}


//strength
-(SkillTemplate *)strength{
    if (!_strength){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:strengthKey
                                            nameForDisplay:strengthName
                                                 withRules:[NSString stringWithFormat:@"Rules:\n- All melee damage get bonus from Strength.\n- This skill opposes enemy Toughness. Before damage is dealt - it lowers by Toughness.\n- Overall character carrying capacity equal to level of this skill  multiplied by 3. If character get overloaded he/she gain 1 stress point for every 3 point of excess encumbrance until character decide free his/her inventory.\n- Character gain adrenalin whenever he understand the danger to his life in current situation. Character get 3 adrenalin points each time and is able to accumulate up to his Strength adrenaline points.\n- Adrenalin is always given every round during the battle, if of cause character aware the battle is going on. If character decide to flee or in any way avoid the confrontation he still get adrenalin points.\n- Outside direct confrontation, adrenalin is gained only if character is under direct threat and only with some stress points. If someone decide to cause himself pain in order to invoke adrenalin, pain should be sever enough to cause at least 1 stress point.\n- Each adrenalin point give +1 to all Physique related skill checks.\n- You loose 1 Adrenalin point (as well as Fear or Fatigue acquired Stress point) each %d minutes, in case nothing treating your live.",minutesToLooseStress]
                                         withRulesExamples:nil
                                           withDescription:@"Covers general physical prowess and applying strength and conditioning to a task. The ability to efficiently lift, push or pull heavy objects and drag more stuff around. Capacity for adrenaline."
                                             withSkillIcon:@"strength"
                                        withBasicXpBarrier:defaultPhsAndMnsBasicBarrier
                                      withSkillProgression:defaultPhsAndMnsProgression
                                  withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:2
                                   withParentSkillTemplate:self.physique
                                               withContext:self.context];
        
        _strength = skillTemplate;
    }
    return _strength;
}

//resilience
-(SkillTemplate *)toughness{
    if (!_toughness){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:toughnessKey
                                            nameForDisplay:toughnessName
                                                 withRules:nil
                                         withRulesExamples:nil
                                           withDescription:@"Resist punishment, recover fatigue, resist disease, resist poison, resist starvation. A character’s fitness, vigour, and ability to bounce back from strain and damage. Also covers use of a shield to bear the brunt of an attack and absorb the punishment. Resilience is often used to recover from wounds or fatigue over time, such as after bed rest. "
                                             withSkillIcon:@"toughness"
                                        withBasicXpBarrier:toughnessBasicBarrier
                                      withSkillProgression:toughnessProgression
                                  withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:3
                                   withParentSkillTemplate:self.physique
                                               withContext:self.context];
        
        _toughness = skillTemplate;
    }
    return _toughness;
}

//agility
-(SkillTemplate *)agility{
    if (!_agility){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:agilityKey
                                            nameForDisplay:agilityName
                                                 withRules:[NSString stringWithFormat:@"Rules:\n- For every %d points of encumbrance (counting equipment you are wearing) you get modifier -1 to all agility checks.\n- Using a balancing pole (two hands) while traversing a narrow surface grants +1 to Agility check.\n- If you use a pole as part of a running jump, you gain a +2 bonus on your Agility check (but must let go of the pole in the process).",defaultEncumbrancePenalties]
                                         withRulesExamples:@"d6 Agility checks:\n- Modifier 0. Move on narrow surface or uneven ground without falling at half speed. Running Jump with distance equal to the half of your movement. Running distance must be more or equal to jumping distance. Dive, roll without falling down.\n- Modifier -2. Jump from a place with distance equal to the half of your movement.\n- Modifier -4. Running Jump with distance equal to your movement. Running distance must be more or equal to jumping distance. Immediately get up after falling down.\n- Modifier -6. Move(at full speed)/Fight on narrow surface or uneven ground without falling.\n- Modifier -8. Jump from a place with distance equal to your movement.\n\nd6 Agility check. Jumping from a height and trying land on feet will be check against double the height in meters. On success character get damage equal to double the height but with Strength 0. On failure Strength of the hit increases to amount of damage and you'll need to get up.\n- Modifier +4. Water-like liquid.\n- Modifier +2. Soft Ground: fresh snow, thick dust, wet mud.\n- Modifier 0. Firm Ground: Most normal outdoor surfaces (such as lawns, fields, woods, and the like) or exceptionally soft or dirty indoor surfaces (thick rugs and very dirty or dusty floors).\n- Modifier -2.  Hard Ground: Bare rock or an indoor floor."
                                           withDescription:@"Describe a skill and grace in physical movement. Keeping balance while traversing narrow or treacherous surfaces. You can also dive, flip, jump, roll, avoid attacks."
                                             withSkillIcon:@"agility"
                                        withBasicXpBarrier:defaultPhsAndMnsBasicBarrier
                                      withSkillProgression:defaultPhsAndMnsProgression
                                  withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:2
                                   withParentSkillTemplate:self.physique
                                               withContext:self.context];
        
        _agility = skillTemplate;
    }
    return _agility;
}

//reason
-(SkillTemplate *)reason{
    if (!_reason){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:reasonKey
                                            nameForDisplay:reasonName
                                                 withRules:nil
                                         withRulesExamples:nil
                                           withDescription:@"Defines a character’s knowledge, and powers of deduction. Reason is used for a variety of academic and knowledge-based skills, and is important for controlling azure magic. With level you gain more rear and complex knowledge.\nBy passing varied education tests you might recall facts about actual topic which can help the situation.\n- When you can call to reason of a person to reassure or convince him change his mind you can use education for this test."
                                             withSkillIcon:@"reason"
                                        withBasicXpBarrier:mentalSkillHightBasicBarrier
                                      withSkillProgression:mentalSkillHightProgression
                                  withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:2
                                   withParentSkillTemplate:self.intelligence
                                               withContext:self.context];
        _reason = skillTemplate;
    }
    return _reason;
}

//discipline
-(SkillTemplate *)control{
    if (!_control){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:disciplineKey
                                            nameForDisplay:disciplineName
                                                 withRules:[NSString stringWithFormat:@"Rules:\n- World is full of terrible things, fearsome creatures inhabit the plain and horrible things await you in the darkness. Facing challenges realms provide take great carriage, but no man is immune to fear and when it finds your character, he might get stress points and loose same number of mental health.\n- Matter of perception. It is important that different creatures perceive world differently. If someone can't see source of stress - he won't be scared. In what context items used also it important. Any advanced tools will seems as Supernatural for primitive mind, any wielder of such tools - as a god or some Unnatural being.\n- Character have mental health equal to double the number of the Control level.\n- By loosing mental health character become the subject of paranoia and madness. Every time character looses mental health  - roll d6 check with remaining mental health points.\nFail: character slips into madness. Roll d8. Character loses same number +6 of Control xp points. On 1-3 additionally randomize madness effect.\n- If mental health drops to zero or below, character loses consciousness until he restores some points.\n- Character restore 1 point of mental health every day.\n- Character restore 1 point of mental health each time he loses 3 stress points.\n- Each stress point last for %d minutes, if character have a place to calm down. If character can in any way sense source of stress - he can't get calm.\n- Making any stress related checks on fail will result in 1 stress point. Auto-failing checks will result in number of stress points equal to exceeding skill modifier points plus one.\nExample: character has Control skill 4. Sight of dead disfigured human body shocks him - d6 check against 5. 4-5=-1. On d6 check with -1 is auto-fail. Exceeding points equal 0--1=1. Character get 1 +1=2 points of stress.\n- Every stress point add penalty -1 modifier to all skill checks. Melee weapon action points modify accordingly.\n- Character may get stress points as a result of social interaction (losing social conflict or simply as a result of Intimidate skill). Character or NPC most likely will perceive minor goal until they lose any mental health. If goals are important - until they no longer can pass “madness” checks automatically. Upon loosing they will prefer to drop current objective and retreat.",minutesToLooseStress]
                                         withRulesExamples:@"d6 check against modifier. Once per encounter. Can't rest while can feel near by (see, hear etc.) source of stress. However if check was auto-success source is ignored. Modifiers for check won't combine with each other.\n- Modifier -1. Minor Disturbing sight. Blood, foul insects or rot. Dead animal. Place of dark presence (old manor with bad history, place of minor dark ritual, place of murder).\n- Modifier -3. Disturbing sight. Dead human body(ies). Foul festering wound(s). Unexpected minor unnatural  events. Scene of torture.\n- Modifier -5. Major disturbing sight. Disfigured dead body, sight of horrible disfiguring  mutation, illness, spell. Presence of the Unnatural being.\n- Modifier -8. Colossal constructs from foulness, leaving or dead bodies, unidentified materiel. Sight of Unnatural intangible threat to person life or existence.\n- Modifier -10. Sight of pure Entropy, eternal abyss. Presence of an Ancient unnatural being (basically a god).\n- Modifier -18. Sight of Beyond Entropy.\n\nd6 check against damage. During the battle rolled in the end of the round. Grave wounds will cause stress.\n- Modifier “Damage during round” or in around 5 seconds. Sight of your own blood will count as Minor Disturbing sight as bonus to modifier."
                                           withDescription:@"Resist stress of fear or pain, resist intimidation, resist torture, oppose diplomacy persuasion. This skill is used to resist the startling effects of surprising events, show resolve in the face of danger, and maintain composure when confronted by supernatural or terrifying situations."
                                             withSkillIcon:@"control"
                                        withBasicXpBarrier:mentalSkillHightBasicBarrier
                                      withSkillProgression:mentalSkillHightProgression
                                  withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:2
                                   withParentSkillTemplate:self.intelligence
                                               withContext:self.context];
        _control = skillTemplate;
    }
    return _control;
}

//perception
-(SkillTemplate *)perception{
    if (!_perception){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:perceptionKey
                                            nameForDisplay:perceptionName
                                                 withRules:@"Rules:\n- Skill automatically performed when character is able to notice any possibly interesting details related to the surrounding. If character is actively searching any object (by size, color etc.) he rewarded with +1 to skill check modifier."
                                         withRulesExamples:@"d6 Perception checks:\n- Modifier +3/+10. Shining item. With range dim to extreme bright.\n- Modifier -2/+5. Size of the item with range of a coin to a man-size object. +5 for every point of bulk creature possess.\n- Modifier -6/+4. Color of subject. With range of the ideal camouflage to contrasting bright color. Characters usually will pick clothes of neutral colors, like grey, brown or black avoiding any penalties, however NPC might be wearing fashion or ritual dresses, which might be more easy to pick. Penalties for the check would make any natural or artificial camouflages. If creature has more then 1 point of bulk, this multiplied by the creature's bulk.\n- Modifier 0. Normal well-lit place.\n- Modifier -3. Poorly-lit place.\n- Modifier -6. Dark place."
                                           withDescription:@"Using your senses to perceive your surroundings. You can't make use of things if you haven't notice them. Perception opposes other characters’ attempts at Stealth, or to otherwise avoid detection."
                                             withSkillIcon:@"perception"
                                        withBasicXpBarrier:mentalSkillHightBasicBarrier
                                      withSkillProgression:mentalSkillHightProgression
                                  withBasicSkillGrowthGoes:defaultPhsAndMnsGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:2
                                   withParentSkillTemplate:self.intelligence
                                               withContext:self.context];
        _perception = skillTemplate;
    }
    return _perception;
}


#pragma mark -
#pragma mark advanced skills

//swimming
-(SkillTemplate *)swimming{
    if (!_swimming){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:swimmingKey
                                            nameForDisplay:swimmingName
                                                 withRules:[NSString stringWithFormat:@"Rules:\n- Your swimming (or flounder) speed equals to the level of this skill minus modifier of the task. Minimum speed is equal to character Physique level. \n- To keep afloat perform Swim check against the modifier of the task. Failing mean you submerge into water and began to drawn. To break surface character need to make number of successful checks equal to number of failed checks. While drawing character can still move, but every turn should perform d6 Control check against the modifier of the task or get stress (and adrenalin) points.\n- For every %d points of encumbrance (counting equipment you are wearing) your swim level decreased by 1.\n- If you need to save someone who's drowning you should carry unlucky by yourself his/her encumbrance will be half of target Toughness multiplied by its bulk plus the half of it's equipment weight. Resulting encumbrance might vary, depending on the nature of the water. \n- Being, at least, half submerged to perform physique related actions you need to pass swim check against the modifier of the task. \n- You can hold your breath up to your Toughness level rounds. After that you will get automatically 1 stress (and adrenalin) point each round.\n - Walking in a strong current (Stormy water or very rapid flow) character might fall down if fails swim check. If character moves against water current his movement lowers accordingly to the modifier of the flow. \n- Characters which using smashing or blunt type of weapon deal only half of the damage underwater.",5]
                                         withRulesExamples:@"d6 checks against modifier:\n- Modifier -0. Quiet water.\n- Modifier -2. Calm water.\n- Modifier -4. Rough water.\n- Modifier -6. Stormy water.\n- Modifier -8.Very rapid flow.\n- Modifier -10. Extremely rapid flow.\n- Modifier +2. Holding on any floatable piece of wood at least half of your size.\n- Modifier +4. Holding on any floatable piece of wood at least your size."
                                           withDescription:@"The ability to keep afloat and efficiently control your body in a water."
                                             withSkillIcon:@"swim"
                                        withBasicXpBarrier:veryLowBasicBarrier
                                      withSkillProgression:veryLowProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.strength
                                               withContext:self.context];
        
        _swimming = skillTemplate;
    }
    return _swimming;
}

//climb
-(SkillTemplate *)climb{
    if (!_climb){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:climbKey
                                            nameForDisplay:climbName
                                                 withRules:[NSString stringWithFormat:@"Rules:\n- Character climbing speed equals to the skill minus modifier of the task. Minimum speed is equal to character Physique level.\nFail: you start slipping (with the speed of character Toughness multiplied by bulk.) or fall down (depending on a type of obstacle: climbing a pillar character will slip, but ceiling with handholds - will fall down). If climb skill check drops below zero you automatically fall down, even if character would normally slip.\n- In addition for every %d points of encumbrance (counting equipment you are wearing) your climb level decreased by 1.",defaultEncumbrancePenalties]
                                         withRulesExamples:@"d6 checks against modifier:\n- Modifier -1. A slope too steep to walk up, or a knotted rope with a wall to brace against, ladder or pulling yourself up when dangling by your hands. Or living obstacle which move with speed of 1-2 or fighting in close combat.\n- Modifier -3. A surface with ledges to hold on to and stand on, such as a very rough wall or a ship’s rigging. Any surface with adequate handholds and footholds (natural or artificial), such as a very rough natural rock surface or a tree, or an unknotted rope. Or living obstacle which move with speed of 3-5.\n- Modifier -5. An uneven surface with some narrow handholds and footholds, such as a typical wall in a dungeon or ruins. Or living obstacle which move with speed of 6-9.\n- Modifier -8. Or an overhang or ceiling with handholds but no footholds. Or living obstacle which move with speed of 10-13.\n- Modifier -12. A rough surface, such as a natural rock wall or a brick wall. Or living obstacle which move with speed of 14 and more.\n- Modifier -3. Performing any other physique related actions while climbing.\n- Modifier +2. Hook or crowbar for climbing. Can't be used for climbing ladder, ropes etc. If two hooks equipped in two hands bonus accumulate."
                                           withDescription:@"The ability to quickly climb slope too steep to walk, knotted rope etc."
                                             withSkillIcon:@"climb"
                                        withBasicXpBarrier:veryLowBasicBarrier
                                      withSkillProgression:veryLowProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.strength
                                               withContext:self.context];
        
        _climb = skillTemplate;
    }
    return _climb;
}

//stealth
-(SkillTemplate *)stealth{
    if (!_stealth){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:stealthKey
                                            nameForDisplay:stealthName
                                                 withRules:[NSString stringWithFormat:@"Rules:\n- For every %d points of encumbrance (counting equipment you are wearing) your stealth level decreased by 1.\n- To sneak you need to make d6 check against the surroundings Modifier*. If you fail opponent most likely will try to look around to find what made the nose. Usually opponent makes a perception check.\n- If you trying to sneak past your opponent crossing his sight of vision you need to make d6 Modified* check against opponent perception. Opponent Perception skill is modified as described in Perception rules This is usually unfairly hard check, so GM should warn you, saying something like “there is a chance he will notice you passing by“.",defaultEncumbrancePenalties]
                                         withRulesExamples:@"d6 checks against modifier:\n- Modifier 0. Normal surface.\n- Modifier -5. Noisy surface(scree, shallow or deep bog, undergrowth, dense rubble).\n- Modifier -10. Very noisy(dense undergrowth, deep snow)"
                                           withDescription:@"The ability to keep from being seen or heard, this skill combines hiding with being quiet. With level you gain understanding how move very quiet and pick up a matirials to make clothes to make as little sound as possible."
                                             withSkillIcon:@"stealth"
                                        withBasicXpBarrier:defaultAdvBasicBarrierLow
                                      withSkillProgression:defaultAdvProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.agility
                                               withContext:self.context];
        
        _stealth = skillTemplate;
    }
    return _stealth;
}

-(SkillTemplate *)escapeArtist{
    if (!_escapeArtist){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:escapeArtistKey
                                            nameForDisplay:escapeArtistName
                                                 withRules:nil
                                         withRulesExamples:@"- Ropes/Bindings. d10 check. 1 minute. Check goest against binder's Strenght skill.\n- Net, animate rope spell, command plants, control plants, or entangle. If no special penalties described it's d20 check. 1 full-round action. \nFail: character’s agility, perception and weapon skills lower by half. In addition – every turn you fight or move – failing d12 Escape Artist check will again lower skills by half (from current values) AND character falls down and unable to crawl. Weapon skill level are able to become 0 this way. Net can be cut by any small weapon (knife dagger). You can spend action points to roll d20 Str check with bonuses equal to weapon cutting damage to decrease net encumbrance by 1 point, until net render useless.\n- Tight Space. d12 check. At least 1 minute. Getting through a space where your head fits but your shoulders donít. If the space is long you may need to make multiple checks. You canít get through a space that your head does not fit through.\n- Escape Grab. d6 check against enemy Strenght. Standart Action.\n- Shackles. 1 minute. d12 check against level or Complexity of Shackles. Usually 5 for manacles and 8 for Masterwork Shackles."
                                           withDescription:@"Your training allows you to slip bonds and escape from grapples."
                                             withSkillIcon:@"escape artist"
                                        withBasicXpBarrier:defaultAdvBasicBarrierLow
                                      withSkillProgression:defaultAdvProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.agility
                                               withContext:self.context];
        
        _escapeArtist = skillTemplate;
    }
    return _escapeArtist;
}

//ride
-(SkillTemplate *)ride{
    if (!_ride){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:rideKey
                                            nameForDisplay:rideName
                                                 withRules:[NSString stringWithFormat:@"Rules:\n- You can gain bonuses or penalties to the skill level depending on quality of saddle or pose you choose to ride the mount. A good saddle gives +2 to the skill level. Riding bareback gives -4 to riding. \n- For every %d points of encumbrance (counting equipment you are wearing) your ride level decreased by 1.",defaultEncumbrancePenalties]                                                      withRulesExamples:@"d6 checks against modifier:\n- Modifier 0. Saddle, mount, ride, and dismount from a mount without a problem.\n- Modifier 0. Guide with knees. You can react instantly to guide your mount with your knees so that you can use both hands in combat. Make your Ride check at the start of your turn. If you fail, you can use only one hand this round because you need to use the other to control your mount.\n- Modifier 0. Stay in Saddle. You can react instantly to try to avoid falling when your mount rears or bolts unexpectedly or when you take damage. This usage does not take an action.\n- Modifier -2. Cover. You can react instantly to drop down and hang alongside your mount, using it as cover. You can’t attack or cast spells while using your mount as cover. If you fail your Ride check, you don’t get the cover benefit. This usage does not take an action.\n- Modifier -2. Soft fall. You can react instantly to try to take no damage when you fall off a mount — when it is killed or when it falls, for example. If you fail your Ride check, you take d6 falling damage. This usage does not take an action.\n- Modifier -2. Leap. You can get your mount to leap obstacles as part of its movement. If you fail your Ride check, you fall off the mount when it leaps and take the appropriate falling damage (at least d6 points). This usage does not take an action, but is part of the mount’s movement.\n- Modifier -2. Spur Mount. You can spur your mount to greater speed with an action. A successful Ride check increases the mount’s speed twice for 1 round but deals 1 fatigue to the creature.\n- Modifier -4. Control mount in battle. As an action, you can attempt to control a light horse, pony, heavy horse, or other mount not trained for combat riding while in battle. If you fail the Ride check, you can do nothing else in that round. You do not need to roll for warhorses or warponies.\n- Modifier -4. Fast mount or dismount. You can attempt to mount or dismount from a mount of up to one size category larger than yourself as a free action, provided that you still have an action available that round. If you fail the Ride check, mounting or dismounting is an action. You can’t use fast mount or dismount on a mount more than one size category larger than yourself.\n- Modifier -6. Stand on mount. This allows you to stand on your mount’s back even during movement or combat. You take no penalties to actions while doing so.\n- Modifier -10. Unconscious Control. As a free action, you can attempt to control a light horse, pony, or heavy horse while in combat. If the character fails, you control the mount with action point. You do not need to roll for warhorses or warponies.\n- Modifier -10. Attack from Cover. You can react instantly to drop down and hang alongside your mount, using it as one-half cover. You can attack and cast spells while using your mount as cover without penalty. If you fail, you don’t get the cover benefit."
                                           withDescription:@"Defines a character’s ability to ride or care for a horse or other common mount, as well as drive and manage a wagon or carriage."
                                             withSkillIcon:@"ride"
                                        withBasicXpBarrier:veryLowBasicBarrier
                                      withSkillProgression:veryLowProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.agility
                                               withContext:self.context];
        
        _ride = skillTemplate;
    }
    return _ride;
}

//knavery
-(SkillTemplate *)knavery{
    if (!_knavery){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:knaveryKey
                                            nameForDisplay:knaveryName
                                                 withRules:[NSString stringWithFormat:@"Rules:\n- For every %d points of encumbrance (counting equipment you are wearing) your knavery level decreased by 1.\n- If you are trying to perform check while someone watching you closely - to remain unnoticed you should pass knavery check against opponent perception.\n- You can use Sleight of Hand to bare shrouded item without losing Action points by making d6 check against Encumbrance of the item. ",defaultEncumbrancePenalties]
                                         withRulesExamples:@"d6 checks against modifier:\n- Modifier -2. Palm a coin-sized object, make a coin disappear.\n- Modifier -4. Lift a small object from a person.\n- Modifier -7. Lift a sheathed weapon from another creature and hide it on the character’s person, if the weapon is no more than one size category larger than the character’s own size.\n- Modifier -10. Make an adjacent, willing creature or object of the character’s size or smaller “disappear” while in plain view. In fact, the willing creature or object is displaced up to 10 feet away—make a separate knavery check to determine how well the “disappeared” creature or object is hidden."
                                           withDescription:@"Your training allows you to pick pockets, draw hidden weapons, and take a variety of actions without being noticed."
                                             withSkillIcon:@"knavery"
                                        withBasicXpBarrier:defaultAdvBasicBarrierLow
                                      withSkillProgression:defaultAdvProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.agility
                                               withContext:self.context];
        
        _knavery = skillTemplate;
    }
    return _knavery;
}

//Sence motive
-(SkillTemplate *)senseMotive{
    if (!_senseMotive){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:senseMotiveKey
                                            nameForDisplay:senseMotiveName
                                                 withRules:@"Rules:\n- Hunch. ??Social dynamics. Need rules for it bro?? You can get the feeling from another's behavior that something is wrong, such as when you're talking to an impostor. Alternatively, you can get the feeling that someone is trustworthy.\n- Sense Enchantment. If have no levels in Magic skill you gain -4 penalty. You can tell that someone's behavior is being influenced by an enchantment effect even if that person isn't aware of it.\n- Discern Secret Message. You may use Sense Motive to detect that a hidden message is being transmitted via the Bluff skill. In this case, your Sense Motive check is opposed by the Bluff check of the character transmitting the message. For each piece of information relating to the message that you are missing, you take a -2 penalty on your Sense Motive check."
                                         withRulesExamples:@"d6 check against opponent Control. Hunch.\nd6 check against opponent Ritual Magic. Sense Enchantment.\nd8 check against opponent Bluff. Discern Secret Message.Sense Enchantment."
                                           withDescription:@"This skill is opposed to enemy's Bluff. Sense Motive generally takes at least 1 minute, and you could spend a whole evening trying to get a sense of the people around you."
                                             withSkillIcon:@"sense motive"
                                        withBasicXpBarrier:defaultAdvBasicBarrierLow
                                      withSkillProgression:defaultAdvProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.perception
                                               withContext:self.context];
        
        _senseMotive = skillTemplate;
    }
    return _senseMotive;
}

//Disguise
-(SkillTemplate *)disguise{
    if (!_disguise){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:disguiseKey
                                            nameForDisplay:disguiseName
                                                 withRules:@"Rules:\n- Create artificial camouflage. You can use Disguise skill to create camouflage. Camouflage is considered part of the clothes and doesn't add encumbrance points. Camouflage will result in the opponent Perception skill penalties. Moving in camouflage will decrease its penalties by half (rounding down). Camouflage is made on d6 check and take 6 hours (half of the day) to make.\n- Create disguise. On fail your disguise suffer penalties equal to number of points you fail your check. Your Disguise result determines how good the disguise is, and it is opposed by others' Perception check results. If you don't draw any attention to yourself, others do not get to make Perception checks. If you come to the attention of people who are suspicious (such as a guard who is watching commoners walking through a city gate), it can be assumed that such observers are taking d6  Modified* Perception checks.\n- You get only one Disguise check per use of the skill, even if several people are making Perception checks against it. The Disguise check is made secretly, so that you can't be sure how good the result is.\n- The effectiveness of your disguise depends in part on how much you're attempting to change your appearance.\n- If you are impersonating a particular individual, those who know what that person looks like get a bonus on their Perception checks according to the table below. Furthermore, they are automatically considered to be suspicious of you, so opposed checks are always called for.\n- Usually, an individual makes a Perception check to see through your disguise immediately upon meeting you and every hour thereafter. If you casually meet many different creatures, each for a short time, check once per day or hour, using an average Perception modifier for the group.\n- Creating a disguise requires (2d3 * 10 - Disguise level) minutes of work, assuming you have all the materials.\n- Try again. You may try to redo a failed disguise, but once others know that a disguise was attempted, they'll be more suspicious.\n - Evaluate the disguise. You can ask ally to evaluate your disguise or do it yourself using good mirror. This is perception check."
                                         withRulesExamples:@"d6 check against designed camouflage modifier. Create artificial camouflage.\n- Modifier -6. Create a minor camouflage with -1 to opponent perception check.\n- Modifier -8. Create / upgrade to -2 penalty.\n- Modifier -10. Create / upgrade to -3 penalty.\n- Modifier -12. Create / upgrade to -4 penalty.\n- Modifier -14. Create / upgrade to -5 penalty.\n- Modifier -16. Create / upgrade to -6 penalty.\n\nd8 check against disguise complexity. Create disguise.\n- Modifier +2. Disguise need to change only minor details.\n- Modifier -1. Disguised as different gender.\n- Modifier -1. Disguised as different race.\n- Modifier -1. Disguised as different age category. Per step of difference between your actual age category and your disguised age category. The steps are: young (younger than adulthood), adulthood, middle age, old, and venerable.\n- Modifier -5. Disguised as different size category.\n\nRemain a secret. Opponent's perception check.\n- Modifier +2. Recognizes on sight.\n- Modifier +3. Friends or associates.\n- Modifier +4. Close friends.\n- Modifier +5. Intimate.\n- Modifier +3. Target is suspicious of you.\n- Modifier -2. Target remain unaware.\n"
                                           withDescription:@"You are skilled at changing your appearance."
                                             withSkillIcon:@"disguise"
                                        withBasicXpBarrier:veryLowBasicBarrier
                                      withSkillProgression:veryLowProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.perception
                                               withContext:self.context];
        
        _disguise = skillTemplate;
    }
    return _disguise;
}

-(SkillTemplate *)survival{
    if (!_survival){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:survivalKey
                                            nameForDisplay:survivalName
                                                 withRules:@"Rules:\n- You can keep yourself and others safe and fed in the wild.\n- Follow tracks. To find tracks or to follow them for 1 mile requires a successful Survival check. You must make another Survival check every time the tracks become difficult to follow. You move at half your normal speed while following tracks (or at your normal speed with a –3 penalty on the check, or at up to twice your normal speed with a –10 penalty on the check). The DC depends on the surface and the prevailing conditions, as given on table. A single Survival check may represent activity over the course of hours or a full day. A Survival check made to find tracks is at least a full-round action, and it may take even longer. For finding tracks, you can retry a failed check after 1 hour (outdoors) or 10 minutes (indoors) of searching."
                                         withRulesExamples:@"d8 check against modifier.\n- Modifier -2. Get along in the wild. Move up to half your overland speed while hunting and foraging (no food or water supplies needed). If you make this check automatically you can provide food and water for one other person for every 2 points by which your skill exceed check value.\n- Modifier -4. Keep from getting lost or avoid natural hazards, such as quicksand. Retries to avoid getting lost in a specific situation or to avoid a specific natural hazard are not allowed.\n- Modifier -4. Predict the weather up to 24 hours in advance. ). If you make this check automatically you can predict the weather for one additional day in advance for every 3 points by which your skill exceed check value.\n\nFollow tracks various checks.\n- d6 check. Very Soft Ground: Any surface (fresh snow, thick dust, wet mud) that holds deep, clear impressions of footprints.\n- d8 check. Soft Ground: Any surface soft enough to yield to pressure, but firmer than wet mud or fresh snow, in which a creature leaves frequent but shallow footprints.\n- d12 check.  Firm Ground: Most normal outdoor surfaces (such as lawns, fields, woods, and the like) or exceptionally soft or dirty indoor surfaces (thick rugs and very dirty or dusty floors). The creature might leave some traces (broken branches or tufts of hair), but it leaves only occasional or partial footprints.\n- d20 check.  Hard Ground: Any surface that doesn't hold footprints at all, such as bare rock or an indoor floor. Most streambeds fall into this category, since any footprints left behind are obscured or washed away. The creature leaves only traces (scuff marks or displaced pebbles).\n\n- Modifier -1.  Every hour of rain since the trail was made\n- Modifier -2.  Fog or precipitation, Moonlight\n- Modifier -3.  Overcast or moonless night, Tracked party hides trail (and moves at half speed).\n- Modifier +5.  Fresh snow since the trail was made\n- Modifier +2.  For every point of bulk creature had beyond 1."
                                           withDescription:@"You are skilled at surviving in the wild and at navigating in the wilderness. You also excel at following trails and tracks left by others. It can also be used to spot traps, pitfalls, and other physical dangers."
                                             withSkillIcon:@"survival"
                                        withBasicXpBarrier:veryLowBasicBarrier
                                      withSkillProgression:veryLowProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.perception
                                               withContext:self.context];
        
        _survival = skillTemplate;
    }
    return _survival;
}

//appraise
-(SkillTemplate *)appraise{
    if (!_appraise){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:appraiseKey
                                            nameForDisplay:appraiseName
                                                 withRules:@"Rules:\n- Determine the price of non-magical goods that contain precious metals or gemstones, the value of a common item\n- Determine if the item has magic properties. Get -4 penalty if character has no levels in Magic skill.\n- Additional attempts to Appraise an item reveal the same result."
                                         withRulesExamples:@"d6 check against Rarity or Crafting Complexity of the item. \nOn success get item price. +/-d6 coins. \nOn fail price modified by 10% for 6, by 20% for 5, by 30% for 4, by 40% for 3, by 50% for 2, by 60% for automatic fail. Roll a separate dice to determine - if the imagining cost will go up or down. However if character crafted an item of such complexity (+/-3), no matter the roll he always get only 10% modified price."
                                           withDescription:@"An item is worth only what someone will pay for it. To an art collector, a canvas covered in daubs of random paint may be a masterpiece; a priestess might believe that an old jawbone is a holy relic of a saint.\nThe Appraise skill allows a character to accurately value an object. However, the fine arts of the jeweler, antiquarian, and bibliophile are complex. Valuable paintings may be concealed by grime, and books of incredible rarity may be bound in tattered leather covers. Because failure means an inaccurate estimate, the GM should attempt this skill check in secret."
                                             withSkillIcon:@"apprise"
                                        withBasicXpBarrier:veryLowBasicBarrier
                                      withSkillProgression:veryLowProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.reason
                                               withContext:self.context];
        
        _appraise = skillTemplate;
    }
    return _appraise;
}


//pickALock
-(SkillTemplate *)hackDevice{
    if (!_hackDevice){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:hackDeviceKey
                                            nameForDisplay:hackDeviceName
                                                 withRules:@"Rules:\n- Use lockpick to open locks. For others mechanism to break will suffice any long hard tool, yet such use most likely will damage your tool of choice.\n- To perform this skill character require number of 30 sec equal to modifier of the task.  \n- Failing check usually doesn't affect the character (aside from wasting his/her time and wear disabling tools), but in some cases it can trigger an action, depending on a type of device."
                                         withRulesExamples:@"Different Hack Device checks:\n- Modifier -4. d6 check. Jam a lock.\n- Modifier -6. d6 check. Sabotage a wagon wheel. Lockpick a simple constructed lock.\n- Modifier -8. d8 check. Disarm a trap, reset a trap. Lockpick a average constructed lock.\n- Modifier -10. d10 check. Disarm a complex trap, cleverly sabotage a clockwork device. Lockpick a good constructed lock.\n- Modifier -12. d12 check. Sabotage ingeniously crafted mechanism. Lockpick an amazingly constructed or very exotic lock."
                                           withDescription:@"You are skilled at disarming traps and opening locks. In addition, this skill lets you sabotage simple mechanical devices, such as catapults, wagon wheels, and doors."
                                             withSkillIcon:@"hack devices"
                                        withBasicXpBarrier:defaultAdvBasicBarrierLow
                                      withSkillProgression:defaultAdvProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.reason
                                               withContext:self.context];
        
        _hackDevice = skillTemplate;
    }
    return _hackDevice;
}

//heal
-(SkillTemplate *)heal{
    if (!_heal){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:healKey
                                            nameForDisplay:healName
                                                 withRules:@"Rules:\n- Trying again. You can’t try a Heal check again without witnessing proof of the original check’s failure. You can always retry a check to provide first aid, assuming the target of the previous attempt is still alive. Usually checks made once per day.\n- Long-Term Care. 8 hours of light activity. Which boiled down to 2 hour of usual work. Providing long-term care means treating a wounded person for a day or more. In any case treated character get +1 to recovered hit points.\n- Treat Poison.  Every time the poisoned character makes a saving throw against the poison modifier, you make same Heal check. If you pass the check some specified progress achieved.\n- Treat Disease. 30 min each check. Every time the diseased character makes a saving throw against disease, you make a Heal check against disease modifier. If you pass the check some specified progress achieved.\n- Although the Heal skill is traditionally used to aid the injured, treat poison and disease, and otherwise provide comfort to the wounded and infirm, the anatomic knowledge granted by this skill allows it to be used for far more nefarious uses as well. Any character may attempt to torture a living target with physical and mental anguish; the results of such torture can be determined with a Heal check.\n- Prevent Recovery. A victim in the care of a torturer can be prevented from naturally healing from wounds by worrying the victimís wounds, keeping him malnourished, and using various substances to promote prolonged sickness. Preventing recovery counts as light activity for the torturer, and requires 2 hours work per day per victim. A victim successfully treated with this form of torture does not heal hit point naturally from rest for that day.\n- Torture. Over the course of an hour, you can torture a victim with intent to subdue or kill. Wound the opponent to proceed. For this hit you free to control value on “to hit” dice. Victim make a d6 Control check against your Heal and, if fail, receive stress points according to rules. After that you can use Diplomacy against stressed opponent to ask questions. If he persist don't worry - he won't restore those stress points while you around with your tools. Try again. You are always free to change opponent Control modifier from 0 up to your Heal skill level. Will fit using tools for Metal working. If you have any - you get +3 modifier."
                                         withRulesExamples:@"d6 check against modifier. Treat Poison. Treat Disease.\n- Modifier “Physyque” of the opponent. Prevent recovery."
                                           withDescription:@"Providing first aid, treating a wound, or treating poison. Treating a disease or tending a creature wounded."
                                             withSkillIcon:@"heal"
                                        withBasicXpBarrier:veryLowBasicBarrier
                                      withSkillProgression:veryLowProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.reason
                                               withContext:self.context];
        _heal = skillTemplate;
    }
    return _heal;
}

-(SkillTemplate *)craft{
    if (!_craft){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:craftKey
                                            nameForDisplay:craftName
                                                 withRules:@"Rules:\n- Craft checks are made by the day for each item.\n- You can try again, but if complexity of the item is enough to miss with 2-4 on d6, you ruin half the raw materials and as a result - have to pay half the original raw material cost again.\n- Accelerated Crafting. You can get some help, but others must have enough craft skill to have a chance to create item with difficulty decreased by 3 points, speed increases by the number of people working on a project. Each make separate check. Helpers make the same check with decreased difficulty (by 6).\n- Repairing/Care for tools. If item is damaged (rusted, bent, blunt, has minor cracks etc.) - it still can be used. Usually item get spoiled in a bad conditions - extensive use or special conditions, specified in item description. If player item is got damaged next step severe damage.\n - Restore item. If the item is severely damaged - it is of no use until restored. The material's cost of repairing an item is one-fifth of the item's price (if isn't noticed otherwise)."
                                         withRulesExamples:@"d6 check against Complexity of the item. Craft or repair the item.\n- Modifier -Half Of The Item Complexity (rounded down). Repairing damaged items takes only 3 hours each and, if specified, special tools.\n- Modifier -Item Complexity. Restore item. It takes half (rounded down) of the item original time to make to restore these items and full set of tools used to craft it."
                                           withDescription:@"You are skilled in the creation of a specific group of items, such as armor or weapons. You know how to use the tools of your trade, how to perform the craft's daily tasks, how to supervise untrained helpers, and how to handle common problems. (Untrained laborers and assistants earn an average of 4 coins day.)"
                                             withSkillIcon:@"craft"
                                        withBasicXpBarrier:veryLowBasicBarrier
                                      withSkillProgression:veryLowProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.reason
                                               withContext:self.context];
        
        _craft = skillTemplate;
    }
    return _craft;
}

-(SkillTemplate *)alchemy{
    if (!_alchemy){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:alchemyKey
                                            nameForDisplay:alchemyName
                                                 withRules:@"Rules:\n- I hope you know the rules :p"
                                         withRulesExamples:@"d6 check against Complexity of the potion."
                                           withDescription:nil
                                             withSkillIcon:@"alchemy"
                                        withBasicXpBarrier:veryLowBasicBarrier
                                      withSkillProgression:veryLowProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.reason
                                               withContext:self.context];
        
        _alchemy = skillTemplate;
    }
    return _alchemy;
}

-(SkillTemplate *)magic{
    if (!_magic){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:magicKey
                                            nameForDisplay:magicName
                                                 withRules:@"Rules: \n- Generating magic pool. At the start of every turn every magic user get Magic Generator Dices (MGD) equal to his magic skill level (MS).\n- Reshaping spell. You can add or pull (pulled dices can’t be reused in spellcatsing) number of magic dices from a spell after the Caster chose how much dices he wants to use. To add or pull a specific dice roll D6 Magic Skill check against value on a dice. If you fail you still add/pull the dice but you get 1 Stress Point.\n- Wild magic. Spell get +1 to MS for every Wild dice used to boost it. For every 2 natural 6 on magic dices Wild dice from wizard pool automatically added to spell pool. If there are more then 1 wild dice in spell - uneven numbers mean that spell get extra burst and magic mistake take place. Even number mean that spell doesn’t work at all and simply nothing happens. Every time wizard reshaping spell with wild magic dice he get 1 Stress Point.\n- Counter-spell Wizard can safely block any spell and it’s consequences if he gathers and pays in magic cost more or equal then original resulting spell cost. This “counter-spell” casting process the same as usual spell."
                                         withRulesExamples:nil
                                           withDescription:@"An ability to summon a magical blue flame which burn and warp everything in contact. Flame appear an inch above his hands and as long as Wizard keep focus on the fire it won't go out on it own. Mage can force the flame to become a firm blue crystal or flowing burning liquid. Legends say that dragons taught the first mages how to wield the flame. That and the fact that dragons fire is said to has the same properties earned another name for this flame – Dragon frame or Dragon magic."
                                             withSkillIcon:@"azure magic"
                                        withBasicXpBarrier:defaultMagicBasicBarrier
                                      withSkillProgression:defaultMagicProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.reason
                                                isMediator:false
                                               withContext:self.context];
        
        _magic = skillTemplate;
        
    }
    return _magic;
}


-(SkillTemplate *)animalHandling{
    if (!_animalHandling){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:animalHandlingKey
                                            nameForDisplay:animalHandlingName
                                                 withRules:@"Rules:\n- Handle an Animal. This task involves commanding an animal to perform a task or trick that it knows. If your check succeeds, the animal performs the task or trick on its next action.\n- Teach an animal a trick. One week of work. Animal can learn number of tricks equal to it's Reason level.\n- Train an animal for a general purpose. Rather than teaching an animal individual tricks, you can simply train it for a general purpose. Essentially, an animal's purpose represents a preselected set of known tricks that fit into a common scheme, such as guarding or heavy labor. The animal must meet all the normal prerequisites for all tricks included in the training package. An animal can be trained for only one general purpose, though if the creature is capable of learning additional tricks (above and beyond those included in its general purpose), it may do so. Training an animal for a purpose requires fewer checks than teaching individual tricks does, but no less time.\n- Rear a Wild Animal. To rear an animal means to raise a wild creature from infancy so that it becomes domesticated. A handler can rear as many as three creatures of the same kind at once. A successfully domesticated animal can be taught tricks at the same time it's being raised, or it can be taught as a domesticated animal later.\n- For tasks with specific time frames noted above, you must spend half this time (at the rate of 3 hours per day per animal being handled) working toward completion of the task before you attempt the Handle Animal check. If the check fails, your attempt to teach, rear, or train the animal fails and you need not complete the teaching, rearing, or training time. If the check succeeds, you must invest the remainder of the time to complete the teaching, rearing, or training. If the time is interrupted or the task is not followed through to completion, the attempt to teach, rear, or train the animal automatically fails.\n- You gain bonuses to the skill checks equal to animal Reason skill if of course it friendly to you."
                                         withRulesExamples:@"d6 check. Handle an animal. Teach an animal a trick. Train an animal for a general purpose*. Rear a wild animal.\n\n*General Purpose\nModifier -4. Air Support\nModifier -4. Combat Training (or 'Combat Riding')\nModifier -6. Burglar\nModifier -4. Fighting\nModifier -4. Guarding\nModifier -2. Heavy labor\nModifier -4. Hunting\nModifier -6. Liberator\nModifier -2. Performance\nModifier -2. Riding\n\n*Additional factors\nModifier -4. Animal is wounded or forced to hustle for more than 1 hour between sleep cycles. Rear a wild animal with bad temper.\nModifier -6. Push the animal to perform a task or trick that it doesn't know but is physically capable of performing.\n\nTrain an Animal for a Purpose\n- Air Support. Modifier -4. An animal trained in air support knows the attack, bombard, and deliver tricks.\n- Burglar. Modifier -6. An animal trained as a burglar knows the come, fetch, seek, and sneak tricks and can steal objects. You can order it to steal a specific item you point out.\n- Riding. Modifier -2. An animal trained to bear a rider knows the tricks come, heel, and stay. Training an animal for riding takes 2 weeks.\n- Combat Training. Modifier -4. An animal trained to bear a rider into combat knows the tricks attack, come, defend, down, guard, and heel. Training an animal for combat riding takes 4 weeks. You may also 'upgrade' an animal trained for riding to one trained for combat by spending 2 weeks and making a successful Handle Animal check with -3 penalty. The new general purpose and tricks completely replace the animal's previous purpose and any tricks it once knew. Many horses and riding dogs are trained in this way.\n- Fighting. Modifier -4. An animal trained to engage in combat knows the tricks attack, down, and stay. Training an animal for fighting takes 2 weeks.\n- Guarding. Modifier -4. An animal trained to guard knows the tricks attack, defend, menace, down, and guard. Training an animal for guarding takes 3 weeks.\n- Heavy Labor. Modifier -2. An animal trained for heavy labor knows the tricks come and work. Training an animal for heavy labor takes 1 week and 3 days.\n- Hunting. Modifier -4. An animal trained for hunting knows the tricks attack, down, fetch, heel, seek, and track. Training an animal for hunting takes 4 weeks.\n- Liberator. Modifier -6. An animal trained in liberating knows the break out, flee, and get help tricks.\n- Performance. Modifier -2. An animal trained for performance knows the tricks come, fetch, heel, perform, and stay. Training an animal for performance takes 3 weeks and 2 days.\n- Servant. Modifier -4. An animal trained as a servant knows the deliver, exclusive, and serve tricks.\n\n\nTricks\n- Aid. Modifier -4.  Aid a specific ally in combat by attacking a specific foe the ally is fighting. You may point to a particular creature that you wish the animal to aid, and another that you want it make an attack action against, and it will comply if able. The normal creature type restrictions governing the attack trick still apply.\n- Attack. Modifier -4. The animal attacks apparent enemies. You may point to a particular creature that you wish the animal to attack, and it will comply if able. Normally, an animal will attack only humanoids, monstrous humanoids, giants, or other animals. Teaching an animal to attack all creatures (including such unnatural creatures as undead and aberrations) counts as two tricks.\n- Bombard. Modifier -4. A flying animal can deliver projectiles on command, attempting to drop a specified item that it can carry (often alchemist's fire or some other incendiary) on a designated point or opponent, using its Thrown skill to determine its attack roll. The animal cannot throw the object, and must be able to fly directly over the target.\n- Break Out. Modifier -4. On command, the animal attempts to break or gnaw through any bars or bindings restricting itself, its handler, or a person indicated by the handler. If not effective on its own, this trick can grant the target character a +4 circumstance bonus on Escape Artist checks. The animal can also take certain basic actions like lifting a latch or bringing its master an unattended key. Weight and Strength restrictions still apply, and pickpocketing a key or picking any sort of lock is still far beyond the animal's ability.\n- Bury. Modifier -2. An animal with this trick can be instructed to bury an object in its possession. The animal normally seeks a secluded place to bury its object. An animal with both bury and fetch can be instructed to fetch an item it has buried.\n- Combat action. Modifier -4. The animal is trained to use a specific combat action on command. An animal must know the attack trick before it can be taught the maneuver trick, and it only performs maneuvers against targets it would normally attack. This trick can be taught to an animal multiple times. Each time it is taught, the animal can be commanded to use a different combat action.\n- Come. Modifier -2. The animal comes to you, even if it normally would not do so.\n- Defend. Modifier -4. The animal defends you (or is ready to defend you if no threat is present), even without any command being given. Alternatively, you can command the animal to defend a specific other character.\n- Deliver. Modifier -2. The animal takes an object (one you or an ally gives it, or that it recovers with the fetch trick) to a place or person you indicate. If you indicate a place, the animal drops the item and returns to you. If you indicate a person, the animal stays adjacent to the person until the item is taken. (Retrieving an item from an animal using the deliver trick is a move action.)\n- Detect. Modifier -6. The animal is trained to seek out the smells of explosives and poisons, unusual noises or echoes, air currents, and other common elements signifying potential dangers or secret passages. When commanded, the animal uses its Perception skill to try to pinpoint the source of anything that strikes it as unusual about a room or location. Note that because the animal is not intelligent, any number of strange mechanisms, doors, scents, or unfamiliar objects may catch the animal's attention, and it cannot attempt the same Perception check more than once in this way.\n- Down. Modifier -2. The animal breaks off from combat or otherwise backs down. An animal that doesn't know this trick continues to fight until it must flee (due to injury, a fear effect, or the like) or its opponent is defeated.\n- Entertain. Modifier -6. The animal can dance, sing, or perform some other impressive and enjoyable trick to entertain those around it. At the command of its owner, the animal can make a Perform check to show off its talent. Willing onlookers or those who fail an opposed Sense Motive check take a ñ2 penalty on Perception checks to notice anything but the animal entertaining them. Tricksters and con artists often teach their animals to perform this trick while they pickpocket viewers or sneak about unnoticed.\n- Exclusive. Modifier -4. The animal takes directions only from the handler who taught it this trick. If an animal has both the exclusive and serve tricks, it takes directions only from the handler that taught it the exclusive trick and those creatures indicated by the trainer's serve command. An animal with the exclusive trick does not take trick commands from others even if it is friendly or helpful toward them (such as through the result of a charm animal spell), though this does not prevent it from being controlled by other enchantment spells (such as dominate animal), and the animal still otherwise acts as a friendly or helpful creature when applicable.\n- Fetch. Modifier -2. The animal goes and gets something. If you do not point out a specific item, the animal fetches some random object.\n- Flee. Modifier -4. The animal attempts to run away or hide as best it can, returning only when its handler commands it to do so. Until such a command is received, the animal does its best to track its handler and any creatures with him or her, remaining hidden but within range of its sight or hearing. This trick is particularly useful for thieves and adventurers in that it allows the animal to evade capture, then return later to help free its friends.\n- Get Help. Modifier -4. With this trick, a trainer can designate a number of creatures up to the animal's Reason score as 'help.' When the command is given, the animal attempts to find one of those people and bring her back to the handler, even if that means journeying a long distance to the last place it encountered the target creature.\n- Guard. Modifier -4. The animal stays in place and prevents others from approaching.\n- Heel. Modifier -2. The animal follows you closely, even to places where it normally wouldn't go.\n- Hunt. Modifier -4. This trick allows an animal to use its natural stalking or foraging instincts to find food and return it to the animal's handler. An animal with this trick may attempt Survival checks  to provide food for others or lead them to water and shelter (as the 'get along in the wild' use of the Survival skill). An animal with this trick may use the aid another action to assist Survival checks made by its handler for these purposes.\n- Perform. Modifier -2. The animal performs a variety of simple tricks, such as sitting up, rolling over, roaring or barking, and so on.\n- Menace. Modifier -4. A menacing animal attempts to keep a creature you indicate from moving. It does its best to intimidate the target, but only attacks if the target attempts to move from its present location or take any significant action (particularly a hostile-seeming one). As soon as the target stops moving, the animal ceases attacking, but continues to menace.\n- Seek. Modifier -2. The animal moves into an area and looks around for anything that is obviously alive or animate.\n- Serve. Modifier -2. An animal with this trick willingly takes orders from a creature you designate. If the creature you tell the animal to serve knows what tricks the animal has, it can instruct the animal to perform these tricks using your Handle Animal bonus on the check instead of its own. The animal treats the designated ally as friendly. An animal can unlearn this trick with 1 week of training. This trick can be taught to an animal multiple times. Each time it is taught, the animal can serve an additional creature you designate.\n- Sneak. Modifier -2. The animal can be ordered to make Stealth checks in order to stay hidden and to continue using Stealth even when circumstances or its natural instincts would normally cause it to abandon secrecy.\n- Stay. Modifier -2. The animal stays in place, waiting for you to return. It does not challenge other creatures that come by, though it still defends itself if it needs to.\n- Track. Modifier -4. The animal tracks the scent presented to it. (This requires the animal to have the scent ability)\n- Throw Rider. Modifier -2. The animal can attempt to fling a creature riding it to the ground. Treat this as a trip combat action that applies to all creatures riding the animal. An animal that knows the throw rider and exclusive tricks can be instructed to attempt to automatically throw anyone other than its trainer who attempts to ride it.\n- Watch. Modifier -2. The animal can be commanded to keep watch over a particular area, such as a campsite, and raise an alarm if it notices any sizable or dangerous creature entering the area. This trick is often included in the Guarding purpose.\n- Work. Modifier -2. The animal pulls or pushes a medium or heavy load."
                                           withDescription:@"You are trained at working with animals, and can teach them tricks, get them to follow your simple commands, or even domesticate them."
                         
                                             withSkillIcon:@"handle animal"
                                        withBasicXpBarrier:veryLowBasicBarrier
                                      withSkillProgression:veryLowProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.control
                                               withContext:self.context];
        _animalHandling = skillTemplate;
    }
    return _animalHandling;
}

//diplomacy
-(SkillTemplate *)diplomacy{
    if (!_diplomacy){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:diplomacyKey
                                            nameForDisplay:diplomacyName
                                                 withRules:@"Rules:\n- Influence Attitude. ??Bind to socail dynamics rules?? Using Diplomacy to influence a creature's attitude takes 1 minute of continuous interaction. \nSucceed: If you succeed, the character's attitude toward you is improved by one step. A creature's attitude cannot be shifted more than two steps up in this way, although the GM can override this rule in some situations. \nFail: character's attitude toward you is unchanged. If you fail by 2-3, the character's attitude toward you is decreased by one step.\n- Make Request. Making a request of a creature takes 1 or more rounds of interaction, depending upon the complexity of the request.\n- Gather Information. Using Diplomacy to gather information takes 1d4 hours of work, searching for rumors and informants. Most commonly known facts or rumors it is d10. For obscure or secret knowledge, might increase to d20 or higher. The GM might rule that some topics are simply unknown to common folk.\n\nd10 check. Gather common Information.\nd20 check. Gather obscure Information.\n\n- You cannot use Diplomacy to influence a given creature's attitude more than once in a 24 hour period. If a request is refused, the result does not change with additional checks, although other requests might be made. You can retry Diplomacy checks made to gather information.\n- You cannot use Diplomacy against a creature that does not understand you or has an Reason of 3 or less. Diplomacy is generally ineffective in combat and against creatures that intend to harm you or your allies in the immediate future."
                                         withRulesExamples:@"\nChecks goes against creature Control skill.\nd12 check. Hostile\nd10 check. Unfriendly\nd8 check.  Indifferent\nd6 check. Friendly\n0 check.  Helpful\n\nModifier +2. Give simple advice or directions.\nModifier 0. Give detailed advice.\nModifier 0. Give simple aid.\nModifier -2. Reveal an unimportant secret.\nModifier -2. Give lengthy or complicated aid.\nModifier -4. Give dangerous aid.\nModifier -4 or more. Reveal secret knowledge.\nModifier -6 or more. Give aid that could result in punishment.\nModifier -2 per request. Additional requests.\n\n"
                                           withDescription:@"You can use this skill to persuade others to agree with your arguments, to resolve differences, and to gather valuable information or rumors from people. This skill is also used to negotiate conflicts by using the proper etiquette and manners suitable to the problem."
                                             withSkillIcon:@"diplomacy"
                                        withBasicXpBarrier:defaultAdvBasicBarrierHight
                                      withSkillProgression:defaultAdvProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.control
                                               withContext:self.context];
        _diplomacy = skillTemplate;
    }
    return _diplomacy;
}


//intimidate
-(SkillTemplate *)intimidate{
    if (!_intimidate){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:intimidateKey
                                            nameForDisplay:intimidateName
                                                 withRules:@"Rules:\n- Checks goes against enemy Control skill.\n- Demoralize. Demoralizing an opponent is a standard action. You can use this skill to cause an opponent stress points. \nSuccess: If you are successful, the target get stress point. If you make this check automatically - opponent get 1 stress point for 2 extra points of Intimidate check. \nFail: The opponent is not stressed.\n- Influence Attitude. You can use Intimidate to force an opponent to act friendly toward you for 1d6 * 10 minutes with a successful check. Using Intimidate to change an opponent's attitude requires 1 minute of conversation.\n\nSuccess: If successful, the opponent will:\n*give you information you desire\n*take actions that do not endanger it\n*offer other limited assistance\nAfter the intimidate expires, the target treats you as unfriendly and may report you to local authorities.\n\nFail: If you fail this check by 2-4, the target attempts to deceive you or otherwise hinder your activities."
                                         withRulesExamples:@"d6 check. Demoralize. Influence Attitude. Influence Attitude Action.\nModifier +2/-2. Bulk of one creature exceed bulk of another. Modifier will change by 2 points for each extra point of bulk.\nModifier +2/-2. Physique skills sum (Str + Ag + To) exceed other creature skills sum by at least 2 points.\nModifier -5/+5. Additional factors like outfit, situation or nature of creature.\nModifier -2 for each time. Try again. This increase resets after one hour has passed."
                                           withDescription:@"You can use this skill to frighten your opponents or to get them to act in a way that benefits you. This skill includes verbal threats and displays of prowess."
                                             withSkillIcon:@"intimidate"
                                        withBasicXpBarrier:defaultAdvBasicBarrierHight
                                      withSkillProgression:defaultAdvProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.control
                                               withContext:self.context];
        _intimidate = skillTemplate;
    }
    return _intimidate;
}

//bluff
-(SkillTemplate *)bluff{
    if (!_bluff){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:bluffKey
                                            nameForDisplay:bluffName
                                                 withRules:@"Rules:\n- Deceive Someone. Attempting to deceive someone takes at least 1 round, but can possibly take longer if the lie is elaborate.\n- Feint in Combat. Once per round. Make standard check against Sense Motive of a opponent (or highest number in a group) any time during round and repick action card. Choosing another action card during the fight will cost in -1 penalty to all rolls.\n- Deliver Secret Message. You can use Bluff to pass hidden messages to another character without others understanding your true meaning. Delivering a secret message generally takes twice as long as the message would otherwise take to relay.\n- Act (comedy, drama, pantomime). You can impress audiences with your talent and skill. Trying to earn money by playing in public requires anywhere from an evening's work to a full day's performance. Retries are allowed, but they don't negate previous failures, and an audience that has been unimpressed in the past is likely to be prejudiced against future performances. Make a group performance making more coins (multiplied by number of players) will result in separate (hiding) checks with coins going in one “bucket“."
                                         withRulesExamples:@"Modifier +3. The target wants to believe you\nModifier +3. The lie is believable\nModifier 0. The lie is unlikely\nModifier -3. The lie is far-fetched\nModifier -10. The lie is impossible\nModifier +3. The target is drunk or impaired\nModifier up to +5. You possess convincing proof\n\nAll checks goes against opponent “Sense Motive“ skill. \nd6 Bluff checks:\n- Modifier -1. Deceive Someone.\n- Modifier -1. Feint in Combat.\n- Modifier -4. Deliver Secret Message. Roll multiple times for complex message.\n- Modifier -2. Routine performance. Trying to earn money by playing in public is akin to begging. You can earn 1-2 coins/day.\n- Modifier -4. Enjoyable performance. In a prosperous city, you can earn 1-3 coins/day.\n- Modifier -6. Great performance. In a prosperous city, you can earn 2-5 coins/day. In time, you may be invited to join a professional troupe and may develop a regional reputation.\n- Modifier -8. Memorable performance. In a prosperous city, you can earn 3-7 coins/day. In time, you may come to the attention of noble patrons and develop a national reputation.\n- Modifier -10. Extraordinary performance. In a prosperous city, you can earn 5-9 coins/day. In time, you may draw attention from distant patrons, or even from extraplanar beings.\n- Modifier -2 each time. Retries are allowed, but they don't negate previous failures, and an audience that has been unimpressed in the past is likely to be prejudiced against future performances."
                                           withDescription:@"Bluff is an opposed skill check against your opponent's Sense Motive skill. If you use Bluff to fool someone, with a successful check you convince your opponent that what you are saying is true. Bluff checks are modified depending upon the believability of the lie. The following modifiers are applied to the roll of the creature attempting to tell the lie. Note that some lies are so improbable that it is impossible to convince anyone that they are true."
                                             withSkillIcon:@"bluff"
                                        withBasicXpBarrier:defaultAdvBasicBarrierLow
                                      withSkillProgression:defaultAdvProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.control
                                               withContext:self.context];
        
        _bluff = skillTemplate;
    }
    return _bluff;
}

-(SkillTemplate *)wishMagic{
    if (!_wishMagic){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:wishMagicKey
                                            nameForDisplay:wishMagicName
                                                 withRules:@"Rules:\n- I hope you know the rules :p"
                                         withRulesExamples:@"d6 check against Complexity of the ritual."
                                           withDescription:nil
                                             withSkillIcon:@"ritual magic"
                                        withBasicXpBarrier:defaultMagicBasicBarrier
                                      withSkillProgression:defaultMagicProgression
                                  withBasicSkillGrowthGoes:defaultAdvGrowhtGoes
                                             withSkillType:AdvancedSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.control
                                               withContext:self.context];
        
        _wishMagic = skillTemplate;
    }
    return _wishMagic;
}


#pragma mark melee weapons skills
//blunt
-(SkillTemplate *)crashing{
    if (!_crashing){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:bluntKey
                                            nameForDisplay:bluntName
                                                 withRules:@"Rules:\n- Determine number of action points in combat, giving chosen use of weapon.\n- Blunt attack give +2 to concussion chance.\n- If weapon is too large/ encumbrance for using in one hand (your Strength < Encumbrance value of weapon) this weapon gain double Encumbrance while you hold it.\n- Weapon damage get bonus from your Strength.\n- Melee weapon in two hands. If you strong enough to hold weapon in one hand without penalties you gain  +25% Strength (+50% for weapons with long handle) (rounding down) for melee hits while wielding it in two hands.\n- Two melee weapons in two hands. Every strike will result in two separate rolls for each weapon. If weapons have bonuses they stack accordingly. You should pick battle style for both weapons at the same time.\n- To change weapon in your hand you need to spend one Action point. But you always is able to try using Sleight Of Hand to draw or change weapon free of charge.\n- Blunt type of weapon deal only half of the damage if submerged underwater."
                                         withRulesExamples:nil
                                           withDescription:@"Covers the skill of using crushing potential of weapon in melee combat."
                                             withSkillIcon:@"crushing"
                                        withBasicXpBarrier:defaultMeleeWeaponBasicBarrier
                                      withSkillProgression:defaultMeleeWeaponProgression
                                  withBasicSkillGrowthGoes:defaultMeleeWeaponGrowhtGoes
                                             withSkillType:MeleeSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.melee
                                               withContext:self.context];
        _crashing = skillTemplate;
    }
    return _crashing;
}

//cutting
-(SkillTemplate *)cutting{
    if (!_cutting){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:ordinaryKey
                                            nameForDisplay:ordinaryName
                                                 withRules:@"Rules:\n- Determine number of action points in combat, giving chosen use of weapon.\n- Cutting attack deal bloodletting, which deal 1 hit point damage every round for 2x dealt damage rounds. Effect stack.\n- If weapon is too large/ encumbrance for using in one hand (your Strength < Encumbrance value of weapon) this weapon gain double Encumbrance while you hold it.\n- Weapon damage get bonus from your Strength.\n- Melee weapon in two hands. If you strong enough to hold weapon in one hand without penalties you gain  +25% Strength (+50% for weapons with long handle) (rounding down) for melee hits while wielding it in two hands.\n- Two melee weapons in two hands. Every strike will result in two separate rolls for each weapon. If weapons have bonuses they stack accordingly. You should pick battle style for both weapons at the same time.\n- To change weapon in your hand you need to spend one Action point. But you always is able to try using Sleight Of Hand to draw or change weapon free of charge."
                                         withRulesExamples:nil
                                           withDescription:@"Covers the skill of using cutting potential of weapon in melee combat."
                                             withSkillIcon:@"cutting"
                                        withBasicXpBarrier:defaultMeleeWeaponBasicBarrier
                                      withSkillProgression:defaultMeleeWeaponProgression
                                  withBasicSkillGrowthGoes:defaultMeleeWeaponGrowhtGoes
                                             withSkillType:MeleeSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.melee
                                               withContext:self.context];
        _cutting = skillTemplate;
    }
    return _cutting;
}

//piercing
-(SkillTemplate *)piercing{
    if (!_piercing){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:flailKey
                                            nameForDisplay:flailName
                                                 withRules:@"Rules:\n- Determine number of action points in combat, giving chosen use of weapon.\n- Piercing attack deal bloodletting, which deal 1 hit point damage every round for 2x dealt damage rounds. Effect stack.\n- If weapon is too large/ encumbrance for using in one hand (your Strength < Encumbrance value of weapon) this weapon gain double Encumbrance while you hold it.\n- Weapon damage get bonus from your Strength.\n- Melee weapon in two hands. If you strong enough to hold weapon in one hand without penalties you gain  +25% Strength (+50% for weapons with long handle) (rounding down) for melee hits while wielding it in two hands.\n- Two melee weapons in two hands. Every strike will result in two separate rolls for each weapon. If weapons have bonuses they stack accordingly. You should pick battle style for both weapons at the same time.\n- To change weapon in your hand you need to spend one Action point. But you always is able to try using Sleight Of Hand to draw or change weapon free of charge."
                                         withRulesExamples:nil
                                           withDescription:@"Covers the skill of using piercing potential of weapon in melee combat."
                                             withSkillIcon:@"piercing"
                                        withBasicXpBarrier:defaultMeleeWeaponBasicBarrier
                                      withSkillProgression:defaultMeleeWeaponProgression
                                  withBasicSkillGrowthGoes:defaultMeleeWeaponGrowhtGoes
                                             withSkillType:MeleeSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.melee
                                               withContext:self.context];
        _piercing = skillTemplate;
    }
    return _piercing;
}

#pragma mark ranged weapons skills
//bow
-(SkillTemplate *)bow{
    if (!_bow){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:bowKey
                                            nameForDisplay:bowName
                                                 withRules:@"Rules:\n- Determining a chance of you hitting a target using bows.\n- Using this weapon in close combat will automatically damage it.\n- To use this skill pick “Aiming shot“ action card.\n- While aiming, you DO spend endurance points.\n- You will take penalties for extra distance. Average shooting distance is 200. Character will throw without penalties for 50% of the distance (0-100) and take -4 penalty to skill for the rest of the distance (101-200).\n- Water will reduce damage by 3 points for each meter it flies through water."
                                         withRulesExamples:@"d10 check.\n- Modifier -5. Shooting past the 50% of the aiming distance of the weapon. \n- Modifier -Current movement points. Character moving himself. Otherwise only part of the penalty applies relative to position, speed and moving direction of the target.\n- Modifier -5. Target is hiding behind cover. You can choose to ignore this modifier if you choose to strike through the cover. Shooting through any creature will lower damage by it's x2 Toughness multiplied by bulk plus any armor creature wearing. Wooden fence lower damage up to 10 points. Stone wall up to 20."
                                           withDescription:@"Covers the basic use of short and long bows."
                                             withSkillIcon:@"bow"
                                        withBasicXpBarrier:defaultRangeWeaponBasicBarrier
                                      withSkillProgression:defaultRangeWeaponProgression
                                  withBasicSkillGrowthGoes:defaultRangeWeaponGrowhtGoes
                                             withSkillType:RangeSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.range
                                               withContext:self.context];
        _bow = skillTemplate;
    }
    return _bow;
}

//blackpowder
-(SkillTemplate *)firearm{
    if (!_firearm){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:blackpowderKey
                                            nameForDisplay:blackpowderName
                                                 withRules:@"Rules:\n- Determining a chance of you hitting a target using firearm-like weapon.\n- Using this weapon in close combat will automatically damage it.\n- To use this skill pick “Aiming shot“ action card.\n- Any firearm-like weapon in this time took 1 additional turn to reload. Before firing again you must spend 1 turn reloading weapon.\n- Shooting weapon can be used to deliver extra melee hit in close combat. This will hit automatically.\n- Repeating weapon reduced reloading time by introducing cage for projectiles. While there are ammunition in holder - no extra time for reload needed.\n- Firearm-like weapon is easy to learn. It takes much less time to develop this skill.\n- While aiming, you do not spend endurance points.\n- You will take penalties for extra distance. Average fire distance is 100. Character will shoot without penalties for 50% of the distance (0-50) and take -4 penalty to skill for the rest of the distance (51-100).\n- Water will reduce damage by 3 points for each meter it flies through water. Powder based weapon won't shoot if got wet!"
                                         withRulesExamples:@"d10 check.\n- Modifier +5. Reloading weapon.\n- Modifier -5. Shooting past the 50% of the aiming distance of the weapon. \n- Modifier -Current movement points. Character moving himself. Otherwise only part of the penalty applies relative to position, speed and moving direction of the target.\n- Modifier -5. Target is hiding behind cover. You can choose to ignore this modifier if you choose to strike through the cover. Shooting through any creature will lower damage by it's x2 Toughness multiplied by bulk plus any armor creature wearing. Wooden fence lower damage up to 15 points. Stone wall up to 30."
                                           withDescription:@"Covers the basic use of blunderbusses, handguns, pistols, crossbows and repeater crossbows."
                                             withSkillIcon:@"firearm"
                                        withBasicXpBarrier:defaultRangeWeaponBasicBarrierFirearm
                                      withSkillProgression:defaultRangeWeaponProgressionFirearm
                                  withBasicSkillGrowthGoes:defaultRangeWeaponGrowhtGoesFirearm
                                             withSkillType:RangeSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.range
                                               withContext:self.context];
        _firearm = skillTemplate;
    }
    return _firearm;
}

//thrown
-(SkillTemplate *)thrown{
    if (!_thrown){
        SkillTemplate *skillTemplate;
        skillTemplate = [self newSkillTemplateWithUniqName:thrownKey
                                            nameForDisplay:thrownName
                                                 withRules:@"Rules:\n- To use this skill pick “Aiming shot“ action card.\n- Weapon can be used to deliver melee strikes, but you can't block using this weapon.\n- Any throwing weapon, if originally unequipped, require Sleight of Hands check to determine if you are able to equip it, free of Action point charge.\n- While aiming, you do not spend endurance points.\n- You will take penalties for extra distance. Average throwing distance is 12. Character will throw without penalties for 50% of the distance (0-6) and take -4 penalty to skill for the rest of the distance (7-12).\n- Water will reduce damage by 3 points for each meter it flies through water."
                                         withRulesExamples:@"d10 check.\n- Modifier -5. Shooting past the 50% of the aiming distance of the weapon. \n- Modifier -Current movement points. Character moving himself. Otherwise only part of the penalty applies relative to position, speed and moving direction of the target.\n- Modifier -5. Target is hiding behind cover. You can choose to ignore this modifier if you choose to strike through the cover. Shooting through any creature will lower damage by it's x2 Toughness multiplied by bulk plus any armor creature wearing. Wooden fence lower damage up to 10 points. Stone wall up to 20."
                                           withDescription:@"Determining a chance of you hitting a target using javelins, lasso, nets, spear, throwing axes/daggers/stars, whips, slings and staff slings."
                                             withSkillIcon:@"thrown"
                                        withBasicXpBarrier:defaultRangeWeaponBasicBarrier
                                      withSkillProgression:defaultRangeWeaponProgression
                                  withBasicSkillGrowthGoes:defaultRangeWeaponGrowhtGoes
                                             withSkillType:RangeSkillType
                                    withDefaultStartingLvl:0
                                   withParentSkillTemplate:self.range
                                               withContext:self.context];
        _thrown = skillTemplate;
    }
    return _thrown;
}


@end
