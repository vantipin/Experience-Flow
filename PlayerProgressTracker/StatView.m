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
#import "SkillSet.h"
#import "CoreDataViewController.h"
#import "CharacterConditionAttributes.h"
#import "DefaultSkillTemplates.h"

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
    if (character) {
        _character = character;
        [self setViewFromSkillSet];
    }
}

-(Skill *)mSkill
{
    _mSkill = [[SkillManager sharedInstance] checkedSkillWithTemplate:[DefaultSkillTemplates sharedInstance].movement withCharacter:self.character];
    return _mSkill;
}

-(Skill *)wsSkill
{
    _wsSkill = [[SkillManager sharedInstance] checkedSkillWithTemplate:[DefaultSkillTemplates sharedInstance].weaponSkill withCharacter:self.character];
    return _wsSkill;
}

-(Skill *)bsSkill
{
    _bsSkill = [[SkillManager sharedInstance] checkedSkillWithTemplate:[DefaultSkillTemplates sharedInstance].ballisticSkill withCharacter:self.character];
    return _bsSkill;
}

-(Skill *)strSkill
{
    _strSkill = [[SkillManager sharedInstance] checkedSkillWithTemplate:[DefaultSkillTemplates sharedInstance].strenght withCharacter:self.character];
    return _strSkill;
}

-(Skill *)toSkill
{
    _toSkill = [[SkillManager sharedInstance] checkedSkillWithTemplate:[DefaultSkillTemplates sharedInstance].toughness withCharacter:self.character];
    return _toSkill;
}

-(Skill *)agSkill
{
    _agSkill = [[SkillManager sharedInstance] checkedSkillWithTemplate:[DefaultSkillTemplates sharedInstance].agility withCharacter:self.character];
    return _agSkill;
}

-(Skill *)wpSkill
{
    _wpSkill = [[SkillManager sharedInstance] checkedSkillWithTemplate:[DefaultSkillTemplates sharedInstance].willpower withCharacter:self.character];
    return _wpSkill;
}

-(Skill *)intlSkill
{
    _intlSkill = [[SkillManager sharedInstance] checkedSkillWithTemplate:[DefaultSkillTemplates sharedInstance].intelligence withCharacter:self.character];
    return _intlSkill;
}

-(Skill *)chaSkill
{
    _chaSkill = [[SkillManager sharedInstance] checkedSkillWithTemplate:[DefaultSkillTemplates sharedInstance].charisma withCharacter:self.character];
    return _chaSkill;
}

-(void)setSkillSetFromView
{
    self.mSkill.thisLvl = self.m.text.integerValue;
    self.character.skillSet.wounds = self.bonusWounds.text.integerValue;
    self.character.skillSet.modifierAMelee = self.bonusAMelee.text.integerValue;
    self.character.skillSet.modifierARange = self.bonusARange.text.integerValue;
    self.character.skillSet.modifierArmorSave = self.ac.text.intValue;
    
    self.strSkill.thisLvl = self.str.text.integerValue;
    self.toSkill.thisLvl = self.to.text.integerValue;
    self.agSkill.thisLvl = self.ag.text.integerValue;
    self.wpSkill.thisLvl = self.wp.text.integerValue;
    self.intlSkill.thisLvl = self.intl.text.integerValue;
    self.chaSkill.thisLvl = self.cha.text.integerValue;

    [self resetUneditableStats];
}

-(void)setViewFromSkillSet
{
    self.m.text = [NSString stringWithFormat:@"%d",self.mSkill.thisLvl];
    self.str.text = [NSString stringWithFormat:@"%d",self.strSkill.thisLvl];
    self.to.text = [NSString stringWithFormat:@"%d",self.toSkill.thisLvl];
    self.ag.text = [NSString stringWithFormat:@"%d",self.agSkill.thisLvl];
    self.wp.text = [NSString stringWithFormat:@"%d",self.wpSkill.thisLvl];
    self.intl.text = [NSString stringWithFormat:@"%d",self.intlSkill.thisLvl];
    self.cha.text = [NSString stringWithFormat:@"%d",self.chaSkill.thisLvl];
    self.bonusWounds.text = [NSString stringWithFormat:@"%d",self.character.skillSet.wounds];
    self.bonusAMelee.text = [NSString stringWithFormat:@"%d",self.character.skillSet.modifierAMelee];
    self.bonusARange.text = [NSString stringWithFormat:@"%d",self.character.skillSet.modifierARange];
    self.ac.text = [NSString stringWithFormat:@"%d",self.character.skillSet.modifierArmorSave];
    
    [self resetUneditableStats];
}

