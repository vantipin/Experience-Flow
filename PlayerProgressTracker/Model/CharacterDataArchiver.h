//
//  CharacterProgressDataArchiver.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 22/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Character.h"

@interface CharacterDataArchiver : NSObject <NSCoding>

+(NSData *)chracterToDictionaryData:(Character *)character;
+(void)loadCharacterFromDictionaryData:(NSData *)archive withContext:(NSManagedObjectContext *)context;

@end
