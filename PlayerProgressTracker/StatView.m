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
@property (nonatomic) Skill *mentalitySkill;

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
        for (UIView *view in self.headerContainerViewsArray) {
            view.backgroundColor = darkBodyColor;
        }
        for (UIView *view in self.lightContainerViewsArray) {
            view.backgroundColor = lightBodyColor;
        }
        for (UIView *view in self.bodyContainerViewsArray) {
            view.backgroundColor = bodyColor;
        }
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


-(Skill *)physiqueSkill
{
    _physiqueSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].physique withCharacter:self.character];
    return _physiqueSkill;
}

-(Skill *)mentalitySkill
{
    _mentalitySkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].mentality withCharacter:self.character];
    return _mentalitySkill;
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

-(Skill *)wpSkill
{
    _wpSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].discipline withCharacter:self.character];
    return _wpSkill;
}

-(Skill *)intlSkill
{
    _intlSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].intelligence withCharacter:self.character];
    return _intlSkill;
}

-(Skill *)chaSkill
{
    _chaSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].charisma withCharacter:self.character];
    return _chaSkill;
}

-(void)setSkillSetFromView
{
    self.character.skillSet.pace = self.bonusPaceTextField.text.integerValue;
    self.character.skillSet.bulk = self.bonusBulkTextField.text.integerValue;
    self.character.skillSet.modifierAMelee = self.bonusAMeleeTextField.text.integerValue;
    self.character.skillSet.modifierARange = self.bonusARangeTextField.text.integerValue;
    self.character.skillSet.modifierArmorSave = self.armorTextField.text.intValue;
    
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
//    self.strTextField.text = [NSString stringWithFormat:@"%d",self.strSkill.thisLvl + self.physiqueSkill.thisLvl];
//    self.toTextField.text = [NSString stringWithFormat:@"%d",self.toSkill.thisLvl + self.physiqueSkill.thisLvl];
//    self.agTextField.text = [NSString stringWithFormat:@"%d",self.agSkill.thisLvl + self.physiqueSkill.thisLvl];
//    self.wpTextField.text = [NSString stringWithFormat:@"%d",self.wpSkill.thisLvl + self.mentalitySkill.thisLvl];
//    self.intlTextField.text = [NSString stringWithFormat:@"%d",self.intlSkill.thisLvl + self.mentalitySkill.thisLvl];
//    self.chaTextField.text = [NSString stringWithFormat:@"%d",self.chaSkill.thisLvl + self.mentalitySkill.thisLvl];
    
    self.bonusBulkTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.bulk];
    self.bonusAMeleeTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.modifierAMelee];
    self.bonusARangeTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.modifierARange];
    self.armorTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.modifierArmorSave];
    self.bonusPaceTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.pace];
    
    
    [self resetUneditableStats];
}

-(void)resetUneditableStats
{
    //TODO adrenalin and stress points influence
    
    self.strTextField.text = [NSString stringWithFormat:@"%d",self.strSkill.thisLvl + self.physiqueSkill.thisLvl];
    self.toTextField.text = [NSString stringWithFormat:@"%d",self.toSkill.thisLvl + self.physiqueSkill.thisLvl];
    self.agTextField.text = [NSString stringWithFormat:@"%d",self.agSkill.thisLvl + self.physiqueSkill.thisLvl];
    self.wpTextField.text = [NSString stringWithFormat:@"%d",self.wpSkill.thisLvl + self.mentalitySkill.thisLvl];
    self.intlTextField.text = [NSString stringWithFormat:@"%d",self.intlSkill.thisLvl + self.mentalitySkill.thisLvl];
    self.chaTextField.text = [NSString stringWithFormat:@"%d",self.chaSkill.thisLvl + self.mentalitySkill.thisLvl];

    self.physiqueTextField.text = [NSString stringWithFormat:@"%d",self.physiqueSkill.thisLvl];
    self.mentalityTextField.text = [NSString stringWithFormat:@"%d",self.mentalitySkill.thisLvl];
    
    self.bulkTextField.text = self.bonusBulkTextField.text;
    self.movementTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.pace + self.physiqueSkill.thisLvl];
    int hp = [[SkillManager sharedInstance] countHpWithCharacter:self.character];
    self.maxHpLabel.text = [NSString stringWithFormat:@"%d",hp];
    self.currentHpLabel.text = [NSString stringWithFormat:@"%d",hp];
    
    int weaponSkill = [[SkillManager sharedInstance] countWSforMeleeSkill:self.character.characterCondition.currentMeleeSkills];
    int ballisticSkill = [[SkillManager sharedInstance] countBSforRangeSkill:self.character.characterCondition.currentRangeSkills];
    int attackMelee = ([[SkillManager sharedInstance] countAttacksForMeleeSkill:self.character.characterCondition.currentMeleeSkills] + self.character.skillSet.modifierAMelee);
    int attacksRange = ([[SkillManager sharedInstance] countAttacksForRangeSkill:self.character.characterCondition.currentRangeSkills] + self.character.skillSet.modifierARange);
    int damageBonusRange = [[SkillManager sharedInstance] countDCBonusForRangeSkill:self.character.characterCondition.currentRangeSkills];
    
    
    self.wsTextField.text = [NSString stringWithFormat:@"%d",weaponSkill];
    self.bsTextField.text = [NSString stringWithFormat:@"%d",ballisticSkill];
    
    self.aMeleeTextField.text = [NSString stringWithFormat:@"%d",attackMelee];
    self.aRangeTextField.text = [NSString stringWithFormat:@"%d",attacksRange];
    
    self.damageRangeTextField.text = [NSString stringWithFormat:@"+%d",damageBonusRange];
}