-(void)resetUneditableStats
{
    //TODO adrenalin and stress points influence
    
    int hp = [[SkillManager sharedInstance] countHpWithCharacter:self.character];
    self.maxHpLabel.text = [NSString stringWithFormat:@"%d",hp];
    self.currentHpLabel.text = [NSString stringWithFormat:@"%d",hp];
    
    int weaponSkill = [[SkillManager sharedInstance] countWSforMeleeSkill:self.character.characterCondition.currentMeleeSkills];
    int ballisticSkill = [[SkillManager sharedInstance] countBSforRangeSkill:self.character.characterCondition.currentRangeSkills];
    int attackMelee = ([[SkillManager sharedInstance] countAttacksForMeleeSkill:self.character.characterCondition.currentMeleeSkills] + self.character.skillSet.modifierAMelee);
    int attacksRange = ([[SkillManager sharedInstance] countAttacksForRangeSkill:self.character.characterCondition.currentRangeSkills] + self.character.skillSet.modifierARange);
    int damageBonusRange = [[SkillManager sharedInstance] countDCBonusForRangeSkill:self.character.characterCondition.currentRangeSkills];
    
    
    self.ws.text = [NSString stringWithFormat:@"%d",weaponSkill];
    self.bs.text = [NSString stringWithFormat:@"%d",ballisticSkill];
    
    self.aMelee.text = [NSString stringWithFormat:@"%d",attackMelee];
    self.aRange.text = [NSString stringWithFormat:@"%d",attacksRange];
    
    self.damageRange.text = [NSString stringWithFormat:@"+%d",damageBonusRange];
}

-(void)initFields
{
    if (!self.settable){
        
        self.m.enabled = false;
        self.str.enabled = false;
        self.to.enabled = false;
        self.ag.enabled = false;
        self.wp.enabled = false;
        self.intl.enabled = false;
        self.cha.enabled = false;
        self.bonusWounds.enabled = false;
        self.bonusAMelee.enabled = false;
        self.bonusARange.enabled = false;
        
        self.m.backgroundColor = [UIColor clearColor];
        self.str.backgroundColor = [UIColor clearColor];
        self.to.backgroundColor = [UIColor clearColor];
        self.ag.backgroundColor = [UIColor clearColor];
        self.wp.backgroundColor = [UIColor clearColor];
        self.intl.backgroundColor = [UIColor clearColor];
        self.cha.backgroundColor = [UIColor clearColor];
        self.bonusWounds.backgroundColor = [UIColor clearColor];
        self.bonusAMelee.backgroundColor = [UIColor clearColor];
        self.bonusARange.backgroundColor = [UIColor clearColor];
        
        self.bonusView.alpha = 0;
    }
    else{
        self.m.delegate = _executer;
        self.str.delegate = _executer;
        self.to.delegate = _executer;
        self.ag.delegate = _executer;
        self.wp.delegate = _executer;
        self.intl.delegate = _executer;
        self.cha.delegate = _executer;
        self.bonusWounds.delegate = _executer;
        self.bonusAMelee.delegate = _executer;
        self.bonusARange.delegate = _executer;
        self.ac.delegate = _executer;
        
        
        self.m.enabled = true;
        self.str.enabled = true;
        self.to.enabled = true;
        self.ag.enabled = true;
        self.wp.enabled = true;
        self.intl.enabled = true;
        self.cha.enabled = true;
        self.bonusWounds.enabled = true;
        self.bonusAMelee.enabled = true;
        self.bonusARange.enabled = true;
        
        self.m.backgroundColor = [UIColor whiteColor];
        self.str.backgroundColor = [UIColor whiteColor];
        self.to.backgroundColor = [UIColor whiteColor];
        self.ag.backgroundColor = [UIColor whiteColor];
        self.wp.backgroundColor = [UIColor whiteColor];
        self.intl.backgroundColor = [UIColor whiteColor];
        self.cha.backgroundColor = [UIColor whiteColor];
        self.bonusWounds.backgroundColor = [UIColor whiteColor];
        self.bonusAMelee.backgroundColor = [UIColor whiteColor];
        self.bonusARange.backgroundColor = [UIColor whiteColor];
        
        self.bonusView.alpha = 1;
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

-(BOOL)isTextFieldInStatView:(UITextField *)textField
{
    if (textField == self.m ||
        textField == self.str ||
        textField == self.to ||
        textField == self.ag ||
        textField == self.wp ||
        textField == self.intl ||
        textField == self.cha ||
        textField == self.bonusAMelee ||
        textField == self.bonusARange ||
        textField == self.bonusWounds ||
        textField == self.ac) {
        return true;
    }
    
    return false;
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
