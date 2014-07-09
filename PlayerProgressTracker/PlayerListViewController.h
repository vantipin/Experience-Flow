//
//  ViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 19.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"

@protocol PlayerListProtocol <NSObject>

-(void)didTabPlayer:(Character *)character;
-(void)didTapNewPlayer;

@end

@interface PlayerListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id<PlayerListProtocol> delegate;

+(PlayerListViewController *)getInstanceFromStoryboard;

-(void)updateDataSource;

@end
