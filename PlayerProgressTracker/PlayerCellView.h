//
//  PlayerCellView.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerCellView : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *playerIcon;
@property (nonatomic) IBOutlet UILabel *playerName;
@property (nonatomic) IBOutlet UILabel *lastModifed;

@end
