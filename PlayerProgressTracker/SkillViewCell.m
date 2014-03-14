//
//  SkillViewCell.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "SkillViewCell.h"
#import "SkillTemplate.h"

@interface SkillViewCell()

@property (nonatomic) BOOL characterCreationMode;

@property (nonatomic) UIView *activeTipView;

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
    
    [self initFields];
}

-(void)initFields
{
    NSString *skillTitle = self.skill.basicSkill ? [NSString stringWithFormat:@"%@(%@)",self.skill.skillTemplate.name,self.skill.basicSkill.skillTemplate.name] : self.skill.skillTemplate.name;
    [self.skillNameButton setTitle:skillTitle forState:UIControlStateNormal];
    self.unusableSkillLvlLabel.text = [NSString stringWithFormat:@"%i",self.skill.thisLvl];
    self.skillUsableLvlTextField.text = [NSString stringWithFormat:@"%d",self.skill.basicSkill ? self.skill.basicSkill.thisLvl + self.skill.thisLvl : self.skill.thisLvl];
    self.maxXpLabel.text = [NSString stringWithFormat:@"%.0f",self.skill.thisLvl * self.skill.skillTemplate.thisSkillProgression + self.skill.skillTemplate.thisBasicBarrier];
    self.currentXpLabel.text = [NSString stringWithFormat:@"%.0f",self.skill.thisLvlCurrentProgress];
    
    [self closeTip];
}

-(IBAction)skillNameTaped:(id)sender
{
    CGRect closingAreaFrame = self.superview.frame;
    CGRect tipFrame = CGRectMake(self.skillNameButton.frame.origin.x,
                                 self.skillNameButton.frame.origin.y + self.skillNameButton.frame.size.height,
                                 300,
                                 10);
    tipFrame = [self convertRect:tipFrame toView:self.superview];
    
    
    UITextView *tipTextView = [[UITextView alloc] initWithFrame:tipFrame];
    [tipTextView setText:self.skill.skillTemplate.skillDescription];
    [tipTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [tipTextView sizeToFit];
    tipTextView.backgroundColor = [UIColor lightTextColor];
    tipTextView.editable = false;
    
    UIView *closingAreaView = [[UIView alloc] initWithFrame:closingAreaFrame];
    closingAreaView.opaque = false;
    closingAreaView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapRecognizer;
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTip)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [closingAreaView addGestureRecognizer:tapRecognizer];
    
    self.activeTipView = [[UIView alloc] initWithFrame:closingAreaFrame];
    [self.activeTipView addSubview:closingAreaView];
    [self.activeTipView addSubview:tipTextView];
    [self.activeTipView bringSubviewToFront:tipTextView];
    
    self.activeTipView.alpha = 0;
    [self.superview addSubview:self.activeTipView];
    [self.superview bringSubviewToFront:self.activeTipView];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.activeTipView.alpha = 1;
    }];
}

-(void)closeTip
{
    if (self.activeTipView)
    {
        [UIView animateWithDuration:0.15 animations:^{
            self.activeTipView.alpha = 0;
        }];
        
        [self.activeTipView removeFromSuperview];
        self.activeTipView = nil;
    }
}


-(void)raiseXpPoints
{
    
}

-(void)lowerXpPoints
{
    
}

//Only when creating new character
-(void)setSkillLevelTo:(int)newSkillLevel
{
    
}

@end
