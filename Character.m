//
//  Character.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 20.02.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "Character.h"
#import "CharacterConditionAttributes.h"
#import "WarhammerDefaultSkillSetManager.h"
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

+(Character *)newCharacterWithContext:(NSManagedObjectContext *)context
{
    Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:context];
    
    character.characterId = [NSString stringWithFormat:@"%@",character.objectID];
    
    NSArray *defaultSkillSetTemplates = [[WarhammerDefaultSkillSetManager sharedInstance] allCharacterDefaultSkillTemplates];
    for (SkillTemplate *skillTemplate in defaultSkillSetTemplates) {
        [character addNewSkillWithTempate:skillTemplate withContext:context];
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
    
    success = true;
    return success;
}

-(Skill *)addNewSkillWithTempate:(SkillTemplate *)skillTemplate
                         withContext:(NSManagedObjectContext *)context;
{
    if (skillTemplate)
    {
        //check if skill with such name exist and deny update
        NSString *skillType = [SkillTemplate entityNameForSkillTemplate:skillTemplate];
        NSPredicate *predicateTemplate = [NSComparisonPredicate predicateWithFormat:@"(player = %@) AND (skillTemplate.name = %@)",self,skillTemplate.name];
        NSArray *alreadyExist = [Skill fetchRequestForObjectName:skillType withPredicate:predicateTemplate withContext:context];
        if (alreadyExist && alreadyExist.count!=0) {
            return [alreadyExist lastObject];
        }
        

        Skill *skill = [Skill newSkillWithTemplate:skillTemplate withBasicSkill:nil withCurrentXpPoints:0 withContext:context];
        [self addSkillSetObject:skill];
        skill.player = self;
        
        //check if skill has any parent skills for this character created and link them
        //if not - in addition create parent skill
        if (skillTemplate.basicSkillTemplate)
        {
            Skill *basicSkill = [self addNewSkillWithTempate:skillTemplate.basicSkillTemplate withContext:context];
            skill.basicSkill = basicSkill;
            [basicSkill addSubSkillsObject:skill];
        }
        
        [self saveCharacterWithContext:context];
        
        return skill;
    }
    return nil;
}


-(MeleeSkill *)addToCurrentMeleeSkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
{
    MeleeSkill* skill = (MeleeSkill *)[self addNewSkillWithTempate:skillTemplate withContext:context];
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
    RangeSkill *skill = (RangeSkill *)[self addNewSkillWithTempate:skillTemplate withContext:context];
    self.characterCondition.currentRangeSkills = skill;
    
    return skill;
}

-(MagicSkill *)setCurrentMagicSkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
{
    MagicSkill *skill = (MagicSkill *)[self addNewSkillWithTempate:skillTemplate withContext:context];
    self.characterCondition.currentMagicSkills = skill;
    
    return skill;
}

-(PietySkill *)setCurrentPietySkillWithTempate:(SkillTemplate *)skillTemplate withContext:(NSManagedObjectContext *)context;
{
    PietySkill *skill = (PietySkill *)[self addNewSkillWithTempate:skillTemplate withContext:context];
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
