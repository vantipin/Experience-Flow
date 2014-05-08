//
//  StatView.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 03.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character, Skill;



@interface StatView : UIView

@property (nonatomic) IBOutlet UITextField *intelligTextField;
@property (nonatomic) IBOutlet UITextField *physiqueTextField;
@property (nonatomic) IBOutlet UITextField *bulkTextField;
@property (nonatomic) IBOutlet UITextField *movementTextField;

@property (nonatomic) IBOutlet UITextField *strTextField;
@property (nonatomic) IBOutlet UITextField *toTextField;
@property (nonatomic) IBOutlet UITextField *agTextField;
@property (nonatomic) IBOutlet UITextField *cntrTextField;
@property (nonatomic) IBOutlet UITextField *rsnTextField;
@property (nonatomic) IBOutlet UITextField *pstTextField;

@property (nonatomic) IBOutlet UITextField *bonusAMeleeTextField;
@property (nonatomic) IBOutlet UITextField *bonusARangeTextField;
@property (nonatomic) IBOutlet UITextField *bonusBulkTextField;
@property (nonatomic) IBOutlet UITextField *bonusPaceTextField;

@property (nonatomic) IBOutlet UIButton *chooseRightHandButton;
@property (nonatomic) IBOutlet UIButton *chooseLeftHandButton;
@property (nonatomic) IBOutlet UIButton *chooseArmorButton;

@property (nonatomic) IBOutlet UILabel *maxHpLabel;
@property (nonatomic) IBOutlet UILabel *currentHpLabel;

@property (nonatomic) IBOutletCollection(UIView) NSArray *lightContainerViewsArray;
@property (nonatomic) IBOutletCollection(UIView) NSArray *bodyContainerViewsArray;
@property (nonatomic) IBOutletCollection(UIView) NSArray *headerContainerViewsArray;

@property (nonatomic) IBOutlet UIView *bonusView;

@property (nonatomic) Character *character;
@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) BOOL settable;

@property (nonatomic,weak) UIViewController<UITextFieldDelegate> *executer;

-(void)initFields;

-(void)setSkillFromTextView:(UITextField *)textField;
-(void)setViewFromSkillSet;
-(void)setSkillSetFromView;

-(BOOL)nonEmptyStats;
-(BOOL)isTextFieldInStatView:(UITextField *)textField;
-(BOOL)isTextFieldIsSkillToSet:(UITextField *)textField;

@end
