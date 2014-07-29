//
//  CharacterDocManager.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 28/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacterProgressDataArchiver.h"

@interface CharacterDocManager : UIDocument

@property (nonatomic) NSDictionary *contentArchiver;

@end
