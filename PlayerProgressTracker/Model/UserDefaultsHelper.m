//
//  UserDefaultsHelper.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 31/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "UserDefaultsHelper.h"
#import "Constants.h"

@implementation UserDefaultsHelper

+(NSDate *)lastiCloudUpdateForFileName:(NSString *)fileName;
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] objectForKey:fileName];
}

+(void)setUpdateDate:(NSDate *)date forFileName:(NSString *)fileName;
{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:fileName];
}

+(NSMutableArray *)characterIdsToSave;
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] objectForKey:SHOULD_SAVE_TO_ICLOUD];
}

+(NSMutableArray *)fileNamesToDelete;
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [[NSUserDefaults standardUserDefaults] objectForKey:SHOULD_DELETE_FROM_ICLOUD];
}


+(void)setCharacterIdsToSave:(NSMutableArray *)collection;
{
    [[NSUserDefaults standardUserDefaults] setObject:collection forKey:SHOULD_SAVE_TO_ICLOUD];
}


+(void)setFilenamesToDelete:(NSMutableArray *)collection;
{
    [[NSUserDefaults standardUserDefaults] setObject:collection forKey:SHOULD_DELETE_FROM_ICLOUD];
}

+(void)setPointsLeft:(float)points andOperationStack:(NSMutableDictionary *)operationStack forCharacterWithId:(NSString *)characterId;
{
    NSDictionary *data = @{keyForPointsLeft : @(points),
                           keyForOperationStack : operationStack};
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:characterId];

}

+(NSDictionary *)infoForUnfinishedCharacterWithId:(NSString *)characterId;
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:characterId];
    if (dict) {
        NSMutableDictionary *stack = [NSMutableDictionary new];
        NSDictionary *stackDict = [dict objectForKey:keyForOperationStack];
        for (NSString *unmutableArrayKeys in stackDict.allKeys) {
            NSMutableArray *mutableOne = [NSMutableArray new];
            
            for (NSNumber *portion in [stackDict objectForKey:unmutableArrayKeys]) {
                [mutableOne addObject:portion];
            }
            
            [stack setObject:mutableOne forKey:unmutableArrayKeys];
        }
        
        return @{keyForPointsLeft : [dict objectForKey:keyForPointsLeft],
                 keyForOperationStack : stack};
    }
    else {
        return nil;
    }
}

+(void)clearTempDataForCharacterId:(NSString *)characterId;
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:characterId];
}

@end
