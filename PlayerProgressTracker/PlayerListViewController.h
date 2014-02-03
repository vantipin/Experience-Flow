//
//  ViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 19.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerWithCoreDataMethods.h"
#import "PlayerCellView.h"
#import "ColorConstants.h"

#import "Character.h"
#import "Pic.h"

#import "warhammerDefaultSkillSetManager.h"

@interface PlayerListViewController : ViewControllerWithCoreDataMethods <UITableViewDataSource>

@property (nonatomic) IBOutlet UITableView *characterTableView;
//@property (nonatomic) IBOutlet UITableViewCell *cell;


@end
