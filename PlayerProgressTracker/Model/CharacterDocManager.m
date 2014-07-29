//
//  CharacterDocManager.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 28/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CharacterDocManager.h"

@implementation CharacterDocManager

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if ([contents length]) {
        self.contentArchiver = contents;
    }
    
    return true;
}

-(id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSLog(@"autosaving");
    return self.contentArchiver;
}

@end
