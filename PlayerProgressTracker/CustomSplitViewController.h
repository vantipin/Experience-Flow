//
//  CustomSplitViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerListViewController.h"

@interface CustomSplitViewController : UIViewController <PlayerListProtocol>

@property (nonatomic) UIViewController *contentController;

@end
