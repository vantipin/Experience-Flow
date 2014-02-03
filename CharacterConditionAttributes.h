//
//  CharacterConditionAttributes.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 11.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character, Insanity;

@interface CharacterConditionAttributes : NSManagedObject

@property (nonatomic) int16_t armorSave;
@property (nonatomic) int16_t freeArmorSave;
@property (nonatomic) int16_t adrenalinPoints;
@property (nonatomic) int16_t stress;
@property (nonatomic) int16_t modifierA;
@property (nonatomic) int16_t modifierHp;
@property (nonatomic) int16_t mutationPoints;
@property (nonatomic) int16_t favor;
@property (nonatomic, retain) Character *character;
@property (nonatomic, retain) NSSet *insanaties;
@property (nonatomic, retain) NSManagedObject *weaponMelee;
@property (nonatomic, retain) NSManagedObject *weaponRanged;
@end

@interface CharacterConditionAttributes (CoreDataGeneratedAccessors)

- (void)addInsanatiesObject:(Insanity *)value;
- (void)removeInsanatiesObject:(Insanity *)value;
- (void)addInsanaties:(NSSet *)values;
- (void)removeInsanaties:(NSSet *)values;

@end
