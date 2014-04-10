//
//  StatView.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 03.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;

@interface StatView : UIView

@property (nonatomic) IBOutlet UITextField *m;
@property (nonatomic) IBOutlet UITextField *ws;
@property (nonatomic) IBOutlet UITextField *bs;
@property (nonatomic) IBOutlet UITextField *str;
@property (nonatomic) IBOutlet UITextField *to;
@property (nonatomic) IBOutlet UITextField *ag;
@property (nonatomic) IBOutlet UITextField *wp;
@property (nonatomic) IBOutlet UITextField *intl;
@property (nonatomic) IBOutlet UITextField *cha;
@property (nonatomic) IBOutlet UITextField *aMelee;
@property (nonatomic) IBOutlet UITextField *damageMelee;
@property (nonatomic) IBOutlet UITextField *aRange;
@property (nonatomic) IBOutlet UITextField *damageRange;
@property (nonatomic) IBOutlet UITextField *ac;
@property (nonatomic) IBOutlet UITextField *bonusAMelee;
@property (nonatomic) IBOutlet UITextField *bonusARange;
@property (nonatomic) IBOutlet UITextField *bonusWounds;

@property (nonatomic) IBOutlet UIButton *chooseRightHandButton;
@property (nonatomic) IBOutlet UIButton *chooseLeftHandButton;
@property (nonatomic) IBOutlet UIButton *chooseArmorButton;

@property (nonatomic) IBOutlet UILabel *maxHpLabel;
@property (nonatomic) IBOutlet UILabel *currentHpLabel;

@property (nonatomic) IBOutlet UIView *bonusView;

@property (nonatomic) Character *character;
@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) BOOL settable;

@property (nonatomic,weak) UIViewController<UITextFieldDelegate> *executer;

-(void)initFields;

-(void)setViewFromSkillSet;
-(void)setSkillSetFromView;

-(BOOL)nonEmptyStats;
-(BOOL)isTextFieldInStatView:(UITextField *)textField;

@end
