//
//  CharacterConditionAttributes.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 22.03.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character, Insanity, MagicSkill, MeleeSkill, PietySkill, RangeSkill, WeaponMelee, WeaponRanged;

@interface CharacterConditionAttributes : NSManagedObject

@property (nonatomic) int16_t adrenalinPoints;
@property (nonatomic) int16_t armorSave;
@property (nonatomic) int16_t favor;
@property (nonatomic) int16_t freeArmorSave;
@property (nonatomic) int16_t modifierAMelee;
@property (nonatomic) int16_t modifierHp;
@property (nonatomic) int16_t mutationPoints;
@property (nonatomic) int16_t stress;
@property (nonatomic) int16_t modifierARange;
@property (nonatomic, retain) Character *character;
@property (nonatomic, retain) NSSet *insanaties;
@property (nonatomic, retain) WeaponMelee *weaponMelee;
@property (nonatomic, retain) WeaponRanged *weaponRanged;
@property (nonatomic, retain) NSSet *currentMeleeSkills;
@property (nonatomic, retain) RangeSkill *currentRangeSkills;
@property (nonatomic, retain) MagicSkill *currentMagicSkills;
@property (nonatomic, retain) PietySkill *currentPietySkills;
@end

@interface CharacterConditionAttributes (CoreDataGeneratedAccessors)

- (void)addInsanatiesObject:(Insanity *)value;
- (void)removeInsanatiesObject:(Insanity *)value;
- (void)addInsanaties:(NSSet *)values;
- (void)removeInsanaties:(NSSet *)values;

- (void)addCurrentMeleeSkillsObject:(MeleeSkill *)value;
- (void)removeCurrentMeleeSkillsObject:(MeleeSkill *)value;
- (void)addCurrentMeleeSkills:(NSSet *)values;
- (void)removeCurrentMeleeSkills:(NSSet *)values;

@end
