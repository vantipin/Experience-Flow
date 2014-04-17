//
//  NewCharacterViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainContextObject.h"
#import "SkillManager.h"
#import "ColorConstants.h"
#import "ClassesDropViewController.h"
#import "StatView.h"
#import "SkillTableViewController.h"
#import "AddSkillDropViewController.h"

@interface NewCharacterViewController : UIViewController <UITextFieldDelegate,DropDownViewDelegate,UIAlertViewDelegate,DeleteStatSetProtocol,SkillTableViewControllerDelegate,AddNewSkillControllerProtocol>

@property (nonatomic) IBOutlet UIButton *raceBtn;
@property (nonatomic) IBOutlet UILabel  *raceLabel;
@property (nonatomic) IBOutlet UIButton *saveSet;
@property (nonatomic) IBOutlet UIButton *saveCharacter;
@property (nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic) IBOutlet UITextField *name;
@property (nonatomic) IBOutlet UIView *statViewContainer;
@property (nonatomic) IBOutlet UIView *additionalSkillContainerView;
@property (nonatomic) IBOutlet UIButton *addNewSkillButton;

@end
