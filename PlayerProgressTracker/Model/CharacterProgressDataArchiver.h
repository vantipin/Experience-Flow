//
//  CharacterProgressDataArchiver.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 22/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Character.h"

@protocol CharacterProgressArchiverProtocol <NSObject>

-(BOOL)shouldReplaceCharacterProgress:(Character *)character;

@end

@interface CharacterProgressDataArchiver : NSObject <NSCoding>

@property (nonatomic) NSString *characterId;
@property (nonatomic) NSString *characterName;
@property (nonatomic) NSTimeInterval dateModified;
@property (nonatomic) NSDictionary *skillExperienceDictionary;
@property (nonatomic, assign) id<CharacterProgressArchiverProtocol> delegate;

+(CharacterProgressDataArchiver *)newCharacterWithDocPath:(NSString *)docPath
       withConflictResolverController:(id<CharacterProgressArchiverProtocol>)controller
                          withContext:(NSManagedObjectContext *)context;
+(void)saveData:(Character *)skillTemplate toPath:(NSString *)docPath;
+(NSString *)getPrivateDocsDir;

-(void)updateCharacter:(Character *)character withContext:(NSManagedObjectContext *)context;

@end
