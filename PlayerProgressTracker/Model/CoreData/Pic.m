//
//  Pic.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 23.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "Pic.h"
#import "Skill.h"
#import "MainContextObject.h"


@implementation Pic

@dynamic pathToDisk;
@dynamic characters;
@dynamic skills;
@dynamic items;
@dynamic picId;


+(Pic *)picWithPath:(NSString *)path;
{
    UIImage *image = [UIImage imageNamed:path];
    if (image && path) {
        Pic *pic;
        NSArray *pics = [Pic fetchRequestForObjectName:@"Pic" withPredicate:[NSPredicate predicateWithFormat:@"picId = %@",path] withContext:[MainContextObject sharedInstance].managedObjectContext];
        if (pics && pics.count) {
            pic = pics.lastObject;
        }
        else {
            pic = [NSEntityDescription insertNewObjectForEntityForName:@"Pic" inManagedObjectContext:[MainContextObject sharedInstance].managedObjectContext];
            pic.picId = path;
        }
        
        return pic;
    }
    
    return nil;
}


@end