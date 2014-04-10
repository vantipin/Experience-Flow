//
//  SkillViewCell.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomXpRaisingBtnView.h"
#import "Skill.h"


@protocol SkillViewCellDelegate <NSObject>

- (void)raiseXpForSkill:(Skill *)skill withXpPoints:(float)xpPoints;
- (void)lowerXpForSkill:(Skill *)skill withXpPoints:(float)xpPoints;
- (void)skill:(Skill *)skill buttonTapped:(UIButton *)sender;
@end


@interface SkillViewCell : UITableViewCell <UITextFieldDelegate, raisingButtonProtocol>

@property (nonatomic) IBOutlet UIButton *skillNameButton;
@property (nonatomic) IBOutlet UITextField *skillUsableLvlTextField;
@property (nonatomic) IBOutlet UIView *xpView;
@property (nonatomic) IBOutlet CustomXpRaisingBtnView *xpRaisingBtn;
@property (nonatomic) IBOutlet UILabel *currentXpLabel;
@property (nonatomic) IBOutlet UILabel *maxXpLabel;
@property (nonatomic) IBOutlet UIView *skillLvlView;
@property (nonatomic) IBOutlet UILabel *unusableSkillLvlLabel;

@property (nonatomic, strong) Skill *skill;
@property (nonatomic, assign) id<SkillViewCellDelegate> skillCellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSkill:(Skill *)skill forCreatingCharacter:(BOOL)willCreateCharacter;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSkill:(Skill *)skill;
- (void)reloadFields;

-(IBAction)skillNameTaped:(id)sender;

@end
