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


@end
