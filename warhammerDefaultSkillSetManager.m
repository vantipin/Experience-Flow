//
//  warhammerCoreSkillSetManager.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 25.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "WarhammerDefaultSkillSetManager.h"
#import "Character.h"
#import "Skill.h"
#import "SkillTemplate.h"
#import "RangeSkill.h"
#import "MeleeSkill.h"
#import "MagicSkill.h"
#import "PietySkill.h"
#import "CoreDataViewController.h"


#define movementName @"M"
#define weaponSkillName @"WS"
#define ballisticSkillName @"BS"
#define strenghtName @"S"
#define toughnessName @"T"
#define initiativeName @"I"
#define leadesShipName @"Ld"

#define attacksName @"A"

#define unarmedName @"Unarmed"
#define ordinaryName @"Ordinary"
#define daggerName @"Dagger"
#define flailName @""
#define greatWeaponName @""
#define polearmName @""
#define cavalryName @""
#define fencingName @""
#define staffName @""
#define spearName @""

#define bowName @"Bow"


#define athleticsName @"Athletics"
#define stealthName @"Stealth"
#define resilienceName @"Resilience"
#define disciplineName @"Discipline"
#define perceptionName @"Perception"

static WarhammerDefaultSkillSetManager *instance = nil;

@interface WarhammerDefaultSkillSetManager()

@property (nonatomic) NSManagedObjectContext *context;

@end


@implementation WarhammerDefaultSkillSetManager

//basic
@synthesize movement = _movement;
@synthesize weaponSkill = _weaponSkill;
@synthesize ballisticSkill = _ballisticSkill;
@synthesize strenght = _strenght;
@synthesize toughness = _toughness;
@synthesize initiative = _initiative;
@synthesize leadesShip = _leadesShip;

//sub WS
@synthesize unarmed = _unarmed;
@synthesize ordinary = _ordinary;
@synthesize dagger = _dagger;
@synthesize flail = _flail;
@synthesize greatWeapon = _greatWeapon;
@synthesize polearm = _polearm;
@synthesize cavalry = _cavalry;
@synthesize fencing = _fencing;
@synthesize staff = _staff;
@synthesize spear = _spear;

//sub BS
@synthesize bow = _bow;

//advanced
@synthesize athletics = _athletics;
@synthesize stealth = _stealth;
@synthesize resilience = _resilience;
@synthesize discipline = _discipline;
@synthesize perception = _perception;


/*
@dynamic name;
@dynamic skillDescription;
@dynamic thisBasicBarrier;
@dynamic thisSkillProgression;
@dynamic basicSkillGrowthGoes;
@dynamic basicSkill;
@dynamic icon;
 */

/*
 @{@"name": @"",
 @"skillDescription": @"",
 @"thisBasicBarrier": @"",
 @"thisSkillProgression": @"",
 @"basicSkillGrowthGoes": @"",
 @"basicSkill": @"",
 @"icon": @""};
 */


+ (WarhammerDefaultSkillSetManager *)sharedInstance {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        if (!instance) {
            instance = [[WarhammerDefaultSkillSetManager alloc] init];
            //atexit(deallocSingleton);
        }
    });
    
    return instance;
}

-(NSManagedObjectContext *)context
{
    if (!_context)
    {
        _context = [[CoreDataViewController sharedInstance] managedObjectContext];
    }
    return _context;
}

-(NSArray *)allSystemDefaultSkillTemplates
{
    NSArray *allDefaultSkills;
    
    allDefaultSkills = @[self.movement,
                         self.weaponSkill,
                         self.ballisticSkill,
                         self.strenght,
                         self.toughness,
                         self.initiative,
                         self.leadesShip,
                         
                         self.unarmed,
                         self.ordinary,
                         self.dagger,
                         self.flail,
                         self.greatWeapon,
                         self.polearm,
                         self.cavalry,
                         self.fencing,
                         self.staff,
                         self.spear,
                         
                         self.bow,
                         
                         self.athletics,
                         self.stealth,
                         self.resilience,
                         self.discipline,
                         self.perception];
    
    return allDefaultSkills;
}

