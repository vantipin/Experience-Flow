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
#import "SkillManager.h"

@interface StatView()

//direct links on characters core skills
@property (nonatomic) Skill *mSkill;
@property (nonatomic) Skill *wsSkill;
@property (nonatomic) Skill *bsSkill;
@property (nonatomic) Skill *strSkill;
@property (nonatomic) Skill *toSkill;
@property (nonatomic) Skill *agSkill;
@property (nonatomic) Skill *wpSkill;
@property (nonatomic) Skill *intlSkill;
@property (nonatomic) Skill *chaSkill;
@property (nonatomic) SkillManager *skillManager;

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

-(SkillManager *)skillManager
{
    if (!_skillManager){
        _skillManager = [SkillManager sharedInstance];
    }
    
    return _skillManager;
}

-(Skill *)mSkill
{
    _mSkill = [self.skillManager checkedSkillWithTemplate:self.skillManager.movement withCharacter:self.character];
    return _mSkill;
}

-(Skill *)wsSkill
{
    _wsSkill = [self.skillManager checkedSkillWithTemplate:self.skillManager.weaponSkill withCharacter:self.character];
    return _wsSkill;
}

-(Skill *)bsSkill
{
    _bsSkill = [self.skillManager checkedSkillWithTemplate:self.skillManager.ballisticSkill withCharacter:self.character];
    return _bsSkill;
}

-(Skill *)strSkill
{
    _strSkill = [self.skillManager checkedSkillWithTemplate:self.skillManager.strenght withCharacter:self.character];
    return _strSkill;
}

-(Skill *)toSkill
{
    _toSkill = [self.skillManager checkedSkillWithTemplate:self.skillManager.toughness withCharacter:self.character];
    return _toSkill;
}

-(Skill *)agSkill
{
    _agSkill = [self.skillManager checkedSkillWithTemplate:self.skillManager.agility withCharacter:self.character];
    return _agSkill;
}

-(Skill *)wpSkill
{
    _wpSkill = [self.skillManager checkedSkillWithTemplate:self.skillManager.willpower withCharacter:self.character];
    return _wpSkill;
}

-(Skill *)intlSkill
{
    _intlSkill = [self.skillManager checkedSkillWithTemplate:self.skillManager.intelligence withCharacter:self.character];
    return _intlSkill;
}

-(Skill *)chaSkill
{
    _chaSkill = [self.skillManager checkedSkillWithTemplate:self.skillManager.charisma withCharacter:self.character];
    return _chaSkill;
}

-(void)updateStatsFromCharacterObject
{
    //TODO adrenalin and stress points influence
    int hp = [[SkillManager sharedInstance] countHpWithCharacter:self.character];
    self.maxHpLabel.text = [NSString stringWithFormat:@"%d",hp];
    self.currentHpLabel.text = [NSString stringWithFormat:@"%d",hp];
    
    self.m.text = [NSString stringWithFormat:@"%d",self.mSkill.thisLvl];
    self.str.text = [NSString stringWithFormat:@"%d",self.strSkill.thisLvl];
    self.to.text = [NSString stringWithFormat:@"%d",self.toSkill.thisLvl];
    self.ag.text = [NSString stringWithFormat:@"%d",self.agSkill.thisLvl];
    self.wp.text = [NSString stringWithFormat:@"%d",self.wpSkill.thisLvl];
    self.intl.text = [NSString stringWithFormat:@"%d",self.intlSkill.thisLvl];
    self.cha.text = [NSString stringWithFormat:@"%d",self.chaSkill.thisLvl];
    self.w.text = [NSString stringWithFormat:@"%d",self.character.wounds];
    
    int weaponSkill = [[SkillManager sharedInstance] countWSforMeleeSkill:self.character.characterCondition.currentMeleeSkills];
    self.ws.text = [NSString stringWithFormat:@"%d",weaponSkill];
    int ballisticSkill = [[SkillManager sharedInstance] countBSforRangeSkill:[[self.character.characterCondition.currentMeleeSkills allObjects] lastObject]];
    self.bs.text = [NSString stringWithFormat:@"%d",ballisticSkill];
    
    int attackMelee = ([[SkillManager sharedInstance] countAttacksForMeleeSkill:self.character.characterCondition.currentMeleeSkills] + self.character.characterCondition.modifierAMelee);
    self.aMelee.text = [NSString stringWithFormat:@"%d",attackMelee];
    int attacksRange = ([[SkillManager sharedInstance] countAttacksForRangeSkill:self.character.characterCondition.currentRangeSkills] + self.character.characterCondition.modifierARange);
    self.aRange.text = [NSString stringWithFormat:@"%d",attacksRange];
    
    int damageBonusRange = [[SkillManager sharedInstance] countDCBonusForRangeSkill:self.character.characterCondition.currentRangeSkills];
    self.damageRange.text = [NSString stringWithFormat:@"+%d",damageBonusRange];
}

-(void)initFields
{
    if (!self.settable){
        
        self.m.enabled = false;
        self.str.enabled = false;
        self.to.enabled = false;
        self.ag.enabled = false;
        self.w.enabled = false;
        self.wp.enabled = false;
        self.intl.enabled = false;
        self.cha.enabled = false;
        
        self.m.backgroundColor = [UIColor clearColor];
        self.str.backgroundColor = [UIColor clearColor];
        self.to.backgroundColor = [UIColor clearColor];
        self.ag.backgroundColor = [UIColor clearColor];
        self.w.backgroundColor = [UIColor clearColor];
        self.wp.backgroundColor = [UIColor clearColor];
        self.intl.backgroundColor = [UIColor clearColor];
        self.cha.backgroundColor = [UIColor clearColor];
    }
    else{
        self.m.delegate = _executer;
        self.str.delegate = _executer;
        self.to.delegate = _executer;
        self.ag.delegate = _executer;
        self.w.delegate = _executer;
        self.aMelee.delegate = _executer;
        self.aRange.delegate = _executer;
        self.wp.delegate = _executer;
        self.intl.delegate = _executer;
        self.cha.delegate = _executer;
        
        self.m.enabled = true;
        self.str.enabled = true;
        self.to.enabled = true;
        self.ag.enabled = true;
        self.w.enabled = true;
        self.wp.enabled = true;
        self.intl.enabled = true;
        self.cha.enabled = true;
        
        self.m.backgroundColor = [UIColor whiteColor];
        self.str.backgroundColor = [UIColor whiteColor];
        self.to.backgroundColor = [UIColor whiteColor];
        self.ag.backgroundColor = [UIColor whiteColor];
        self.w.backgroundColor = [UIColor whiteColor];
        self.wp.backgroundColor = [UIColor whiteColor];
        self.intl.backgroundColor = [UIColor whiteColor];
        self.cha.backgroundColor = [UIColor whiteColor];
    }
}


-(BOOL)nonEmptyStats
{
    BOOL emptyStats = self.str.text.length == 0 || self.to.text.length == 0 || self.ag.text.length == 0 || self.wp.text.length == 0 || self.intl.text.length == 0 || self.cha.text.length == 0;
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
