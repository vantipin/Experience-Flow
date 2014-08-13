//
//  StatViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.06.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatViewProtocol <NSObject>

-(void)didTapHealth;
-(void)didTapInventory;
-(void)didTapMovement;
-(void)didTapInitiative;

@end

@interface StatViewController : UIViewController

+(StatViewController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;
+(float)headerHeight;

@property (nonatomic,assign) id<StatViewProtocol> delegate;

@property (nonatomic) IBOutlet UILabel *healthCurrentLabel;
@property (nonatomic) IBOutlet UILabel *healthMaxLabel;
@property (nonatomic) IBOutlet UILabel *inventoryCurrentLabel;
@property (nonatomic) IBOutlet UILabel *inventoryMaxLabel;
@property (nonatomic) IBOutlet UILabel *movementLabel;
@property (nonatomic) IBOutlet UILabel *initiativeLabel;


@end
