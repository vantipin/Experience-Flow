//
//  SkillManager.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 25.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "SkillManager.h"
#import "Character.h"
#import "Skill.h"
#import "SkillTemplate.h"
#import "RangeSkill.h"
#import "MeleeSkill.h"
#import "MagicSkill.h"
#import "PietySkill.h"
#import "CoreSkill.h"
#import "CoreDataViewController.h"


#define movementName @"Mov"
#define weaponSkillName @"WS"
#define ballisticSkillName @"BS"
#define strenghtName @"Str"
#define toughnessName @"To"
#define agilityName @"Ag"
#define wisdomName @"Wis"
#define intelligenceName @"Int"
#define charismaName @"Cha"

#define unarmedName @"Unarmed"
#define ordinaryName @"Ordinary"
#define flailName @"Flail"
#define greatWeaponName @"Great weapon"
#define polearmName @"Polearm"
#define cavalryName @"Cavalry"
#define fencingName @"Fencing"
#define staffName @"Staff"
#define spearName @"Spear"


#define bowName @"Bow"
#define blackpowderName @"Blackpowder"
#define crossbowName @"Crossbow"
#define thrownName @"Thrown"
#define slingName @"Sling"


#define athleticsName @"Athletics"
#define stealthName @"Stealth"
#define resilienceName @"Resilience"
#define disciplineName @"Discipline"
#define perceptionName @"Perception"

static SkillManager *instance = nil;

@interface SkillManager()

@property (nonatomic) NSManagedObjectContext *context;

@end


@implementation SkillManager

+ (SkillManager *)sharedInstance {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        if (!instance) {
            instance = [[SkillManager alloc] init];
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

-(NSArray *)allNoneCoreSkillTemplates
{
    NSArray *allDefaultSkills;
    
    allDefaultSkills = @[self.unarmed,
                         self.ordinary,
                         self.flail,
                         self.greatWeapon,
                         self.polearm,
                         self.cavalry,
                         self.fencing,
                         self.staff,
                         self.spear,
                         
                         self.bow,
                         self.blackpowder,
                         self.crossbow,
                         self.thrown,
                         self.sling,
                         
                         self.athletics,
                         self.stealth,
                         self.resilience,
                         self.discipline,
                         self.perception];
    
    return allDefaultSkills;
}

-(NSArray *)allCoreSkillTemplates
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.movement,
                           self.weaponSkill,
                           self.ballisticSkill,
                           self.strenght,
                           self.toughness,
                           self.agility,
                           self.willpower,
                           self.intelligence,
                           self.charisma];
    
    return allCharacterSkills;
}

-(NSArray *)allMeleeCombatSkills
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.unarmed,
                           self.ordinary,
                           self.flail,
                           self.greatWeapon,
                           self.polearm,
                           self.cavalry,
                           self.fencing,
                           self.staff,
                           self.spear];
    
    return allCharacterSkills;
}