-(NSArray *)allCharacterDefaultSkillTemplates
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.movement,
                           self.weaponSkill,
                           self.ballisticSkill,
                           self.strenght,
                           self.toughness,
                           self.initiative,
                           self.leadesShip];
    
    return allCharacterSkills;
}

-(NSArray *)allMeleeCombatSkills
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.ordinary,
                           self.unarmed,
                           self.dagger];
    
    return allCharacterSkills;
}

-(NSArray *)allRangeCombatSkills
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.bow];
    
    return allCharacterSkills;
}

#pragma mark -
#pragma mark basic skills

//movoment
-(SkillTemplate *)movement{
    if (!_movement){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",movementName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:movementName
                                                        withDescription:@"Movement. Basic skill. Shows how far character is able to move from his initial position in one turn."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:1
                                                   withSkillProgression:7
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:4
                                                withParentSkillTemplate:nil
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _movement = skillTemplate;
        
    }
    return _movement;
}

//weaponSkill
-(SkillTemplate *)weaponSkill{
    if (!_weaponSkill){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",weaponSkillName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:weaponSkillName
                                                        withDescription:@"Weapon skill. Basic skill. Covers the basic use, care and maintenance of a variety of melee weapons. Weapon skill is a broad category and governs fighting unarmed to using small weapons like knives or clubs to larger weapons like two-handed swords, great axes or halberds. The ability to parry with an equipped melee weapon is also based on a character’s Weapon Skill."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:1
                                                   withSkillProgression:8
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:nil
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
                                                        withDescription:@"Weapon skill. Basic skill. Covers the basic use, care and maintenance of ranged weapons. This includes thrown weapons like balanced knives and javelins, as well as bows, crossbows, and slings. Also covers the basics of blackpowder weapon care and operation. It is a combination of hand-eye coordination, accuracy, and training with ranged items."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:1
                                                   withSkillProgression:7
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:nil
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _ballisticSkill = skillTemplate;
        
    }
    return _ballisticSkill;
}

//strenght
-(SkillTemplate *)strenght{
    if (!_strenght){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",strenghtName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:strenghtName
                                                        withDescription:@"Strenght. Basic skill."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:1
                                                   withSkillProgression:10
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:nil
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _strenght = skillTemplate;
        
    }
    return _strenght;
}

//toughness
-(SkillTemplate *)toughness{
    if (!_toughness){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",toughnessName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:toughnessName
                                                       withDescription:@"Toughness. Basic skill."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:1
                                                  withSkillProgression:10
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:1
                                               withParentSkillTemplate:nil
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _toughness = skillTemplate;
        
    }
    return _toughness;
}

//initiative
-(SkillTemplate *)initiative{
    if (!_initiative){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",initiativeName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:initiativeName
                                                       withDescription:@"Initiative. Basic skill."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:1
                                                  withSkillProgression:10
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:2
                                               withParentSkillTemplate:nil
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _initiative = skillTemplate;
        
    }
    return _initiative;
}

//leadesShip
-(SkillTemplate *)leadesShip{
    if (!_leadesShip){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",leadesShipName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:leadesShipName
                                                       withDescription:@"Leadership. Basic skill."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:1
                                                  withSkillProgression:3
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:2
                                               withParentSkillTemplate:nil
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _leadesShip = skillTemplate;
        
    }
    return _leadesShip;
}

#pragma mark -
#pragma mark advanced skills
//athletics
-(SkillTemplate *)athletics{
    if (!_athletics){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",athleticsName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:athleticsName
                                                       withDescription:@"Advanced skill. Covers general physical prowess and applying strength and conditioning to a task. This skill is used when trying to perform tasks relying on physical conditioning and athleticism, such as climbing, swimming, or jumping. It reflects a combination of fitness and the training to apply strength in a precise manner. Specialisation options: Climbing, swimming, jumping, rowing, running, lifting."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:8
                                                  withSkillProgression:5
                                               withBasicSkillGrowthGoes:0.6
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:0
                                               withParentSkillTemplate:self.strenght
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _athletics = skillTemplate;
    }
    return _athletics;
}

