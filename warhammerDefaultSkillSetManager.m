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

@synthesize attacks = _attacks;

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
                         self.attacks,
                         
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


#pragma mark -
#pragma mark basic skills

//movoment
-(SkillTemplate *)movement{
    if (!_movement){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",movementName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:movementName
                                                       withDescription:@"Movement. Basic skill. Shows how far character is able to move from his initial position in one turn."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:0
                                                  withSkillProgression:7
                                              withBasicSkillGrowthGoes:0
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:weaponSkillName
                                                       withDescription:@"Weapon skill. Basic skill. Covers the basic use, care and maintenance of a variety of melee weapons. Weapon skill is a broad category and governs fighting unarmed to using small weapons like knives or clubs to larger weapons like two-handed swords, great axes or halberds. The ability to parry with an equipped melee weapon is also based on a character’s Weapon Skill."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:0
                                                  withSkillProgression:8
                                              withBasicSkillGrowthGoes:0
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:ballisticSkillName
                                                       withDescription:@"Weapon skill. Basic skill. Covers the basic use, care and maintenance of ranged weapons. This includes thrown weapons like balanced knives and javelins, as well as bows, crossbows, and slings. Also covers the basics of blackpowder weapon care and operation. It is a combination of hand-eye coordination, accuracy, and training with ranged items."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:0
                                                  withSkillProgression:7
                                              withBasicSkillGrowthGoes:0
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:strenghtName
                                                       withDescription:@"Strenght. Basic skill."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:0
                                                  withSkillProgression:10
                                              withBasicSkillGrowthGoes:0
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:toughnessName
                                                       withDescription:@"Toughness. Basic skill."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:0
                                                  withSkillProgression:10
                                              withBasicSkillGrowthGoes:0
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:initiativeName
                                                       withDescription:@"Initiative. Basic skill."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:0
                                                  withSkillProgression:10
                                              withBasicSkillGrowthGoes:0
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:leadesShipName
                                                       withDescription:@"Leadership. Basic skill."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:0
                                                  withSkillProgression:3
                                              withBasicSkillGrowthGoes:0
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

-(SkillTemplate *)attacks
{
    if (!_attacks){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",attacksName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:attacksName
                                                       withDescription:@"Attacks. Basic skill."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:0
                                                  withSkillProgression:50
                                              withBasicSkillGrowthGoes:0
                                               withParentSkillTemplate:nil
                                                           withContext:self.context];
        }
        else{
            skillTemplate = [existingSkillsTemplateWithThisName lastObject];
        }
        
        _attacks = skillTemplate;
    }
    return _attacks;
}

