//
//  Character.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 23.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CharacterConditionAttributes.h"
#import "CoreDataClass.h"

@class Pic, Skill ,CharacterConditionAttributes;

@interface Character : CoreDataClass

@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSDate * dateModifed;
@property (nonatomic, retain) NSString * characterId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Pic *icon;
@property (nonatomic, retain) NSSet *skillSet;
@property (nonatomic, retain) CharacterConditionAttributes *characterCondition;
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

//delete
+(BOOL)deleteCharacterWithId:(NSString *)characterId withContext:(NSManagedObjectContext *)context;


@end
