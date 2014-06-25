//
//  CharacterConditionAttributes.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character, Insanity, MagicSkill, MeleeSkill, PietySkill, RangeSkill, WeaponMelee, WeaponRanged;

@interface CharacterConditionAttributes : NSManagedObject

@property (nonatomic) int16_t adrenalinPoints;
@property (nonatomic) int16_t favor;
@property (nonatomic) int16_t mutationPoints;
@property (nonatomic) int16_t stress;
@property (nonatomic, retain) Character *character;
@property (nonatomic, retain) MagicSkill *currentMagicSkills;
@property (nonatomic, retain) NSSet *currentMeleeSkills;
@property (nonatomic, retain) PietySkill *currentPietySkills;
@property (nonatomic, retain) RangeSkill *currentRangeSkills;
@property (nonatomic, retain) NSSet *insanaties;
@property (nonatomic, retain) WeaponMelee *weaponMelee;
@property (nonatomic, retain) WeaponRanged *weaponRanged;
@end

@interface CharacterConditionAttributes (CoreDataGeneratedAccessors)

- (void)addCurrentMeleeSkillsObject:(MeleeSkill *)value;
- (void)removeCurrentMeleeSkillsObject:(MeleeSkill *)value;
- (void)addCurrentMeleeSkills:(NSSet *)values;
- (void)removeCurrentMeleeSkills:(NSSet *)values;

- (void)addInsanatiesObject:(Insanity *)value;
- (void)removeInsanatiesObject:(Insanity *)value;
- (void)addInsanaties:(NSSet *)values;
- (void)removeInsanaties:(NSSet *)values;

@end
