//
//  SkillLevelsSetManager.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 25.06.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "SkillLevelsSetManager.h"
#import "DefaultSkillTemplates.h"
#import "SkillManager.h"
#import "MainContextObject.h"
#import "SkillLevelsSet.h"
#import "SkillTemplate.h"
#import "Character.h"
#import "SkillSet.h"


static NSString *nameEmpty = @"Empty";
static NSString *nameHuman = @"Human";
static SkillLevelsSetManager *instance = nil;

@interface SkillLevelsSetManager()

@property (nonatomic) NSManagedObjectContext *context;

@end

@implementation SkillLevelsSetManager


+ (SkillLevelsSetManager *)sharedInstance {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        if (!instance) {
            instance = [[SkillLevelsSetManager alloc] init];
            //atexit(deallocSingleton);
        }
    });
    
    return instance;
}

-(NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [[MainContextObject sharedInstance] managedObjectContext];
    }
    return _context;
}


-(void)loadLevelsSetNamed:(NSString *)setName forCharacter:(Character *)character
{
    NSDictionary *setDict = [self loadSkillLevelsSetWithName:setName];
    
    if (setDict) {
        //emptify all character skill
        for (Skill *skill in character.skillSet.skills) {
            skill.currentLevel = skill.skillTemplate.skillStartingLvl;
            skill.currentProgress = 0;
        }
        
        //load from set
        for (NSString *key in setDict.allKeys) {
            
            NSNumber *levelValue = [setDict objectForKey:key];
            
            if (levelValue) {
                NSArray *templateArray = [SkillTemplate fetchSkillTemplateForName:key withContext:self.context];
                if (templateArray && templateArray.count)
                {
                    SkillTemplate *template = [templateArray lastObject];
                    Skill *skill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:template withCharacter:character];
                    
                    
                    skill.currentLevel = [levelValue integerValue];
                    
                }
            }
        }
        
        [SkillLevelsSet saveContext:self.context];
    }
}


-(void)synchroniseTemplatesWithDefaultValues
{
    NSArray *existingEmpty = [SkillLevelsSet fetchRequestForObjectName:@"SkillLevelsSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",nameEmpty] withContext:self.context];
    if (!existingEmpty || !existingEmpty.count) {
        NSDictionary *set = @{};
        [self saveSkillLevelsSet:set withName:nameEmpty];
    }
    
    NSArray *existingHuman = [SkillLevelsSet fetchRequestForObjectName:@"SkillLevelsSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",nameHuman] withContext:self.context];
    if (!existingHuman || !existingHuman.count) {
        NSDictionary *set = @{[DefaultSkillTemplates sharedInstance].physique.name : @(2),
                              [DefaultSkillTemplates sharedInstance].intelligence.name : @(2),
                              
                              [DefaultSkillTemplates sharedInstance].strength.name : @(2),
                              [DefaultSkillTemplates sharedInstance].toughness.name : @(2),
                              [DefaultSkillTemplates sharedInstance].agility.name : @(2),
                              [DefaultSkillTemplates sharedInstance].reason.name : @(2),
                              [DefaultSkillTemplates sharedInstance].control.name : @(2),
                              [DefaultSkillTemplates sharedInstance].agility.name : @(2)};
        [self saveSkillLevelsSet:set withName:nameHuman];
    }
}

-(void)saveSkillLevelsSet:(NSDictionary *)setDictionary withName:(NSString *)name
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:setDictionary];
    NSArray *existingSet = [SkillLevelsSet fetchRequestForObjectName:@"SkillLevelsSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withContext:self.context];
    
    SkillLevelsSet *set;
    if (existingSet && existingSet.count) {
        set = [existingSet lastObject];
    }
    else {
        set = [NSEntityDescription insertNewObjectForEntityForName:@"SkillLevelsSet" inManagedObjectContext:self.context];
        set.name = name;
    }
    
    set.data = data;
    [SkillLevelsSet saveContext:self.context];
    
}

-(NSDictionary *)loadSkillLevelsSetWithName:(NSString *)name
{
    NSArray *existingSet = [SkillLevelsSet fetchRequestForObjectName:@"SkillLevelsSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withContext:self.context];
    SkillLevelsSet *set;
    if (existingSet && existingSet.count) {
        set = [existingSet lastObject];
        
        NSDictionary *setDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:set.data];
        return setDictionary;
    }
    
    return nil;
}

@end
