//
//  SkillViewCell.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomXpRaisingButton.h"

@interface SkillViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *skillNameLabel;

@property (nonatomic) IBOutlet UITextView *skillUsableLvlTextView;

@property (nonatomic) IBOutlet UIView *xpView;
@property (nonatomic) IBOutlet CustomXpRaisingButton *xpRaisingBtn;
@property (nonatomic) IBOutlet UILabel *currentXpLabel;
@property (nonatomic) IBOutlet UILabel *maxXpLabel;

@property (nonatomic) IBOutlet UIView *skillLvlView;
@property (nonatomic) IBOutlet UILabel *unusableSkillLvlLabel;

@end