//stealth
-(SkillTemplate *)stealth{
    if (!_stealth){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",stealthName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:stealthName
                                                       withDescription:@"Advanced skill. The ability to keep from being seen or heard, this skill combines hiding with being quiet. Use this skill to move quietly or remain silent and unobserved. Oftentimes, Stealth is opposed by an opponent’s Observation skill. When trying to remain silent and hidden, performing manoeuvres costs 1 stress in addition to any other costs. Specialisation options: Silent movement: rural, silent movement: wilderness, hide, ambush."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:8
                                                  withSkillProgression:5
                                               withBasicSkillGrowthGoes:0.6
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:0
                                               withParentSkillTemplate:self.initiative
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _stealth = skillTemplate;
    }
    return _stealth;
}

//stealth
-(SkillTemplate *)resilience{
    if (!_resilience){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",resilienceName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:resilienceName
                                                       withDescription:@"Advanced skill. A character’s fitness, vigour, and ability to bounce back from strain and damage. Also covers use of a shield to bear the brunt of an attack and absorb the punishment. Resilience is often used to recover from wounds or fatigue over time, such as after bed rest. Specialisation options: Block, recover fatigue, resist disease, resist poison, resist starvation."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:8
                                                  withSkillProgression:5
                                               withBasicSkillGrowthGoes:0.6
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:0
                                               withParentSkillTemplate:self.toughness
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _resilience = skillTemplate;
    }
    return _resilience;
}

//discipline
-(SkillTemplate *)discipline{
    if (!_discipline){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",disciplineName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:disciplineName
                                                       withDescription:@"Advanced skill. This skill is used to resist the startling effects of surprising events, show resolve in the face of danger, and maintain composure when confronted by supernatural or terrify- ing situations. Discipline is also the ability to maintain one’s state of mind and resist the rigours of stress or attempts to manipulate one’s thoughts or feelings. Specialisation options: Resist charm, resist guile, resist intimidation, resist fear, resist terror, resist torture."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:5
                                                  withSkillProgression:4
                                               withBasicSkillGrowthGoes:0.6
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:0
                                               withParentSkillTemplate:self.leadesShip
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _discipline = skillTemplate;
    }
    return _discipline;
}

//perception
-(SkillTemplate *)perception{
    if (!_perception){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",perceptionName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:perceptionName
                                                       withDescription:@"Advanced skill. Using your senses to perceive your surroundings. Use this skill to notice small details that others might miss and to pick up on subtle clues. It can also be used to spot traps, pitfalls, and other physical dangers. Observation op- poses other characters’ attempts at Stealth, or to otherwise avoid detection. Specialisation options: Eavesdropping, tracking, keen vision, minute details."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:8
                                                  withSkillProgression:5
                                               withBasicSkillGrowthGoes:0.5
                                                          withSkillType:StandartSkillType
                                                 withDefaultStartingLvl:0
                                               withParentSkillTemplate:self.initiative
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _perception = skillTemplate;
    }
    return _perception;
}


#pragma mark melee weapons skills
//unarmed
-(SkillTemplate *)unarmed{
    if (!_unarmed){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",unarmedName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:unarmedName
                                                       withDescription:@"Advanced skill. Better fight bare handed and with battle gantlet."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:4
                                                  withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.6
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:0
                                               withParentSkillTemplate:self.weaponSkill
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _unarmed = skillTemplate;
    }
    return _unarmed;
}

//dagger
-(SkillTemplate *)dagger{
    if (!_dagger){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",daggerName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:daggerName
                                                       withDescription:@"Advanced skill. Better fight with knifes and daggers."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:4
                                                  withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.6
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:1
                                               withParentSkillTemplate:self.weaponSkill
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _dagger = skillTemplate;
    }
    return _dagger;
}

//ordinary
-(SkillTemplate *)ordinary{
    if (!_ordinary){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",ordinaryName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:ordinaryName
                                                       withDescription:@"Advanced skill. Better fight with one-handed axes, swords, clubs, hammers."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:4
                                                  withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.6
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:0
                                               withParentSkillTemplate:self.weaponSkill
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _ordinary = skillTemplate;
    }
    return _ordinary;
}

