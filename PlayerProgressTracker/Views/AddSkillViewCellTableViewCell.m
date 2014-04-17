//
//  AddSkillViewCellTableViewCell.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 17.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "AddSkillViewCellTableViewCell.h"

@implementation AddSkillViewCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AddSkillViewCellTableViewCell" owner:nil options:nil];
        self = [views firstObject];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSkillTemplate:(SkillTemplate *)skillTemplate
{
    _skillTemplate = skillTemplate;
    NSString *title = (skillTemplate.basicSkillTemplate) ? [NSString stringWithFormat:@"%@(%@)",skillTemplate.name,skillTemplate.basicSkillTemplate.name] : skillTemplate.name;
    
    [self.showDescriptionButton setTitle:title forState:UIControlStateNormal];
}

-(void)setShouldDeleteSkill:(BOOL)shouldDeleteSkill
{
    UIImage *image;
    _shouldDeleteSkill = shouldDeleteSkill;
    if (self.shouldDeleteSkill) {
        image = [UIImage imageNamed:@"deleteButton.png" ];
    }
    else {
        image = [UIImage imageNamed:@"addButton.png" ];
    }
    [self.addSkillButton setImage:image forState:UIControlStateNormal];
}

-(void)setWithAnimationAddSkillButtonImage:(UIImage *)image completitionBlock:(void (^)())completionBlock;
{
    [UIView animateWithDuration:0.1 animations:^{
        self.addSkillButton.frame = CGRectMake(self.addSkillButton.frame.origin.x - 60, self.addSkillButton.frame.origin.y, self.addSkillButton.frame.size.width, self.addSkillButton.frame.size.height);
    } completion:^(BOOL success){
        [self.addSkillButton setImage:image forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            self.addSkillButton.frame = CGRectMake(self.addSkillButton.frame.origin.x + 60, self.addSkillButton.frame.origin.y, self.addSkillButton.frame.size.width, self.addSkillButton.frame.size.height);
        } completion:^(BOOL success){completionBlock();}];
    }];
    
}

-(void)setAddSkillButtonToDeleteWithAnimationCompletion:(void (^)())completionBlock;
{
    _shouldDeleteSkill = true;
    [self setWithAnimationAddSkillButtonImage:[UIImage imageNamed:@"deleteButton.png" ] completitionBlock:completionBlock];
}

-(void)setAddSkillButtonToAddWithAnimationCompletion:(void (^)())completionBlock;
{
    _shouldDeleteSkill = false;
    [self setWithAnimationAddSkillButtonImage:[UIImage imageNamed:@"addButton.png" ] completitionBlock:completionBlock];
}

-(IBAction)addSkillButtonTapped:(id)sender
{
    if (self.shouldDeleteSkill) {
        if ([self.delegate deleteThisSkill:self.skillTemplate sender:self]) {
        }
    }
    else {
        if ([self.delegate addThisSkill:self.skillTemplate sender:self]) {
        }
    }
    
}

-(IBAction)showDescriptionButtonTapped:(id)sender
{
    [self.delegate showDescriptionForSkill:self.skillTemplate];
}
@end
