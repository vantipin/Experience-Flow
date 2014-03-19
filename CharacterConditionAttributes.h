//
//  CharacterConditionAttributes.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 19.03.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character, Insanity, WeaponMelee, WeaponRanged;

@interface CharacterConditionAttributes : NSManagedObject

@property (nonatomic) int16_t adrenalinPoints;
@property (nonatomic) int16_t armorSave;
@property (nonatomic) int16_t favor;
@property (nonatomic) int16_t freeArmorSave;
@property (nonatomic) int16_t modifierA;
@property (nonatomic) int16_t modifierHp;
@property (nonatomic) int16_t mutationPoints;
@property (nonatomic) int16_t stress;
@property (nonatomic, retain) Character *character;
@property (nonatomic, retain) NSSet *insanaties;
@property (nonatomic, retain) WeaponMelee *weaponMelee;
@property (nonatomic, retain) WeaponRanged *weaponRanged;
@property (nonatomic, retain) NSSet *currentMeleeSkills;
@property (nonatomic, retain) NSSet *currentRangeSkills;
@property (nonatomic, retain) NSSet *currentMagicSkills;
@property (nonatomic, retain) NSSet *currentPietySkills;
@end

@interface CharacterConditionAttributes (CoreDataGeneratedAccessors)

- (void)addInsanatiesObject:(Insanity *)value;
- (void)removeInsanatiesObject:(Insanity *)value;
- (void)addInsanaties:(NSSet *)values;
- (void)removeInsanaties:(NSSet *)values;

- (void)addCurrentMeleeSkillsObject:(NSManagedObject *)value;
- (void)removeCurrentMeleeSkillsObject:(NSManagedObject *)value;
- (void)addCurrentMeleeSkills:(NSSet *)values;
- (void)removeCurrentMeleeSkills:(NSSet *)values;

- (void)addCurrentRangeSkillsObject:(NSManagedObject *)value;
- (void)removeCurrentRangeSkillsObject:(NSManagedObject *)value;
- (void)addCurrentRangeSkills:(NSSet *)values;
- (void)removeCurrentRangeSkills:(NSSet *)values;

- (void)addCurrentMagicSkillsObject:(NSManagedObject *)value;
- (void)removeCurrentMagicSkillsObject:(NSManagedObject *)value;
- (void)addCurrentMagicSkills:(NSSet *)values;
- (void)removeCurrentMagicSkills:(NSSet *)values;

- (void)addCurrentPietySkillsObject:(NSManagedObject *)value;
- (void)removeCurrentPietySkillsObject:(NSManagedObject *)value;
- (void)addCurrentPietySkills:(NSSet *)values;
- (void)removeCurrentPietySkills:(NSSet *)values;

@end
