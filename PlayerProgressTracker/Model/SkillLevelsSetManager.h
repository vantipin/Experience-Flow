//
//  SkillLevelsSetManager.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 25.06.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Character, SkillLevelsSet;

@interface SkillLevelsSetManager : NSObject

+ (SkillLevelsSetManager *)sharedInstance;

-(NSArray *)getLevelSets;

-(void)synchroniseTemplatesWithDefaultValues;
-(void)loadLevelsSetNamed:(NSString *)setName forCharacter:(Character *)character;

-(void)saveSkillLevelsSet:(NSDictionary *)setDictionary withName:(NSString *)name;

-(NSDictionary *)loadSkillLevelsSet:(SkillLevelsSet *)set;
-(NSDictionary *)loadSkillLevelsSetWithName:(NSString *)name;
-(SkillLevelsSet *)fetchSetNamed:(NSString *)name;

-(BOOL)deleteSkillSetWithName:(NSString *)name;
@end