-(void)initFields
{
    if (!self.settable){
        
        self.bonusPaceTextField.enabled = false;
        self.strTextField.enabled = false;
        self.toTextField.enabled = false;
        self.agTextField.enabled = false;
        self.wpTextField.enabled = false;
        self.intlTextField.enabled = false;
        self.chaTextField.enabled = false;
        self.bonusBulkTextField.enabled = false;
        self.bonusAMeleeTextField.enabled = false;
        self.bonusARangeTextField.enabled = false;
        
        self.bonusPaceTextField.backgroundColor = [UIColor clearColor];
        self.strTextField.backgroundColor = [UIColor clearColor];
        self.toTextField.backgroundColor = [UIColor clearColor];
        self.agTextField.backgroundColor = [UIColor clearColor];
        self.wpTextField.backgroundColor = [UIColor clearColor];
        self.intlTextField.backgroundColor = [UIColor clearColor];
        self.chaTextField.backgroundColor = [UIColor clearColor];
        self.bonusBulkTextField.backgroundColor = [UIColor clearColor];
        self.bonusAMeleeTextField.backgroundColor = [UIColor clearColor];
        self.bonusARangeTextField.backgroundColor = [UIColor clearColor];
        
        self.bonusView.alpha = 0;
    }
    else{
        self.bonusPaceTextField.delegate = _executer;
//        self.strTextField.delegate = _executer;
//        self.toTextField.delegate = _executer;
//        self.agTextField.delegate = _executer;
//        self.wpTextField.delegate = _executer;
//        self.intlTextField.delegate = _executer;
//        self.chaTextField.delegate = _executer;
        self.bonusBulkTextField.delegate = _executer;
        self.bonusAMeleeTextField.delegate = _executer;
        self.bonusARangeTextField.delegate = _executer;
        self.armorTextField.delegate = _executer;
        
        
        self.bonusPaceTextField.enabled = true;
//        self.strTextField.enabled = true;
//        self.toTextField.enabled = true;
//        self.agTextField.enabled = true;
//        self.wpTextField.enabled = true;
//        self.intlTextField.enabled = true;
//        self.chaTextField.enabled = true;
        self.bonusBulkTextField.enabled = true;
        self.bonusAMeleeTextField.enabled = true;
        self.bonusARangeTextField.enabled = true;
        
        self.bonusPaceTextField.backgroundColor = [UIColor whiteColor];
//        self.strTextField.backgroundColor = [UIColor whiteColor];
//        self.toTextField.backgroundColor = [UIColor whiteColor];
//        self.agTextField.backgroundColor = [UIColor whiteColor];
//        self.wpTextField.backgroundColor = [UIColor whiteColor];
//        self.intlTextField.backgroundColor = [UIColor whiteColor];
//        self.chaTextField.backgroundColor = [UIColor whiteColor];
        self.bonusBulkTextField.backgroundColor = [UIColor whiteColor];
        self.bonusAMeleeTextField.backgroundColor = [UIColor whiteColor];
        self.bonusARangeTextField.backgroundColor = [UIColor whiteColor];
        
        self.bonusView.alpha = 1;
    }
}


-(BOOL)nonEmptyStats
{
//    BOOL emptyStats = (self.strTextField.text.length == 0 ||
//                       self.toTextField.text.length == 0 ||
//                       self.agTextField.text.length == 0 ||
//                       self.wpTextField.text.length == 0 ||
//                       self.intlTextField.text.length == 0 ||
//                       self.chaTextField.text.length == 0);
//    if (emptyStats){
//        return false;
//    }
    
    return true;
}

-(BOOL)isTextFieldInStatView:(UITextField *)textField
{
    if (textField == self.bonusPaceTextField ||
//        textField == self.strTextField ||
//        textField == self.toTextField ||
//        textField == self.agTextField ||
//        textField == self.wpTextField ||
//        textField == self.intlTextField ||
//        textField == self.chaTextField ||
        textField == self.bonusAMeleeTextField ||
        textField == self.bonusARangeTextField ||
        textField == self.bonusBulkTextField ||
        textField == self.armorTextField) {
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
