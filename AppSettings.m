//
//  AppSettings.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 19.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

-(void)Example
{
    id obj;
    
    //Saving the content of a text field to the user defaults:
    
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"field1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Loading the content of a text field from the user defaults:
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    obj = [[NSUserDefaults standardUserDefaults] stringForKey:@"field1"];
}

@end
