//
//  SkillTableViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillViewCell.h"
#import "SkillManager.h"

@class Character;

@protocol SkillTableViewControllerDelegate <NSObject>

-(void)didUpdateCharacterSkills;

@end

@interface SkillTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,SkillViewCellDelegate,UITextFieldDelegate,SkillChangeProtocol>

@property (nonatomic) CGFloat tableWith;
@property (nonatomic) CGFloat tableHeight;
@property (nonatomic) SkillSet *skillSet;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic,assign) id<SkillTableViewControllerDelegate> skillTableDelegate;

-(void)addNewSkill:(Skill *)skill;

@end
