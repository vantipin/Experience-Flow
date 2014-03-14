//
//  SkillViewCell.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomXpRaisingButton.h"
#import "Skill.h"

@interface SkillViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic) IBOutlet UIButton *skillNameButton;
@property (nonatomic) IBOutlet UITextField *skillUsableLvlTextField;
@property (nonatomic) IBOutlet UIView *xpView;
@property (nonatomic) IBOutlet CustomXpRaisingButton *xpRaisingBtn;
@property (nonatomic) IBOutlet UILabel *currentXpLabel;
@property (nonatomic) IBOutlet UILabel *maxXpLabel;
@property (nonatomic) IBOutlet UIView *skillLvlView;
@property (nonatomic) IBOutlet UILabel *unusableSkillLvlLabel;

@property (nonatomic,strong) Skill *skill;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSkill:(Skill *)skill forCreatingCharacter:(BOOL)willCreateCharacter;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSkill:(Skill *)skill;
- (void)initFields;

-(IBAction)skillNameTaped:(id)sender;

@end
