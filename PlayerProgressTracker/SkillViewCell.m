//
//  SkillViewCell.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "SkillViewCell.h"
#import "SkillTemplate.h"
#import "SkillTableViewController.h"
#import "ColorConstants.h"

@interface SkillViewCell()

@property (nonatomic) BOOL characterCreationMode;

@end

@implementation SkillViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SkillViewCell" owner:nil options:nil];
        self = [views firstObject];
        //self.characterCreationMode = false;
        //[self prepareFieldsForUse];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSkill:(Skill *)skill
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SkillViewCell" owner:nil options:nil];
        self = [views firstObject];
        self.skill = skill;
        self.characterCreationMode = false;
        [self prepareFieldsForUse];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSkill:(Skill *)skill forCreatingCharacter:(BOOL)willCreateCharacter
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SkillViewCell" owner:nil options:nil];
        self = [views firstObject];
        self.skill = skill;
        self.characterCreationMode = willCreateCharacter;
        [self prepareFieldsForUse];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareFieldsForUse
{
    self.skillUsableLvlTextField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36];
    
    if (self.characterCreationMode)
    {
        self.skillUsableLvlTextField.delegate = self;
        self.skillUsableLvlTextField.enabled = true;
    }
    self.xpRaisingBtn.delegate = self;
    
    [self reloadFields];
}

-(void)reloadFields
{
    NSString *skillTitle = self.skill.basicSkill ? [NSString stringWithFormat:@"%@(%@)",self.skill.skillTemplate.name,self.skill.basicSkill.skillTemplate.name] : self.skill.skillTemplate.name;
    [self.skillNameButton setTitle:skillTitle forState:UIControlStateNormal];
    self.unusableSkillLvlLabel.text = [NSString stringWithFormat:@"%i",self.skill.thisLvl];
    self.skillUsableLvlTextField.text = [NSString stringWithFormat:@"%d",self.skill.basicSkill ? self.skill.basicSkill.thisLvl + self.skill.thisLvl : self.skill.thisLvl];
    self.maxXpLabel.text = [NSString stringWithFormat:@"%.0f",self.skill.thisLvl * self.skill.skillTemplate.thisSkillProgression + self.skill.skillTemplate.thisBasicBarrier];
    self.currentXpLabel.text = (fmod(self.skill.thisLvlCurrentProgress, 1.0) > 0) ? [NSString stringWithFormat:@"%.1f",self.skill.thisLvlCurrentProgress] : [NSString stringWithFormat:@"%.0f",self.skill.thisLvlCurrentProgress];
}

-(IBAction)skillNameTaped:(id)sender
{
    [self.skillCellDelegate skill:self.skill buttonTapped:sender];
}

-(void)raiseTapped
{
    [self.skillCellDelegate raiseXpForSkill:self.skill withXpPoints:1];
}

-(void)lowerTapped
{
    [self.skillCellDelegate lowerXpForSkill:self.skill withXpPoints:1];
}

//Only when creating new character
-(void)setSkillLevelTo:(int)newSkillLevel
{
    
}

@end
