//
//  PointsCountLeftController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 07/08/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

static float sizeHeightPointsLeft = 129;
static float sizeWidthPointsLeft = 116;

@interface PointsCountLeftController : UIViewController

+(PointsCountLeftController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;

@property (nonatomic) IBOutlet UILabel *pointsLeft;

@end
