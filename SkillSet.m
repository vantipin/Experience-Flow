//
//  SkillSet.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "SkillSet.h"
#import "Character.h"
#import "Skill.h"


@implementation SkillSet

@dynamic name;
@dynamic wounds;
@dynamic modifierArmorSave;
@dynamic modifierAMelee;
@dynamic modifierARange;
@dynamic modifierHp;
@dynamic skills;
@dynamic character;

+(NSArray *)fetchNamelessAndCharacterlessSkillSetsWithContext:(NSManagedObjectContext *)context;
{
    NSArray *skillSets = [SkillSet fetchRequestForObjectName:@"SkillSet" withPredicate:[NSPredicate predicateWithFormat:@"(name = nil) AND (character = nil)"] withContext:context];
    return skillSets;
}
+(NSArray *)fetchCharacterlessSkillSetsWithContext:(NSManagedObjectContext *)context;
{
    NSArray *skillSets = [SkillSet fetchRequestForObjectName:@"SkillSet" withPredicate:[NSPredicate predicateWithFormat:@"character = nil"] withContext:context];
    return skillSets;
}

+(NSArray *)fetchSkillSetWithName:(NSString *)name withContext:(NSManagedObjectContext *)context;
{
    NSArray *skillSets = [SkillSet fetchRequestForObjectName:@"SkillSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withContext:context];
    return skillSets;
}

+(BOOL)deleteSkillSetWithName:(NSString *)name withContext:(NSManagedObjectContext *)context;
{
    BOOL success = false;
    success = [SkillSet clearEntityForNameWithObjName:@"SkillSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withGivenContext:context];
    
    return success;
}

+(void)deleteSkillSet:(SkillSet *)set withContext:(NSManagedObjectContext *)context;
{
    [context deleteObject:set];
    [SkillSet saveContext:context];
}

@end
