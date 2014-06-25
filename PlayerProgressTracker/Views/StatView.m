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
#import "MainContextObject.h"
#import "CharacterConditionAttributes.h"
#import "DefaultSkillTemplates.h"
#import "ColorConstants.h"

@interface StatView()

//direct links on characters core skills
@property (nonatomic) Skill *wsSkill;
@property (nonatomic) Skill *bsSkill;

@property (nonatomic) Skill *physiqueSkill;
@property (nonatomic) Skill *intelligSkill;

@property (nonatomic) Skill *strSkill;
@property (nonatomic) Skill *toSkill;
@property (nonatomic) Skill *agSkill;
@property (nonatomic) Skill *cntSkill;
@property (nonatomic) Skill *rsnSkill;
@property (nonatomic) Skill *pstSkill;

@end

@implementation StatView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"StatView" owner:nil options:nil];
        self = [views firstObject];
        for (UIView *view in self.headerContainerViewsArray) {
            view.backgroundColor = darkBodyColor;
        }
        for (UIView *view in self.lightContainerViewsArray) {
            view.backgroundColor = lightBodyColor;
        }
        for (UIView *view in self.bodyContainerViewsArray) {
            view.backgroundColor = bodyColor;
        }
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

-(Skill *)physiqueSkill
{
    _physiqueSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].physique withCharacter:self.character];
    return _physiqueSkill;
}

-(Skill *)intelligSkill
{
    _intelligSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].intelligence withCharacter:self.character];
    return _intelligSkill;
}


-(Skill *)wsSkill
{
    _wsSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].weaponSkill withCharacter:self.character];
    return _wsSkill;
}

-(Skill *)bsSkill
{
    _bsSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].ballisticSkill withCharacter:self.character];
    return _bsSkill;
}

-(Skill *)strSkill
{
    _strSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].strength withCharacter:self.character];
    return _strSkill;
}

-(Skill *)toSkill
{
    _toSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].toughness withCharacter:self.character];
    return _toSkill;
}

-(Skill *)agSkill
{
    _agSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].agility withCharacter:self.character];
    return _agSkill;
}

-(Skill *)cntSkill
{
    _cntSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].control withCharacter:self.character];
    return _cntSkill;
}

-(Skill *)rsnSkill
{
    _rsnSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].reason withCharacter:self.character];
    return _rsnSkill;
}

-(Skill *)pstSkill
{
    _pstSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].perception withCharacter:self.character];
    return _pstSkill;
}

-(void)setSkillSetFromView
{
    self.character.skillSet.pace = self.bonusPaceTextField.text.integerValue;
    self.character.skillSet.bulk = self.bonusBulkTextField.text.integerValue;
    self.character.skillSet.modifierAMelee = self.bonusAMeleeTextField.text.integerValue;
    self.character.skillSet.modifierARange = self.bonusARangeTextField.text.integerValue;
    
//    self.strSkill.thisLvl = self.strTextField.text.integerValue;
//    self.toSkill.thisLvl = self.toTextField.text.integerValue;
//    self.agSkill.thisLvl = self.agTextField.text.integerValue;
//    self.wpSkill.thisLvl = self.wpTextField.text.integerValue;
//    self.intlSkill.thisLvl = self.intlTextField.text.integerValue;
//    self.chaSkill.thisLvl = self.chaTextField.text.integerValue;

    [self resetUneditableStats];
}

-(void)setViewFromSkillSet
{
    self.bonusBulkTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.bulk];
    self.bonusAMeleeTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.modifierAMelee];
    self.bonusARangeTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.modifierARange];
    self.bonusPaceTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.pace];
    
    [self resetUneditableStats];
}

-(void)resetUneditableStats
{
    //TODO adrenalin and stress points influence

    self.strTextField.text = [NSString stringWithFormat:@"%d",self.strSkill.currentLevel + self.physiqueSkill.currentLevel];
    self.toTextField.text = [NSString stringWithFormat:@"%d",self.toSkill.currentLevel + self.physiqueSkill.currentLevel];
    self.agTextField.text = [NSString stringWithFormat:@"%d",self.agSkill.currentLevel + self.physiqueSkill.currentLevel];
    self.cntrTextField.text = [NSString stringWithFormat:@"%d",self.cntSkill.currentLevel + self.intelligSkill.currentLevel];
    self.rsnTextField.text = [NSString stringWithFormat:@"%d",self.rsnSkill.currentLevel + self.intelligSkill.currentLevel];
    self.pstTextField.text = [NSString stringWithFormat:@"%d",self.pstSkill.currentLevel + self.intelligSkill.currentLevel];

    self.physiqueTextField.text = [NSString stringWithFormat:@"%d",self.physiqueSkill.currentLevel];
    self.intelligTextField.text = [NSString stringWithFormat:@"%d",self.intelligSkill.currentLevel];
    
    self.bulkTextField.text = self.bonusBulkTextField.text;
    self.movementTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.pace + self.physiqueSkill.currentLevel];
    int hp = [[SkillManager sharedInstance] countHpWithCharacter:self.character];
    self.maxHpLabel.text = [NSString stringWithFormat:@"%d",hp];
    self.currentHpLabel.text = [NSString stringWithFormat:@"%d",hp];
}

