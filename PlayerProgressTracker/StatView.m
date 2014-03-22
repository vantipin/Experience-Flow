//
//  StatView.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 03.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "StatView.h"
#import "Character.h"
#import "Skill.h"
#import "SkillTemplate.h"
#import "WarhammerDefaultSkillSetManager.h"

@interface StatView()

//direct links on characters core skills
@property (nonatomic) Skill *mSkill;
@property (nonatomic) Skill *wsSkill;
@property (nonatomic) Skill *bsSkill;
@property (nonatomic) Skill *sSkill;
@property (nonatomic) Skill *tSkill;
@property (nonatomic) Skill *iSkill;
@property (nonatomic) Skill *ldSkill;
@property (nonatomic) WarhammerDefaultSkillSetManager *skillManager;

@end

@implementation StatView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"StatView" owner:nil options:nil];
        self = [views firstObject];
        // Initialization code
    }
    return self;
}

-(void)setCharacter:(Character *)character
{
    if (character){
        _character = character;
        [self updateStatsFromCharacterObject];
    }
}

-(WarhammerDefaultSkillSetManager *)skillManager
{
    if (!_skillManager){
        _skillManager = [WarhammerDefaultSkillSetManager sharedInstance];
    }
    
    return _skillManager;
}

-(Skill *)mSkill
{
    _mSkill = [self.skillManager skillWithTemplate:self.skillManager.movement withCharacter:self.character];
    return _mSkill;
}

-(Skill *)wsSkill
{
    _wsSkill = [self.skillManager skillWithTemplate:self.skillManager.weaponSkill withCharacter:self.character];
    return _wsSkill;
}

-(Skill *)bsSkill
{
    _bsSkill = [self.skillManager skillWithTemplate:self.skillManager.ballisticSkill withCharacter:self.character];
    return _bsSkill;
}

-(Skill *)sSkill
{
    _sSkill = [self.skillManager skillWithTemplate:self.skillManager.strenght withCharacter:self.character];
    return _sSkill;
}

-(Skill *)tSkill
{
    _tSkill = [self.skillManager skillWithTemplate:self.skillManager.toughness withCharacter:self.character];
    return _tSkill;
}

-(Skill *)iSkill
{
    _iSkill = [self.skillManager skillWithTemplate:self.skillManager.initiative withCharacter:self.character];
    return _iSkill;
}

-(Skill *)ldSkill
{
    _ldSkill = [self.skillManager skillWithTemplate:self.skillManager.toughness withCharacter:self.character];
    return _ldSkill;
}

-(void)updateStatsFromCharacterObject
{
    //TODO adrenalin and stress points influence
    int hp = [[WarhammerDefaultSkillSetManager sharedInstance] countHpWithCharacter:self.character];
    self.maxHpLabel.text = [NSString stringWithFormat:@"%d",hp];
    self.currentHpLabel.text = [NSString stringWithFormat:@"%d",hp];
    
    self.m.text = [NSString stringWithFormat:@"%d",self.mSkill.thisLvl];
    self.s.text = [NSString stringWithFormat:@"%d",self.sSkill.thisLvl];
    self.t.text = [NSString stringWithFormat:@"%d",self.tSkill.thisLvl];
    self.i.text = [NSString stringWithFormat:@"%d",self.iSkill.thisLvl];
    self.ld.text = [NSString stringWithFormat:@"%d",self.ldSkill.thisLvl];
    self.w.text = [NSString stringWithFormat:@"%d",self.character.wounds];
    
    int weaponSkill = [[WarhammerDefaultSkillSetManager sharedInstance] countWSforMeleeSkill:self.character.characterCondition.currentMeleeSkills];
    self.ws.text = [NSString stringWithFormat:@"%d",weaponSkill];
    int ballisticSkill = [[WarhammerDefaultSkillSetManager sharedInstance] countBSforRangeSkill:[[self.character.characterCondition.currentMeleeSkills allObjects] lastObject]];
    self.bs.text = [NSString stringWithFormat:@"%d",ballisticSkill];
    
    int attackMelee = ([[WarhammerDefaultSkillSetManager sharedInstance] countAttacksForMeleeSkill:self.character.characterCondition.currentMeleeSkills] + self.character.characterCondition.modifierAMelee);
    self.aMelee.text = [NSString stringWithFormat:@"%d",attackMelee];
    int attacksRange = ([[WarhammerDefaultSkillSetManager sharedInstance] countAttacksForRangeSkill:self.character.characterCondition.currentRangeSkills] + self.character.characterCondition.modifierARange);
    self.aRange.text = [NSString stringWithFormat:@"%d",attacksRange];
    
    int damageBonusRange = [[WarhammerDefaultSkillSetManager sharedInstance] countDCBonusForRangeSkill:self.character.characterCondition.currentRangeSkills];
    self.damageRange.text = [NSString stringWithFormat:@"+%d",damageBonusRange];
}

-(void)initFields
{
    if (!self.settable){
        
        self.m.enabled = false;
        self.s.enabled = false;
        self.t.enabled = false;
        self.i.enabled = false;
        self.w.enabled = false;
        self.ld.enabled = false;
        
        self.m.backgroundColor = [UIColor clearColor];
        self.s.backgroundColor = [UIColor clearColor];
        self.t.backgroundColor = [UIColor clearColor];
        self.i.backgroundColor = [UIColor clearColor];
        self.w.backgroundColor = [UIColor clearColor];
        self.ld.backgroundColor = [UIColor clearColor];
    }
    else{
        self.m.delegate = _executer;
        self.s.delegate = _executer;
        self.t.delegate = _executer;
        self.i.delegate = _executer;
        self.w.delegate = _executer;
        self.aMelee.delegate = _executer;
        self.aRange.delegate = _executer;
        self.ld.delegate = _executer;
        
        self.m.enabled = true;
        self.s.enabled = true;
        self.t.enabled = true;
        self.i.enabled = true;
        self.w.enabled = true;
        self.ld.enabled = true;
        
        self.m.backgroundColor = [UIColor whiteColor];
        self.s.backgroundColor = [UIColor whiteColor];
        self.t.backgroundColor = [UIColor whiteColor];
        self.i.backgroundColor = [UIColor whiteColor];
        self.w.backgroundColor = [UIColor whiteColor];
        self.ld.backgroundColor = [UIColor whiteColor];
    }
}


-(BOOL)nonEmptyStats
{
    BOOL emptyStats = self.m.text.length == 0 || self.ws.text.length == 0 || self.s.text.length == 0 || self.t.text.length == 0 || self.i.text.length == 0 || self.w.text.length == 0 || self.ld.text.length == 0;
    if (emptyStats){
        return false;
    }
    
    return true;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
