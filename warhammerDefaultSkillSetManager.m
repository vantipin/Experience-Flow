//
//  warhammerCoreSkillSetManager.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 25.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "warhammerDefaultSkillSetManager.h"

@implementation warhammerDefaultSkillSetManager

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


-(NSArray *)allDefault

#pragma mark -
#pragma mark basic skills

//movoment
-(NSDictionary *)movement{
    if (!_movement){
        _movement = @{@"name": @"M",
                      @"skillDescription": @"Movement. Basic skill. Shows how far character is able to move from his initial position in one turn.",
                      @"thisBasicBarrier": @"0",
                      @"thisSkillProgression": @"7"};
        }
    return _movement;
}

//weaponSkill
-(NSDictionary *)weaponSkill{
    if (!_weaponSkill){
        _weaponSkill = @{@"name": @"WS",
                         @"skillDescription": @"Weapon skill. Basic skill. Covers the basic use, care and maintenance of a variety of melee weapons. Weapon skill is a broad category and governs fighting unarmed to using small weapons like knives or clubs to larger weapons like two-handed swords, great axes or halberds. The ability to parry with an equipped melee weapon is also based on a character’s Weapon Skill.",
                         @"thisBasicBarrier": @"0",
                         @"thisSkillProgression": @"8"};
    }
    return _weaponSkill;
}

//ballisticSkill
-(NSDictionary *)ballisticSkill{
    if (!_ballisticSkill){
        _ballisticSkill = @{@"name": @"BS",
                            @"skillDescription": @"Weapon skill. Basic skill. Covers the basic use, care and maintenance of ranged weapons. This includes thrown weapons like balanced knives and javelins, as well as bows, crossbows, and slings. Also covers the basics of blackpowder weapon care and operation. It is a combination of hand-eye coordination, accuracy, and training with ranged items.",
                            @"thisBasicBarrier": @"0",
                            @"thisSkillProgression": @"7"};
    }
    return _ballisticSkill;
}

//strenght
-(NSDictionary *)strenght{
    if (!_strenght){
        _strenght = @{@"name": @"S",
                      @"skillDescription": @"Strenght. Basic skill.",
                      @"thisBasicBarrier": @"0",
                      @"thisSkillProgression": @"10"};
    }
    return _strenght;
}

//toughness
-(NSDictionary *)toughness{
    if (!_toughness){
        _toughness = @{@"name": @"T",
                       @"skillDescription": @"Toughness. Basic skill.",
                       @"thisBasicBarrier": @"0",
                       @"thisSkillProgression": @"10"};
    }
    return _toughness;
}

//initiative
-(NSDictionary *)initiative{
    if (!_initiative){
        _initiative = @{@"name": @"I",
                        @"skillDescription": @"Initiative. Basic skill.",
                        @"thisBasicBarrier": @"0",
                        @"thisSkillProgression": @"7"};
    }
    return _initiative;
}

//leadesShip
-(NSDictionary *)leadesShip{
    if (!_leadesShip){
        _leadesShip = @{@"name": @"Ld",
                        @"skillDescription": @"Leadership. Basic skill.",
                        @"thisBasicBarrier": @"0",
                        @"thisSkillProgression": @"2"};
    }
    return _leadesShip;
}

#pragma mark -
#pragma mark advanced skills
//athletics
-(NSDictionary *)athletics{
    if (!_athletics){
        _athletics = @{@"name": @"Athletics",
                       @"skillDescription": @"Advanced skill. Covers general physical prowess and applying strength and conditioning to a task. This skill is used when trying to perform tasks relying on physical conditioning and athleticism, such as climbing, swimming, or jumping. It reflects a combination of fitness and the training to apply strength in a precise manner. Specialisation options: Climbing, swimming, jumping, rowing, running, lifting.",
                       @"thisBasicBarrier": @"5",
                       @"thisSkillProgression": @"5",
                       @"basicSkillGrowthGoes": @"2",
                       @"basicSkill": self.strenght};
    }
    return _athletics;
}

//stealth
-(NSDictionary *)stealth{
    if (!_stealth){
        _stealth = @{@"name": @"Stealth",
                     @"skillDescription": @"Advanced skill. The ability to keep from being seen or heard, this skill combines hiding with being quiet. Use this skill to move quietly or remain silent and unobserved. Oftentimes, Stealth is opposed by an opponent’s Observation skill. When trying to remain silent and hidden, performing manoeuvres costs 1 stress in addition to any other costs. Specialisation options: Silent movement: rural, silent movement: wilderness, hide, ambush.",
                     @"thisBasicBarrier": @"5",
                     @"thisSkillProgression": @"3",
                     @"basicSkillGrowthGoes": @"3",
                     @"basicSkill": self.initiative};
    }
    return _stealth;
}

//stealth
-(NSDictionary *)resilience{
    if (!_resilience){
        _resilience = @{@"name": @"Resilience",
                        @"skillDescription": @"Advanced skill. A character’s fitness, vigour, and ability to bounce back from strain and damage. Also covers use of a shield to bear the brunt of an attack and absorb the punishment. Resilience is often used to recover from wounds or fatigue over time, such as after bed rest. Specialisation options: Block, recover fatigue, resist disease, resist poison, resist starvation.",
                        @"thisBasicBarrier": @"5",
                        @"thisSkillProgression": @"5",
                        @"basicSkillGrowthGoes": @"2",
                        @"basicSkill": self.toughness};
    }
    return _resilience;
}