#pragma mark ranged weapons skills
//bow
-(SkillTemplate *)bow{
    if (!_bow){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",bowName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:bowName
                                                        withDescription:@"Advanced skill. Better use short and long bows."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.6
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


#pragma mark -

-(int)countHpWithStatSet:(StatSet *)statSet
{
    int Hp = 0;
    
    if (statSet)
    {
        Hp += [self hitpointsForSkillWithTemplate:self.movement withSkillLevel:statSet.m];
        Hp += [self hitpointsForSkillWithTemplate:self.weaponSkill withSkillLevel:statSet.ws];
        Hp += [self hitpointsForSkillWithTemplate:self.ballisticSkill withSkillLevel:statSet.bs];
        Hp += [self hitpointsForSkillWithTemplate:self.strenght withSkillLevel:statSet.s];
        Hp += [self hitpointsForSkillWithTemplate:self.toughness withSkillLevel:statSet.t];
        Hp += [self hitpointsForSkillWithTemplate:self.initiative withSkillLevel:statSet.i];
        Hp += 25 * statSet.w;
        Hp += [self hitpointsForSkillWithTemplate:self.leadesShip withSkillLevel:statSet.ld];
    }
    
    return Hp;
}

-(int)hitpointsForSkillWithTemplate:(SkillTemplate *)skillTemplate withSkillLevel:(int)skillLevel
{
    NSInteger Hp = 0;
    
    NSInteger value = skillTemplate.skillStartingLvl;
    if (value < skillLevel){
        if ([skillTemplate.name isEqualToString:self.toughness.name]){
            Hp = 10 * (skillLevel - value);
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
        Hp += character.wounds * 25;
        
        //check if players coreskillset if full
        //he always must have certain skills!!
        NSArray *skills = [character.skillSet allObjects];
        NSMutableArray *skillNames = [NSMutableArray new];
        for (Skill *singleSkill in skills)
        {
            [skillNames addObject:singleSkill.skillTemplate.name];
        }
        
        NSArray *skillsTemplates = [[WarhammerDefaultSkillSetManager sharedInstance] allCharacterDefaultSkillTemplates];
        for (SkillTemplate *template in skillsTemplates)
        {
            Skill *skill = [self skillWithTemplate:template withCharacter:character];
            
            Hp += [self hitpointsForSkillWithTemplate:template withSkillLevel:skill.thisLvl];
        }
    }
    
    return Hp;
}

-(id)skillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character
{
   
    Skill *skill;
    NSString *skillName = skillTemplate.name;
    NSArray *objects = [Skill fetchRequestForObjectName:[SkillTemplate entityNameForSkillTemplate:skillTemplate] withPredicate:[NSPredicate predicateWithFormat:@"(skillTemplate.name == %@) AND (player == %@)",skillName,character] withContext:self.context];
    skill = [objects lastObject];
    
    if (!skill)
    {
        NSLog(@"Warning! Skill with name ""%@"" is missing for character with id %@!",skillTemplate.name,character.characterId);
        skill = [character addNewSkillWithTempate:skillTemplate withContext:self.context];
    }
    
    return skill;
}


-(int)countAttacksForMeleeSkill:(NSSet *)skills
{
    int bonus = 0;
    
    if (skills) {
        NSArray *skillsArray = [skills allObjects];
        int tempWs = 0;
        int tempWsCount = 0;
        for (Skill *skill in skillsArray) {
            int skillLvl = skill.thisLvl + (skill.basicSkill ? skill.basicSkill.thisLvl : 0);
            if (skillLvl > 3) {
                tempWs += skillLvl - 3;
                tempWsCount ++;
            }
        }
        tempWs = tempWs / tempWsCount;
        bonus = tempWs / 2;
    }
        
    return bonus;
}

-(int)countAttacksForRangeSkill:(RangeSkill *)skill;
{
    int bonus = 0;
    
    if (skill) {
        int skillLvl = skill.thisLvl + (skill.basicSkill ? skill.basicSkill.thisLvl : 0);
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
            int skillLvl = skill.thisLvl + (skill.basicSkill ? skill.basicSkill.thisLvl : 0);
            ws += skillLvl;
            if (skillLvl > 3) {
                int tempSkill = skillLvl;
                if (tempSkill % 2) {
                    tempSkill --; //odd
                }
                wsPenalty += tempSkill / 3;
                wsPenaltiesCount ++;
            }
        }
        wsPenalty = wsPenalty / wsPenaltiesCount;
        ws = ws / skillsArray.count;
        ws -= wsPenalty;
    }
    
    return ws;
}

-(int)countBSforRangeSkill:(RangeSkill *)skill
{
    int bs = skill.thisLvl + (skill.basicSkill ? skill.basicSkill.thisLvl : 0);;
    
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
        int skillLvl = skill.thisLvl + (skill.basicSkill ? skill.basicSkill.thisLvl : 0);
        if (skillLvl > 3) {
            int temp = skillLvl - 3;
            bonus = temp / 2;
        }
    }
    
    return bonus;
}

-(StatSet *)statSetFromCharacterSkills:(Character *)character
{
    StatSet *statSet = [StatSet createTemporaryStatSetWithM:[[self skillWithTemplate:self.movement withCharacter:character] thisLvl]
                                                     withWs:[[self skillWithTemplate:self.weaponSkill withCharacter:character] thisLvl]
                                                     withBS:[[self skillWithTemplate:self.ballisticSkill withCharacter:character] thisLvl]
                                                      withS:[[self skillWithTemplate:self.strenght withCharacter:character] thisLvl]
                                                      withT:[[self skillWithTemplate:self.toughness withCharacter:character] thisLvl]
                                                      withI:[[self skillWithTemplate:self.initiative withCharacter:character] thisLvl]
                                                 withAMelee:character.characterCondition.modifierAMelee
                                                 withARange:character.characterCondition.modifierARange
                                                      withW:character.wounds
                                                     withLD:[[self skillWithTemplate:self.leadesShip withCharacter:character] thisLvl]
                                                withContext:self.context];
    
    return statSet;
}

-(void)setCharacterSkills:(Character *)character withStatSet:(StatSet *)statset
{
    Skill *m = [self skillWithTemplate:self.movement withCharacter:character];
    m.thisLvl = statset.m;
    m.thisLvlCurrentProgress = 0;
    
    Skill *ws = [self skillWithTemplate:self.weaponSkill withCharacter:character];
    ws.thisLvl = statset.ws;
    ws.thisLvlCurrentProgress = 0;
    
    Skill *bs = [self skillWithTemplate:self.ballisticSkill withCharacter:character];
    bs.thisLvl = statset.bs;
    bs.thisLvlCurrentProgress = 0;
    
    Skill *s = [self skillWithTemplate:self.strenght withCharacter:character];
    s.thisLvl = statset.s;
    s.thisLvlCurrentProgress = 0;
    
    Skill *t = [self skillWithTemplate:self.toughness withCharacter:character];
    t.thisLvl = statset.ws;
    t.thisLvlCurrentProgress = 0;
    
    Skill *i = [self skillWithTemplate:self.initiative withCharacter:character];
    i.thisLvl = statset.i;
    i.thisLvlCurrentProgress = 0;
    
    Skill *ld = [self skillWithTemplate:self.leadesShip withCharacter:character];
    ld.thisLvl = statset.ws;
    ld.thisLvlCurrentProgress = 0;
    
    character.wounds = statset.w;
    
    character.characterCondition.modifierAMelee = statset.aMelee;
    character.characterCondition.modifierARange = statset.aRange;
}

-(void)checkAllCharacterCoreSkills:(Character *)character
{
    NSArray *coreSkillTemplates = self.allCharacterDefaultSkillTemplates;
    for (SkillTemplate *skillTemplate in coreSkillTemplates) {
        [self skillWithTemplate:skillTemplate withCharacter:character];
    }
}

@end
