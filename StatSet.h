//
//  StatSet.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 07.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataClass.h"


@interface StatSet : CoreDataClass

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t m;
@property (nonatomic) int16_t ws;
@property (nonatomic) int16_t bs;
@property (nonatomic) int16_t s;
@property (nonatomic) int16_t t;
@property (nonatomic) int16_t ld;
@property (nonatomic) int16_t i;
@property (nonatomic) int16_t a;
@property (nonatomic) int16_t w;

//create
+(StatSet *)createStatSetWithName:(NSString *)setName
                            withM:(int)M
                           withWs:(int)WS
                           withBS:(int)BS
                            withS:(int)S
                            withT:(int)T
                            withI:(int)Initiative
                            withA:(int)A
                            withW:(int)W
                           withLD:(int)LD
                      withContext:(NSManagedObjectContext *)context;

//fetch
+(NSArray *)fetchStatSetsWithContext:(NSManagedObjectContext *)context;
+(StatSet *)fetchStatSetWithName:(NSString *)setName withContext:(NSManagedObjectContext *)context;

//delete
+(BOOL)deleteStatSetWithName:(NSString *)setName withContext:(NSManagedObjectContext *)context;

@end