-(NSArray *)allRangeCombatSkills
{
    NSArray *allCharacterSkills;
    
    allCharacterSkills = @[self.bow,
                           self.blackpowder,
                           self.crossbow,
                           self.thrown,
                           self.sling];
    
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
                                                          withSkillType:CoreSkillType
                                                 withDefaultStartingLvl:0
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
                                                          withSkillType:CoreSkillType
                                                 withDefaultStartingLvl:0
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
                                                          withSkillType:CoreSkillType
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
                                                        withDescription:@"Strenght. Basic skill. Defines a character’s brawn and physical strength. Strength is used to determine the outcome of a number of physical skills and tasks, such as climbing, breaking down a door, or hitting hard enough with a melee weapon to inflict damage."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:1
                                                   withSkillProgression:10
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:CoreSkillType
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
                                                       withDescription:@"Toughness. Basic skill. Defines a character’s endurance, constitution, and vigour. Toughness is used to shake off damage, recover from injuries, and resist the effects of toxins or the ravages of disease."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:1
                                                  withSkillProgression:10
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:CoreSkillType
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
-(SkillTemplate *)agility{
    if (!_agility){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",agilityName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:agilityName
                                                       withDescription:@"Agility. Basic skill. Defines a character’s dexterity, coordination, and gross motor control. Agility is used for a variety of physical skills and tasks, such as balance, stealth, picking locks, and the ability to wield ranged weapons with accuracy."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:1
                                                  withSkillProgression:10
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:CoreSkillType
                                                 withDefaultStartingLvl:1
                                               withParentSkillTemplate:nil
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _agility = skillTemplate;
        
    }
    return _agility;
}

//wisdom
-(SkillTemplate *)willpower{
    if (!_willpower){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",wisdomName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:wisdomName
                                                       withDescription:@"Wisdom. Basic skill. Defines a character’s wisdom, discipline, and force of will. Wisdom is used to resist effects such as fear, remain disciplined under trying conditions, and is important to controlling the Winds of Magic or generating favour with a deity."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:1
                                                  withSkillProgression:10
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:CoreSkillType
                                                 withDefaultStartingLvl:1
                                               withParentSkillTemplate:nil
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _willpower = skillTemplate;
        
    }
    return _willpower;
}

//intelligence
-(SkillTemplate *)intelligence{
    if (!_intelligence){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",intelligenceName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:intelligenceName
                                                        withDescription:@"Intelligence. Basic skill. Defines a character’s general intellect, reasoning, and powers of deduction. Intelligence is used for a variety of academic and knowledge-based skills, and is important for arcane spellcasting."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:1
                                                   withSkillProgression:10
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:CoreSkillType
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

//charisma
-(SkillTemplate *)charisma{
    if (!_charisma){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",charismaName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:charismaName
                                                        withDescription:@"Charisma. Basic skill. Defines a character’s general charisma and ability to apply their personality. Charisma is used for a variety of social skills and actions, such as charm and guile, as well as to beseech the gods when invoking divine blessings."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:1
                                                   withSkillProgression:10
                                               withBasicSkillGrowthGoes:0
                                                          withSkillType:CoreSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:nil
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _charisma = skillTemplate;
        
    }
    return _charisma;
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
                                               withParentSkillTemplate:self.willpower
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
                                               withParentSkillTemplate:self.agility
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
                                                       withDescription:@"Advanced skill. Covers the basic use, care and maintenance of bare handed, battle gantlets."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:4
                                                  withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
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

//ordinary
-(SkillTemplate *)ordinary{
    if (!_ordinary){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",ordinaryName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:ordinaryName
                                                       withDescription:@"Advanced skill. Covers the basic use, care and maintenance of one-handed axes, swords, clubs, hammers, daggers."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:4
                                                  withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
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

//flail
-(SkillTemplate *)flail{
    if (!_flail){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",flailName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:flailName
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of flails, morning stars and chain weapons."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.weaponSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _flail = skillTemplate;
    }
    return _flail;
}

//great weapon
-(SkillTemplate *)greatWeapon{
    if (!_greatWeapon){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",greatWeaponName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:greatWeaponName
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of great weapons, two-handed swords, hammers etc."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:self.weaponSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _greatWeapon = skillTemplate;
    }
    return _greatWeapon;
}

//polearm
-(SkillTemplate *)polearm{
    if (!_polearm){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",polearmName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:polearmName
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of halberds."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:self.weaponSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _polearm = skillTemplate;
    }
    return _polearm;
}

//cavalry
-(SkillTemplate *)cavalry{
    if (!_cavalry){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",cavalryName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:cavalryName
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of sabres and lances."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:self.weaponSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _cavalry = skillTemplate;
    }
    return _cavalry;
}

//fencing
-(SkillTemplate *)fencing{
    if (!_fencing){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",fencingName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:fencingName
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of main gauches, rapiers."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:self.weaponSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _fencing = skillTemplate;
    }
    return _fencing;
}

//staff
-(SkillTemplate *)staff{
    if (!_staff){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",staffName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:staffName
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of quarter staffs."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:self.weaponSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _staff = skillTemplate;
    }
    return _staff;
}

//spear
-(SkillTemplate *)spear{
    if (!_spear){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",spearName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:spearName
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of spears."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
                                                          withSkillType:MeleeSkillType
                                                 withDefaultStartingLvl:1
                                                withParentSkillTemplate:self.weaponSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _spear = skillTemplate;
    }
    return _spear;
}

#pragma mark ranged weapons skills
//bow
-(SkillTemplate *)bow{
    if (!_bow){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",bowName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:bowName
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of short and long bows."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
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
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of blunderbusses, handguns, Hochland long rifles, pistols, repeater handguns and repeater pistols."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
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
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of crossbows, crossbow pistols and repeater crossbows."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
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
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of javelins, lasso, nets, spear, throwing axes/hammers/daggers/stars, whips and improvised."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
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

//sling
-(SkillTemplate *)sling{
    if (!_sling){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",slingName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkillTemplateWithUniqName:slingName
                                                        withDescription:@"Advanced skill. Covers the basic use, care and maintenance of slings and staff slings."
                                                          withSkillIcon:nil
                                                     withBasicXpBarrier:4
                                                   withSkillProgression:3
                                               withBasicSkillGrowthGoes:0.7
                                                          withSkillType:RangeSkillType
                                                 withDefaultStartingLvl:0
                                                withParentSkillTemplate:self.ballisticSkill
                                                            withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        _sling = skillTemplate;
    }
    return _sling;
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
        Hp += [self hitpointsForSkillWithTemplate:self.strenght withSkillLevel:statSet.str];
        Hp += [self hitpointsForSkillWithTemplate:self.toughness withSkillLevel:statSet.to];
        Hp += [self hitpointsForSkillWithTemplate:self.agility withSkillLevel:statSet.ag];
        Hp += 25 * statSet.w;
        Hp += [self hitpointsForSkillWithTemplate:self.willpower withSkillLevel:statSet.wp];
        Hp += [self hitpointsForSkillWithTemplate:self.willpower withSkillLevel:statSet.intl];
        Hp += [self hitpointsForSkillWithTemplate:self.willpower withSkillLevel:statSet.cha];
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
        
        NSArray *skillsTemplates = [[SkillManager sharedInstance] allCoreSkillTemplates];
        for (SkillTemplate *template in skillsTemplates)
        {
            Skill *skill = [self checkedSkillWithTemplate:template withCharacter:character];
            
            Hp += [self hitpointsForSkillWithTemplate:template withSkillLevel:skill.thisLvl];
        }
    }
    
    return Hp;
}

-(id)checkedSkillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character
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

    StatSet *statSet = [StatSet createTemporaryStatSetWithM:[[self checkedSkillWithTemplate:self.movement withCharacter:character] thisLvl]
                                                     withWs:[[self checkedSkillWithTemplate:self.weaponSkill withCharacter:character] thisLvl]
                                                     withBS:[[self checkedSkillWithTemplate:self.ballisticSkill withCharacter:character] thisLvl]
                                                    withStr:[[self checkedSkillWithTemplate:self.strenght withCharacter:character] thisLvl]
                                                     withTo:[[self checkedSkillWithTemplate:self.toughness withCharacter:character] thisLvl]
                                                     withAg:[[self checkedSkillWithTemplate:self.agility withCharacter:character] thisLvl]
                                                     withWp:[[self checkedSkillWithTemplate:self.willpower withCharacter:character] thisLvl]
                                                    withInt:[[self checkedSkillWithTemplate:self.intelligence withCharacter:character] thisLvl]
                                                    withCha:[[self checkedSkillWithTemplate:self.charisma withCharacter:character] thisLvl]
                                                 withAMelee:character.characterCondition.modifierAMelee
                                                 withARange:character.characterCondition.modifierARange
                                                      withW:character.wounds
                                                withContext:self.context];
    
    return statSet;
}

-(void)setCharacterSkills:(Character *)character withStatSet:(StatSet *)statset
{
    Skill *m = [self checkedSkillWithTemplate:self.movement withCharacter:character];
    m.thisLvl = statset.m;
    m.thisLvlCurrentProgress = 0;
    
    Skill *ws = [self checkedSkillWithTemplate:self.weaponSkill withCharacter:character];
    ws.thisLvl = statset.ws;
    ws.thisLvlCurrentProgress = 0;
    
    Skill *bs = [self checkedSkillWithTemplate:self.ballisticSkill withCharacter:character];
    bs.thisLvl = statset.bs;
    bs.thisLvlCurrentProgress = 0;
    
    Skill *str = [self checkedSkillWithTemplate:self.strenght withCharacter:character];
    str.thisLvl = statset.str;
    str.thisLvlCurrentProgress = 0;
    
    Skill *to = [self checkedSkillWithTemplate:self.toughness withCharacter:character];
    to.thisLvl = statset.to;
    to.thisLvlCurrentProgress = 0;
    
    Skill *ag = [self checkedSkillWithTemplate:self.agility withCharacter:character];
    ag.thisLvl = statset.ag;
    ag.thisLvlCurrentProgress = 0;
    
    Skill *wp = [self checkedSkillWithTemplate:self.willpower withCharacter:character];
    wp.thisLvl = statset.wp;
    wp.thisLvlCurrentProgress = 0;
    
    Skill *intl = [self checkedSkillWithTemplate:self.intelligence withCharacter:character];
    intl.thisLvl = statset.intl;
    intl.thisLvlCurrentProgress = 0;
    
    Skill *cha = [self checkedSkillWithTemplate:self.charisma withCharacter:character];
    cha.thisLvl = statset.cha;
    cha.thisLvlCurrentProgress = 0;
    
    character.wounds = statset.w;
    
    character.characterCondition.modifierAMelee = statset.aMelee;
    character.characterCondition.modifierARange = statset.aRange;
}

-(void)checkAllCharacterCoreSkills:(Character *)character
{
    NSArray *coreSkillTemplates = self.allCoreSkillTemplates;
    for (SkillTemplate *skillTemplate in coreSkillTemplates) {
        [self checkedSkillWithTemplate:skillTemplate withCharacter:character];
    }
}

@end
