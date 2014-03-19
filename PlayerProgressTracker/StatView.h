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
@property (nonatomic) IBOutlet UITextField *s;
@property (nonatomic) IBOutlet UITextField *t;
@property (nonatomic) IBOutlet UITextField *i;
@property (nonatomic) IBOutlet UITextField *a;
@property (nonatomic) IBOutlet UITextField *ld;
@property (nonatomic) IBOutlet UITextField *w;

@property (nonatomic) IBOutlet UILabel *maxHp;
@property (nonatomic) IBOutlet UILabel *currentHp;

@property (nonatomic) IBOutlet UIView *statContainer;

@property (nonatomic) Character *character;
@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) BOOL settable;


@property (nonatomic,weak) UIViewController<UITextFieldDelegate> *executer;

-(void)initFields;
-(BOOL)nonEmptyStats;

@end
