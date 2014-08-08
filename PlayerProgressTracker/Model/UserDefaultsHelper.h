//
//  UserDefaultsHelper.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 31/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *keyForPointsLeft = @"pointsLeft";
static NSString *keyForOperationStack = @"operationStack";

@interface UserDefaultsHelper : NSObject

+(NSDate *)lastiCloudUpdateForFileName:(NSString *)fileName;
+(void)setUpdateDate:(NSDate *)date forFileName:(NSString *)fileName;
+(NSMutableArray *)characterIdsToSave;
+(NSMutableArray *)fileNamesToDelete;
+(void)setCharacterIdsToSave:(NSMutableArray *)collection;
+(void)setFilenamesToDelete:(NSMutableArray *)collection;

+(void)setPointsLeft:(float)points andOperationStack:(NSMutableDictionary *)operationStack forCharacterWithId:(NSString *)characterId;
+(NSDictionary *)infoForUnfinishedCharacterWithId:(NSString *)characterId;
+(void)clearTempDataForCharacterId:(NSString *)characterId;
@end
