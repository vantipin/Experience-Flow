//
//  Pic.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 23.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataClass.h"

@class Skill;

@interface Pic : CoreDataClass

@property (nonatomic, retain) NSString * pathToDisk;
@property (nonatomic, retain) NSSet *characters;
@property (nonatomic, retain) NSSet *skills;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSString *picId;
@end

@interface Pic (CoreDataGeneratedAccessors)

- (void)addCharactersObject:(NSManagedObject *)value;
- (void)removeCharactersObject:(NSManagedObject *)value;
- (void)addCharacters:(NSSet *)values;
- (void)removeCharacters:(NSSet *)values;

- (void)addSkillsObject:(Skill *)value;
- (void)removeSkillsObject:(Skill *)value;
- (void)addSkills:(NSSet *)values;
- (void)removeSkills:(NSSet *)values;

- (void)addItemsObject:(Skill *)value;
- (void)removeItemsObject:(Skill *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;


+(Pic *)addPicWithImage:(UIImage *)image;


-(UIImage *)imageFromPic;
@end
