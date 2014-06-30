//
//  StatViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.06.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatViewController : UIViewController

+(StatViewController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;

@property (nonatomic) IBOutlet UILabel *healthCurrentLabel;
@property (nonatomic) IBOutlet UILabel *healthMaxLabel;
@property (nonatomic) IBOutlet UILabel *inventoryCurrentLabel;
@property (nonatomic) IBOutlet UILabel *inventoryMaxLabel;
@property (nonatomic) IBOutlet UILabel *movementLabel;
@property (nonatomic) IBOutlet UILabel *bulkLabel;

@end
