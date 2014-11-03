//
//  PlayerManagerViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSplitViewController.h"
#import "CharacterViewController.h"
#import "iCloud.h"

@interface PlayerManagerViewController : CustomSplitViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, iCloudDelegate, CharacterControllerProtocol>

@property (nonatomic) UIViewController *contentController;

@end
