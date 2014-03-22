//
//  PietySkill.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 22.03.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Skill.h"

@class CharacterConditionAttributes;

@interface PietySkill : Skill

@property (nonatomic, retain) CharacterConditionAttributes *currentlyUsedByCharacter;

@end