//discipline
-(NSDictionary *)discipline{
    if (!_discipline){
        _discipline = @{@"name": @"Discipline",
                        @"skillDescription": @"Advanced skill. This skill is used to resist the startling effects of surprising events, show resolve in the face of danger, and maintain composure when confronted by supernatural or terrify- ing situations. Discipline is also the ability to maintain one’s state of mind and resist the rigours of stress or attempts to manipulate one’s thoughts or feelings. Specialisation options: Resist charm, resist guile, resist intimidation, resist fear, resist terror, resist torture.",
                        @"thisBasicBarrier": @"4",
                        @"thisSkillProgression": @"3",
                        @"basicSkillGrowthGoes": @"2",
                        @"basicSkill": self.leadesShip};
    }
    return _discipline;
}

//perception
-(NSDictionary *)perception{
    if (!_perception){
        _perception = @{@"name": @"Perception",
                        @"skillDescription": @"Advanced skill. Using your senses to perceive your surroundings. Use this skill to notice small details that others might miss and to pick up on subtle clues. It can also be used to spot traps, pitfalls, and other physical dangers. Observation op- poses other characters’ attempts at Stealth, or to otherwise avoid detection. Specialisation options: Eavesdropping, tracking, keen vision, minute details.",
                        @"thisBasicBarrier": @"4",
                        @"thisSkillProgression": @"4",
                        @"basicSkillGrowthGoes": @"5",
                        @"basicSkill": self.initiative};
    }
    return _perception;
}


#pragma mark melee weapons skills
//unarmed
-(NSDictionary *)unarmed{
    if (!_unarmed){
        _unarmed = @{@"name": @"Unarmed",
                     @"skillDescription": @"Advanced skill. Better fight bare handed and with battle gantlet.",
                     @"thisBasicBarrier": @"4",
                     @"thisSkillProgression": @"3",
                     @"basicSkillGrowthGoes": @"3",
                     @"basicSkill": self.weaponSkill};
    }
    return _unarmed;
}

//dagger
-(NSDictionary *)dagger{
    if (!_dagger){
        _dagger = @{@"name": @"Dagger",
                    @"skillDescription": @"Advanced skill. Better fight with knifes and daggers.",
                    @"thisBasicBarrier": @"4",
                    @"thisSkillProgression": @"3",
                    @"basicSkillGrowthGoes": @"3",
                    @"basicSkill": self.weaponSkill};
    }
    return _dagger;
}

//ordinary
-(NSDictionary *)ordinary{
    if (!_ordinary){
        _ordinary = @{@"name": @"Ordinary weapon",
                      @"skillDescription": @"Advanced skill. Better fight with hand weapon.",
                      @"thisBasicBarrier": @"5",
                      @"thisSkillProgression": @"4",
                      @"basicSkillGrowthGoes": @"2",
                      @"basicSkill": self.weaponSkill};
    }
    return _ordinary;
}

#pragma mark ranged weapons skills


#pragma mark -
#pragma mark validate input
-(BOOL)checkSkillDictionary:(NSDictionary *)skillInDictionary
{
    BOOL isValid = false;
    
    NSString *nameNotNil = [skillInDictionary valueForKey:@"name"];
    NSString *basicBarrierNotNil = [skillInDictionary valueForKey:@"thisBasicBarrier"];
    NSString *skillProgressionNotNil = [skillInDictionary valueForKey:@"thisSkillProgression"];
    
    if  (nameNotNil&&basicBarrierNotNil&&skillProgressionNotNil)
    {
        isValid = true;
    }
    
    return isValid;
}


#pragma mark -

+(int)countHpWithStatSet:(StatSet *)statSet
{
    int Hp = 0;
    
    int normalM = 4;
    int normalWS = 2;
    int normalBS = 1;
    int normalS = 2;
    int normalT = 2;
    int normalI = 4;
    //int normalA = 1; A don't give Hp; I'v made my mind!
    int normalW = 0;
    int normalLd = 6;
    
    if (statSet)
    {
        Hp += (normalM<statSet.m)?(statSet.m-normalM)*1:0;
        Hp += (normalWS<statSet.ws)?(statSet.ws-normalWS)*1:0;
        Hp += (normalBS<statSet.bs)?(statSet.bs-normalBS)*1:0;
        Hp += (normalS<statSet.s)?(statSet.s-normalS)*1:0;
        Hp += (normalT<statSet.t)?(statSet.t-normalT)*10:0;
        Hp += (normalI<statSet.i)?(statSet.i-normalI)*1:0;
        Hp += (normalW<statSet.w)?(statSet.w-normalW)*25:0;
        Hp += (normalLd<statSet.ld)?(statSet.ld-normalLd)*1:0;
    }
    
    return Hp;
}


-(NSArray *)getStandartSkillSetExcludingCharacterSkills:(Character *)character
{
    //NSMutableArray *excludingSkills;
    //NSMutableArray *
    return nil;
}
@end
