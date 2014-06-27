//
//  Character.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "Character.h"
#import "CharacterConditionAttributes.h"
#import "Pic.h"
#import "SkillSet.h"
#import "DefaultSkillTemplates.h"
#import "SkillTemplate.h"


@implementation Character

@dynamic characterFinished;
@dynamic characterId;
@dynamic dateCreated;
@dynamic dateModifed;
@dynamic name;
@dynamic wounds;
@dynamic characterCondition;
@dynamic icon;
@dynamic skillSet;

//create/update

+(Character *)newCharacterWithContext:(NSManagedObjectContext *)context
{
    Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:context];
    character.characterId = [NSString stringWithFormat:@"%@",character.objectID];
    SkillSet *skillSet = [NSEntityDescription insertNewObjectForEntityForName:@"SkillSet" inManagedObjectContext:context];
    character.skillSet = skillSet;
    
    NSArray *defaultSkillSetTemplates = [[DefaultSkillTemplates sharedInstance] allCoreSkillTemplates];
    for (SkillTemplate *skillTemplate in defaultSkillSetTemplates) {
        [[SkillManager sharedInstance] addNewSkillWithTempate:skillTemplate toSkillSet:character.skillSet withContext:context];
    }
    
    [character saveCharacterWithContext:context];
    NSLog(@"Creating new character");
    return character;
}


-(BOOL)saveCharacterWithContext:(NSManagedObjectContext *)context;
{
    BOOL success = false;
    
    if (!self.characterCondition)
    {
        //add default characterContion obj
        CharacterConditionAttributes *characterCondition = [NSEntityDescription insertNewObjectForEntityForName:@"CharacterConditionAttributes" inManagedObjectContext:context];
        characterCondition.character = self;
        self.characterCondition = characterCondition;
    }
    
    if (!self.dateCreated)
    {
        self.dateCreated = [CoreDataClass standartDateFormat:[[NSDate date] timeIntervalSince1970]];
    }
    
    self.dateModifed = [[NSDate date] timeIntervalSince1970];
    
    [Character saveContext:context];
    
    success = true;
    return success;
}

-(MeleeSkill *)addToCurrentMeleeSkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
{
    MeleeSkill* skill = (MeleeSkill *)[[SkillManager sharedInstance] addNewSkillWithTempate:skillTemplate toSkillSet:self.skillSet withContext:context];
    if ([self.characterCondition.currentMeleeSkills containsObject:skill]) {
        return skill;
    }
    
    [self.characterCondition addCurrentMeleeSkillsObject:skill];
    [self saveCharacterWithContext:context];
    return skill;
}


-(MeleeSkill *)removeFromCurrentMeleeSkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
{
    NSString *entityName = [SkillTemplate entityNameForSkillTemplate:skillTemplate];
    MeleeSkill* skill = (MeleeSkill *)[[Character fetchRequestForObjectName:entityName withPredicate:[NSPredicate predicateWithFormat:@"currentlyUsedByCharacter = %@",self.characterCondition] withContext:context] lastObject];
    [self.characterCondition removeCurrentMeleeSkillsObject:skill];
    [self saveCharacterWithContext:context];
    return skill;
}


-(RangeSkill *)setCurrentRangeSkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
{
    RangeSkill *skill = (RangeSkill *)[[SkillManager sharedInstance] addNewSkillWithTempate:skillTemplate toSkillSet:self.skillSet withContext:context];
    self.characterCondition.currentRangeSkills = skill;
    
    return skill;
}

-(MagicSkill *)setCurrentMagicSkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
{
    MagicSkill *skill = (MagicSkill *)[[SkillManager sharedInstance] addNewSkillWithTempate:skillTemplate toSkillSet:self.skillSet withContext:context];
    self.characterCondition.currentMagicSkills = skill;
    
    return skill;
}

-(PietySkill *)setCurrentPietySkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
{
    PietySkill *skill = (PietySkill *)[[SkillManager sharedInstance] addNewSkillWithTempate:skillTemplate toSkillSet:self.skillSet withContext:context];
    self.characterCondition.currentPietySkills = skill;
    
    return skill;
}

//fetch
+(NSArray *)fetchCharacterWithId:(NSString *)characterId withContext:(NSManagedObjectContext *)context
{
    return   [Character fetchRequestForObjectName:@"Character"
                                    withPredicate:[NSPredicate predicateWithFormat:@"characterId = %@",characterId]
                                      withContext:context];
}

+(NSArray *)fetchFinishedCharacterWithContext:(NSManagedObjectContext *)context
{
    NSArray *validCharacters = [Character fetchRequestForObjectName:@"Character"
                                                      withPredicate:[NSPredicate predicateWithFormat:@"characterFinished = %i",1]
                                                        withContext:context];
    return validCharacters;
}

+(NSArray *)fetchUnfinishedCharacterWithContext:(NSManagedObjectContext *)context
{
    return [Character fetchRequestForObjectName:@"Character"
                                  withPredicate:[NSPredicate predicateWithFormat:@"characterFinished = %i",0]
                                    withContext:context];
}

//delete
+(BOOL)deleteCharacterWithId:(NSString *)characterId withContext:(NSManagedObjectContext *)context
{
    //TODO check if all depended entities being deleted
    return [Character clearEntityForNameWithObjName:@"Character" withPredicate:[NSPredicate predicateWithFormat:@"characterId = %@",characterId] withGivenContext:context];
    
}

@end
