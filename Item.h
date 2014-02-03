//
//  Item.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 11.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pic;

@interface Item : NSManagedObject

@property (nonatomic) float encumbrance;
@property (nonatomic) int16_t rarity;
@property (nonatomic) int16_t cost;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) Pic *icon;

@end