#pragma mark -
#pragma mark advanced skills
//athletics
-(SkillTemplate *)athletics{
    if (!_athletics){
        SkillTemplate *skillTemplate;
        NSArray *existingSkillsTemplateWithThisName = [SkillTemplate fetchRequestForObjectName:@"SkillTemplate" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",athleticsName] withContext:self.context];
        if (!existingSkillsTemplateWithThisName || existingSkillsTemplateWithThisName.count==0){
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:athleticsName
                                                       withDescription:@"Advanced skill. Covers general physical prowess and applying strength and conditioning to a task. This skill is used when trying to perform tasks relying on physical conditioning and athleticism, such as climbing, swimming, or jumping. It reflects a combination of fitness and the training to apply strength in a precise manner. Specialisation options: Climbing, swimming, jumping, rowing, running, lifting."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:8
                                                  withSkillProgression:5
                                              withBasicSkillGrowthGoes:2
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:stealthName
                                                       withDescription:@"Advanced skill. The ability to keep from being seen or heard, this skill combines hiding with being quiet. Use this skill to move quietly or remain silent and unobserved. Oftentimes, Stealth is opposed by an opponent’s Observation skill. When trying to remain silent and hidden, performing manoeuvres costs 1 stress in addition to any other costs. Specialisation options: Silent movement: rural, silent movement: wilderness, hide, ambush."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:8
                                                  withSkillProgression:5
                                              withBasicSkillGrowthGoes:2
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:resilienceName
                                                       withDescription:@"Advanced skill. A character’s fitness, vigour, and ability to bounce back from strain and damage. Also covers use of a shield to bear the brunt of an attack and absorb the punishment. Resilience is often used to recover from wounds or fatigue over time, such as after bed rest. Specialisation options: Block, recover fatigue, resist disease, resist poison, resist starvation."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:8
                                                  withSkillProgression:5
                                              withBasicSkillGrowthGoes:2
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:disciplineName
                                                       withDescription:@"Advanced skill. This skill is used to resist the startling effects of surprising events, show resolve in the face of danger, and maintain composure when confronted by supernatural or terrify- ing situations. Discipline is also the ability to maintain one’s state of mind and resist the rigours of stress or attempts to manipulate one’s thoughts or feelings. Specialisation options: Resist charm, resist guile, resist intimidation, resist fear, resist terror, resist torture."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:5
                                                  withSkillProgression:4
                                              withBasicSkillGrowthGoes:2
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:perceptionName
                                                       withDescription:@"Advanced skill. Using your senses to perceive your surroundings. Use this skill to notice small details that others might miss and to pick up on subtle clues. It can also be used to spot traps, pitfalls, and other physical dangers. Observation op- poses other characters’ attempts at Stealth, or to otherwise avoid detection. Specialisation options: Eavesdropping, tracking, keen vision, minute details."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:8
                                                  withSkillProgression:5
                                              withBasicSkillGrowthGoes:2
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:unarmedName
                                                       withDescription:@"Advanced skill. Better fight bare handed and with battle gantlet."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:4
                                                  withSkillProgression:3
                                              withBasicSkillGrowthGoes:3
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:daggerName
                                                       withDescription:@"Advanced skill. Better fight with knifes and daggers."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:4
                                                  withSkillProgression:3
                                              withBasicSkillGrowthGoes:3
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
            skillTemplate = [SkillTemplate newSkilTemplateWithUniqName:ordinaryName
                                                       withDescription:@"Advanced skill. Better fight with one-handed axes, swords, clubs, hammers."
                                                         withSkillIcon:nil
                                                    withBasicXpBarrier:4
                                                  withSkillProgression:3
                                              withBasicSkillGrowthGoes:3
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


#pragma mark -
#pragma mark validate input


#pragma mark -

-(int)countHpWithStatSet:(StatSet *)statSet
{
    int Hp = 0;
    
    if (statSet)
    {
        Hp += [self hitpointsForSkillWithName:[self.movement valueForKey:@"name"] withSkillLevel:statSet.m];
        Hp += [self hitpointsForSkillWithName:[self.weaponSkill valueForKey:@"name"] withSkillLevel:statSet.ws];
        Hp += [self hitpointsForSkillWithName:[self.ballisticSkill valueForKey:@"name"] withSkillLevel:statSet.bs];
        Hp += [self hitpointsForSkillWithName:[self.strenght valueForKey:@"name"] withSkillLevel:statSet.s];
        Hp += [self hitpointsForSkillWithName:[self.toughness valueForKey:@"name"] withSkillLevel:statSet.t];
        Hp += [self hitpointsForSkillWithName:[self.initiative valueForKey:@"name"] withSkillLevel:statSet.i];
        Hp += 25 * statSet.w;
        Hp += [self hitpointsForSkillWithName:[self.leadesShip valueForKey:@"name"] withSkillLevel:statSet.ld];
    }
    
    return Hp;
}

-(int)hitpointsForSkillWithName:(NSString *)name withSkillLevel:(int)skillLevel
{
    int Hp = 0;
    
    NSDictionary *dict = @{self.movement.name:@4,
                           self.weaponSkill.name:@2,
                           self.ballisticSkill.name:@1,
                           self.strenght.name:@2,
                           self.toughness.name:@2,
                           self.initiative.name:@3,
                           self.leadesShip.name:@6};
    
    int value = [[dict valueForKey:name] integerValue];
    if (value && (value < skillLevel)){
        if ([name isEqualToString:[self.toughness valueForKey:@"name"]]){
            Hp = 10 * (skillLevel - value);
        }
        else{
            Hp = 1 * (skillLevel - value);
        }
        
    }
    
    return Hp;
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
            Skill *skill = [self checkCoreSkillWithTemplate:template withCharacter:character];
            
            Hp += [self hitpointsForSkillWithName:template.name withSkillLevel:skill.thisLvl];
        }
    }
    
    return Hp;
}

-(Skill *)checkCoreSkillWithTemplate:(SkillTemplate *)skillTemplate withCharacter:(Character *)character
{
   
    Skill *skill;
    NSString *skillName = skillTemplate.name;
    NSArray *objects = [Skill fetchRequestForObjectName:@"Skill" withPredicate:[NSPredicate predicateWithFormat:@"(skillTemplate.name == %@) AND (player == %@)",skillName,character] withContext:self.context];
    skill = [objects lastObject];
    
    if (!skill)
    {
        NSLog(@"Warning! Core skill with name ""%@"" missed!",character.name);
        SkillTemplate *coreSkillTemplate = skillTemplate;
        Skill *coreSkill = [Skill newSkillWithTemplate:coreSkillTemplate withSkillLvL:0 withBasicSkill:nil withCurrentXpPoints:0 withContextToHoldItUntilContextSaved:self.context];
        [character addSkillSetObject:coreSkill];
        skill = coreSkill;
    }
    
    return skill;
}

@end
