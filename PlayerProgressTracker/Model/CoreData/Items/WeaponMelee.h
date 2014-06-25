//
//  WeaponMelee.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 11.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Item.h"

@class Skill;

@interface WeaponMelee : Item

@property (nonatomic) int16_t damageClass;
@property (nonatomic) int16_t damageCritClass;
@property (nonatomic, retain) NSString * qualities;
@property (nonatomic, retain) Skill *skillRequired;

@end
