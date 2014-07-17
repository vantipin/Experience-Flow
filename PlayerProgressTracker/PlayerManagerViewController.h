//
//  PlayerManagerViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSplitViewController.h"

@interface PlayerManagerViewController : CustomSplitViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) UIViewController *contentController;

@end
