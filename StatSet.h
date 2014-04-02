//
//  StatSet.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 02.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataClass.h"


@interface StatSet : CoreDataClass

@property (nonatomic) int16_t aMelee;
@property (nonatomic) int16_t aRange;
@property (nonatomic) int16_t bs;
@property (nonatomic) int16_t ag;
@property (nonatomic) int16_t wp;
@property (nonatomic) int16_t m;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t str;
@property (nonatomic) int16_t to;
@property (nonatomic) int16_t w;
@property (nonatomic) int16_t ws;
@property (nonatomic) int16_t intl;
@property (nonatomic) int16_t cha;

//create
+(StatSet *)createTemporaryStatSetWithM:(int)M
                                 withWs:(int)Ws
                                 withBS:(int)Bs
                                withStr:(int)Str
                                 withTo:(int)To
                                 withAg:(int)Ag
                                 withWp:(int)Wp
                                withInt:(int)Intl
                                withCha:(int)Cha
                             withAMelee:(int)AMelee
                             withARange:(int)ARange
                                  withW:(int)W
                            withContext:(NSManagedObjectContext *)context;

//fetch
+(NSArray *)fetchStatSetsWithContext:(NSManagedObjectContext *)context;
+(StatSet *)fetchStatSetWithName:(NSString *)setName withContext:(NSManagedObjectContext *)context;

//delete
+(BOOL)deleteStatSetWithName:(NSString *)setName withContext:(NSManagedObjectContext *)context;

@end
