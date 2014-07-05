//
//  PlayerViewCell.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 05.07.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *dateChanged;
@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UIImageView *icon;

@end
