//
//  NewCharacterViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerWithCoreDataMethods.h"
#import "warhammerDefaultSkillSetManager.h"
#import "ColorConstants.h"
#import "StatSetDropDown.h"
#import "StatView.h"
#import "StatSet.h"

@interface NewCharacterViewController : ViewControllerWithCoreDataMethods <UITextFieldDelegate,DropDownViewDelegate,UIAlertViewDelegate,DeleteStatSetProtocol>

@property (nonatomic) IBOutlet UIButton *raceBtn;
@property (nonatomic) IBOutlet UILabel  *raceLabel;

@property (nonatomic) IBOutlet UIButton *saveSet;
@property (nonatomic) IBOutlet UIButton *saveCharacter;
@property (nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic) IBOutlet UITextField *name;

@property (nonatomic) IBOutlet StatView *statView;

@property (nonatomic) IBOutlet UIView *additionalSkillContainerView;

@end