-(void)initFields
{
    if (!self.settable){
        
        self.bonusPaceTextField.enabled = false;
        self.strTextField.enabled = false;
        self.toTextField.enabled = false;
        self.agTextField.enabled = false;
        self.cntrTextField.enabled = false;
        self.rsnTextField.enabled = false;
        self.pstTextField.enabled = false;
        self.bonusBulkTextField.enabled = false;
        self.bonusAMeleeTextField.enabled = false;
        self.bonusARangeTextField.enabled = false;
        
        self.bonusPaceTextField.backgroundColor = [UIColor clearColor];
        self.strTextField.backgroundColor = [UIColor clearColor];
        self.toTextField.backgroundColor = [UIColor clearColor];
        self.agTextField.backgroundColor = [UIColor clearColor];
        self.cntrTextField.backgroundColor = [UIColor clearColor];
        self.rsnTextField.backgroundColor = [UIColor clearColor];
        self.pstTextField.backgroundColor = [UIColor clearColor];
        self.bonusBulkTextField.backgroundColor = [UIColor clearColor];
        self.bonusAMeleeTextField.backgroundColor = [UIColor clearColor];
        self.bonusARangeTextField.backgroundColor = [UIColor clearColor];
        
        self.bonusView.alpha = 0;
    }
    else{
        self.bonusPaceTextField.delegate = _executer;
        //
        self.strTextField.delegate = _executer;
        self.toTextField.delegate = _executer;
        self.agTextField.delegate = _executer;
        self.cntrTextField.delegate = _executer;
        self.rsnTextField.delegate = _executer;
        self.pstTextField.delegate = _executer;
        //
        self.bonusBulkTextField.delegate = _executer;
        self.bonusAMeleeTextField.delegate = _executer;
        self.bonusARangeTextField.delegate = _executer;
        
        self.bonusPaceTextField.enabled = true;
        //
        self.strTextField.enabled = true;
        self.toTextField.enabled = true;
        self.agTextField.enabled = true;
        self.cntrTextField.enabled = true;
        self.rsnTextField.enabled = true;
        self.pstTextField.enabled = true;
        
        //
        self.bonusBulkTextField.enabled = true;
        self.bonusAMeleeTextField.enabled = true;
        self.bonusARangeTextField.enabled = true;
        
        self.bonusPaceTextField.backgroundColor = [UIColor whiteColor];
        //
        self.strTextField.backgroundColor = [UIColor whiteColor];
        self.toTextField.backgroundColor = [UIColor whiteColor];
        self.agTextField.backgroundColor = [UIColor whiteColor];
        self.cntrTextField.backgroundColor = [UIColor whiteColor];
        self.rsnTextField.backgroundColor = [UIColor whiteColor];
        self.pstTextField.backgroundColor = [UIColor whiteColor];
        //
        self.bonusBulkTextField.backgroundColor = [UIColor whiteColor];
        self.bonusAMeleeTextField.backgroundColor = [UIColor whiteColor];
        self.bonusARangeTextField.backgroundColor = [UIColor whiteColor];
        
        self.bonusView.alpha = 1;
    }
}


-(BOOL)nonEmptyStats
{
    BOOL emptyStats = (self.strTextField.text.length == 0 ||
                       self.toTextField.text.length == 0 ||
                       self.agTextField.text.length == 0 ||
                       self.cntrTextField.text.length == 0 ||
                       self.rsnTextField.text.length == 0 ||
                       self.pstTextField.text.length == 0);
    if (emptyStats){
        return false;
    }
    
    return true;
}

-(BOOL)isTextFieldInStatView:(UITextField *)textField
{
    if (textField == self.bonusPaceTextField ||
        textField == self.strTextField ||
        textField == self.toTextField ||
        textField == self.agTextField ||
        textField == self.cntrTextField ||
        textField == self.rsnTextField ||
        textField == self.pstTextField ||
        textField == self.bonusAMeleeTextField ||
        textField == self.bonusARangeTextField ||
        textField == self.bonusBulkTextField) {
        return true;
    }
    
    return false;
}

-(BOOL)isTextFieldIsSkillToSet:(UITextField *)textField
{
    if (textField == self.strTextField ||
        textField == self.toTextField ||
        textField == self.agTextField ||
        textField == self.cntrTextField ||
        textField == self.rsnTextField ||
        textField == self.pstTextField) {
        return true;
    }
    
    return false;
}

-(void)setSkillFromTextView:(UITextField *)textField
{
    if (textField == self.strTextField) {
        [[SkillManager sharedInstance] setLevelOfSkill:self.strSkill toLevel:textField.text.integerValue];
    }
    else if (textField == self.toTextField) {
        [[SkillManager sharedInstance] setLevelOfSkill:self.toSkill toLevel:textField.text.integerValue];
    }
    else if (textField == self.agTextField) {
        [[SkillManager sharedInstance] setLevelOfSkill:self.agSkill toLevel:textField.text.integerValue];
    }
    else if (textField == self.rsnTextField) {
        [[SkillManager sharedInstance] setLevelOfSkill:self.rsnSkill toLevel:textField.text.integerValue];
    }
    else if (textField == self.pstTextField) {
        [[SkillManager sharedInstance] setLevelOfSkill:self.pstSkill toLevel:textField.text.integerValue];
    }
    else if (textField == self.cntrTextField) {
        [[SkillManager sharedInstance] setLevelOfSkill:self.cntSkill toLevel:textField.text.integerValue];
    }
    
    [self resetUneditableStats];
}
@end
