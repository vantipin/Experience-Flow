//
//  AppDelegate.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 19.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "AppDelegate.h"
#import "Character.h"
#import "Skill.h"
#import "SkillSet.h"
#import "SkillTemplate.h"
#import "MainContextObject.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSManagedObjectContext *context = [[MainContextObject sharedInstance] managedObjectContext];
    
    NSArray *unfinishedCharacters = [Character fetchUnfinishedCharacterWithContext:context];
    for (Character *unfinishedOne in unfinishedCharacters){
        if (unfinishedOne == [unfinishedCharacters lastObject]){
            break;
        }
        [Character deleteCharacterWithId:unfinishedOne.characterId withContext:context];
        NSLog(@"Cleaning up unsaved characters.");
    }
    
    for (int16_t i = AdvancedSkillType; i < LastElementInEnum; i++) {
        NSArray *skillsWithoutSet = [Skill fetchRequestForObjectName:[SkillTemplate entityNameForSkillEnum:i] withPredicate:[NSPredicate predicateWithFormat:@"skillSet = %@",nil] withContext:context];
        for (Skill *emptySkill in skillsWithoutSet) {
            [Skill deleteSkillWithId:emptySkill.skillId withContext:context];
            NSLog(@"Cleaning up skills without characters attached to them.");
        }
    }
    NSArray *unusambleSkillSets = [SkillSet fetchNamelessAndCharacterlessSkillSetsWithContext:context];
    for (SkillSet *skillSet in unusambleSkillSets) {
        [SkillSet deleteSkillSet:skillSet withContext:context];
        NSLog(@"Cleaning up skillSets without characters or name.");
    }

    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
