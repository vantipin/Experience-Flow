//
//  Character.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 20.02.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CharacterConditionAttributes.h"
#import "CoreDataClass.h"

@class CharacterConditionAttributes, Pic, Skill;

@interface Character : CoreDataClass

@property (nonatomic) BOOL characterFinished;
@property (nonatomic) int16_t wounds;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic) NSTimeInterval dateModifed;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CharacterConditionAttributes *characterCondition;
@property (nonatomic, retain) Pic *icon;
@property (nonatomic, retain) NSString *characterId;
@property (nonatomic, retain) NSSet *skillSet;

@end

@interface Character (CoreDataGeneratedAccessors)

- (void)addSkillSetObject:(Skill *)value;
- (void)removeSkillSetObject:(Skill *)value;
- (void)addSkillSet:(NSSet *)values;
- (void)removeSkillSet:(NSSet *)values;


//methodes for work with object

//create
+(Character *)newCharacterWithName:(NSString *)name
                          withIcon:(UIImage *)icon             //can be nil
                      withSkillSet:(NSSet *)skillSet
                       withContext:(NSManagedObjectContext *)context;

//methodes for smart creating new character
+(Character *)newEmptyCharacterWithContext:(NSManagedObjectContext *)context;
+(BOOL)saveCharacter:(Character *)character withContext:(NSManagedObjectContext *)context;

//update
+(Character *)addNewSkill:(Skill *)skill
        toCharacterWithId:(NSString *)characterId
              withContext:(NSManagedObjectContext *)context;

+(Character *)updateCharacterWithId:(NSString *)characterId
                           withIcon:(UIImage *)icon            //can be nil
                       withSkillSet:(NSSet *)skillSet          //can be nil
                        withContext:(NSManagedObjectContext *)context;

//fetch
+(NSArray *)fetchCharacterWithId:(NSString *)characterId withContext:(NSManagedObjectContext *)context;
+(NSArray *)fetchFinishedCharacterWithContext:(NSManagedObjectContext *)context;
+(NSArray *)fetchUnfinishedCharacterWithContext:(NSManagedObjectContext *)context;

//delete
+(BOOL)deleteCharacterWithId:(NSString *)characterId withContext:(NSManagedObjectContext *)context;

@end
