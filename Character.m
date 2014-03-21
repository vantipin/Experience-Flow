//
//  Character.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 20.02.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "Character.h"
#import "CharacterConditionAttributes.h"
#import "Pic.h"
#import "Skill.h"
#import "SkillTemplate.h"


@implementation Character

@dynamic characterFinished;
@dynamic dateCreated;
@dynamic dateModifed;
@dynamic name;
@dynamic characterCondition;
@dynamic icon;
@dynamic skillSet;
@dynamic wounds;
@dynamic characterId;

//create/update

+(Character *)newCharacterWithName:(NSString *)name
                          withIcon:(UIImage *)icon             //can be nil
                      withSkillSet:(NSSet *)skillSet
                       withContext:(NSManagedObjectContext *)context
{
    if (name&&skillSet) //character cannot be created without name or skills
    {
        Character *character = [Character newEmptyCharacterWithContext:context];
        
        if (icon)
        {
            character.icon = [Pic addPicWithImage:icon];
        }
        
        [character addSkillSet:skillSet];
        
        [Character saveCharacter:character withContext:context];
        
        return character;
    }
    
    return  nil;
}

+(Character *)newEmptyCharacterWithContext:(NSManagedObjectContext *)context
{
    Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:context];
    
    character.characterId = [NSString stringWithFormat:@"%@",character.objectID];
    
    NSArray *basicSkills = [Skill newSetOfCoreSkillsWithContext:context];
    for (Skill *coreSkill in basicSkills)
    {
        coreSkill.player = character;
        [character addSkillSetObject:coreSkill];
    }
    
    [Character saveCharacter:character withContext:context];
    NSLog(@"Creating new character");
    return character;
}


+(BOOL)saveCharacter:(Character *)character withContext:(NSManagedObjectContext *)context
{
    BOOL success = false;
    
    if (character)
    {
        if (!character.characterCondition)
        {
            //add default characterContion obj
            CharacterConditionAttributes *characterCondition = [NSEntityDescription insertNewObjectForEntityForName:@"CharacterConditionAttributes" inManagedObjectContext:context];
            characterCondition.character = character;
            character.characterCondition = characterCondition;
        }
        
        if (!character.dateCreated)
        {
            character.dateCreated = [CoreDataClass standartDateFormat:[[NSDate date] timeIntervalSince1970]];
        }
        
        character.dateModifed = [[NSDate date] timeIntervalSince1970];
        
        success = true;
        
    }
    return success;
}

+(Character *)addNewSkill:(Skill *)skill
        toCharacterWithId:(NSString *)characterId
              withContext:(NSManagedObjectContext *)context
{
    if (skill)
    {
        NSArray *characterArray = [Character fetchCharacterWithId:characterId withContext:context];
        if (characterArray.count!=0&&characterArray)
        {
            //this method only update character skill
            return nil;
        }
        
        Character *character = [characterArray lastObject];
        
        
        //check if skill with such name exist and deny update
        for (Skill *characterSkill in [character.skillSet allObjects])
        {
            if ([skill.skillTemplate.name isEqualToString:characterSkill.skillTemplate.name])
            {
                return character;
            }
        }
        
        //check if skill has any parent skills for this character created and link them
        //if not - in addition create parent skill
        if (skill.skillTemplate.basicSkillTemplate)
        {
            //NSDictionary *complexPredicateDictionary = @{@"player":character,@"skillTemplate.name":skill.skillTemplate.basicSkillTemplate.name};
            NSPredicate *predicateTemplate = [NSComparisonPredicate predicateWithFormat:@"(player = %@) AND (skillTemplate.name = %@)",character,skill.skillTemplate.basicSkillTemplate.name];
            NSArray *existingBasicSkills = [Character fetchRequestForObjectName:[SkillTemplate entityNameForSkillTemplate:skill.skillTemplate.basicSkillTemplate] withPredicate:predicateTemplate withContext:context];
            
            if (!(existingBasicSkills && existingBasicSkills.count!=0)) //if not exist
            {
                Skill *newParentSkill = [Skill newSkillWithTemplate:skill.skillTemplate.basicSkillTemplate withBasicSkill:nil withCurrentXpPoints:0 withContextToHoldItUntilContextSaved:context];
                [Character addNewSkill:newParentSkill toCharacterWithId:character.characterId withContext:context];
            }
            skill.basicSkill = [existingBasicSkills lastObject];
        }
        
        [character addSkillSetObject:skill];
        //character.dateModifed = [[NSDate date] timeIntervalSince1970];
        
        [Character saveCharacter:character withContext:context];
        
        return character;
    }
    return nil;
}


+(Character *)updateCharacterWithId:(NSString *)characterId
                           withIcon:(UIImage *)icon            //can be nil
                       withSkillSet:(NSSet *)skillSet          //can be nil
                        withContext:(NSManagedObjectContext *)context
{
    
    NSArray *characterArray = [Character fetchCharacterWithId:characterId withContext:context];
    if (characterArray.count!=0&&characterArray)
    {
        //this method only update character skill
        return nil;
    }
    
    Character *character = [characterArray lastObject];
    
    if (icon)
    {
        character.icon = [Pic addPicWithImage:icon];
    }
    if (skillSet)
    {
        [character addSkillSet:skillSet];
    }
    
    //character.dateModifed = [[NSDate date] timeIntervalSince1970];
    [Character saveCharacter:character withContext:context];
    return character;
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
