//
//  PointsCountLeftController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 07/08/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointsCountLeftController : UIViewController

+(PointsCountLeftController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;
+(float)sizeHeightPointsLeft;
+(float)sizeWidthPointsLeft;


@property (nonatomic) IBOutlet UILabel *pointsLeft;

@end
