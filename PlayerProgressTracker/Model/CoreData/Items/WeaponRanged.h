//
//  WeaponRanged.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 11.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WeaponMelee.h"


@interface WeaponRanged : WeaponMelee

@property (nonatomic) int16_t rangeClass;

@end
