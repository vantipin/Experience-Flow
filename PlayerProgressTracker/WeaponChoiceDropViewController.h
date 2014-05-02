//
//  WeaponChoiceDropViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 24.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "DropDownViewController.h"

@interface WeaponChoiceDropViewController : DropDownViewController

@property (nonatomic, readonly) NSArray *meleeSkills;
@property (nonatomic, readonly) NSArray *rangeSkills;

@end
