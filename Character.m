//
//  Character.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 23.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "Character.h"
#import "Pic.h"
#import "Skill.h"
#import "SkillTemplate.h"


@implementation Character

@dynamic dateCreated;
@dynamic dateModifed;
@dynamic characterId;
@dynamic name;
@dynamic icon;
@dynamic skillSet;
@dynamic characterCondition;


//create/update

+(Character *)newCharacterWithName:(NSString *)name
                          withIcon:(UIImage *)icon             //can be nil
                      withSkillSet:(NSSet *)skillSet
                       withContext:(NSManagedObjectContext *)context
{
    if (name&&skillSet) //character cannot be created without name or skills
    {
        NSString *characterId = [NSString base64StringFromData:[name dataUsingEncoding:NSUTF16StringEncoding] length:10];
        
        NSArray *existingCharacterWithId = [Character fetchCharacterWithId:characterId withContext:context];
        if (existingCharacterWithId && existingCharacterWithId.count!=0)
        {
            return [existingCharacterWithId lastObject];
        }
        
        Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:context];
        
        character.characterId = characterId;
        if (icon)
        {
            character.icon = [Pic addPicWithImage:icon];
        }
        [character addSkillSet:skillSet];
        
        character.dateCreated = [CoreDataClass standartDateFormat:[NSDate date]];
        character.dateModifed = [NSDate date];
        
        
        //add default characterContion obj
        CharacterConditionAttributes *characterCondition = [NSEntityDescription insertNewObjectForEntityForName:@"CharacterConditionAttributes" inManagedObjectContext:context];
        characterCondition.character = character;
        character.characterCondition = characterCondition;
        
        
        [CoreDataClass saveContext:context];
        
        return character;
    }
    
    return  nil;
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
            NSArray *existingBasicSkills = [Character fetchRequestForObjectName:@"Skill" withPredicate:predicateTemplate withContext:context];
            
            if (!(existingBasicSkills && existingBasicSkills.count!=0)) //if not exist
            {
                Skill *newParentSkill = [Skill newSkillWithTemplate:skill.skillTemplate.basicSkillTemplate withSkillLvL:0 withBasicSkill:nil withCurrentXpPoints:0 withPlayerId:character.characterId withContext:context];
                [Character addNewSkill:newParentSkill toCharacterWithId:character.characterId withContext:context];
            }
            skill.basicSkill = [existingBasicSkills lastObject];
        }
        
        [character addSkillSetObject:skill];
        character.dateModifed = [NSDate date];
        [Character saveContext:context];
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
    
    character.dateModifed = [NSDate date];
    [Character saveContext:context];
    return character;
}

//fetch
+(NSArray *)fetchCharacterWithId:(NSString *)characterId withContext:(NSManagedObjectContext *)context
{
    return   [Character fetchRequestForObjectName:@"Character"
                               withPredicate:[NSPredicate predicateWithFormat:@"characterId = %@",characterId]
                                 withContext:context];
}

//delete
+(BOOL)deleteCharacterWithId:(NSString *)characterId withContext:(NSManagedObjectContext *)context
{
    return [Character clearEntityForNameWithObjName:@"Character" withPredicate:[NSPredicate predicateWithFormat:@"characterId = %@",characterId] withGivenContext:context];
}


@end
