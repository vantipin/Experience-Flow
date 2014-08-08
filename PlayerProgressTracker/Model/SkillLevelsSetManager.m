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


-(NSArray *)getLevelSets;
{
    NSArray *existingSets = [SkillLevelsSet fetchRequestForObjectName:@"SkillLevelsSet" withPredicate:nil withContext:self.context];
    if (!existingSets || !existingSets.count) {
        [self synchroniseTemplatesWithDefaultValues];
        existingSets = [SkillLevelsSet fetchRequestForObjectName:@"SkillLevelsSet" withPredicate:nil withContext:self.context];
    }
    
    return existingSets;
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
            skill.currentLevel = skill.skillTemplate.defaultLevel;
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
    if (![self fetchSetNamed:nameEmpty]) {
        NSDictionary *set = @{};
        [self saveSkillLevelsSet:set withName:nameEmpty];
    }
    
    if (![self fetchSetNamed:nameHuman]) {
        NSDictionary *set = @{[DefaultSkillTemplates sharedInstance].physique.name : @(2),
                              [DefaultSkillTemplates sharedInstance].intelligence.name : @(2),
                              
                              [DefaultSkillTemplates sharedInstance].strength.name : @(2),
                              [DefaultSkillTemplates sharedInstance].toughness.name : @(3),
                              [DefaultSkillTemplates sharedInstance].reason.name : @(2),
                              [DefaultSkillTemplates sharedInstance].control.name : @(2),
                              [DefaultSkillTemplates sharedInstance].perception.name : @(2),
                              [DefaultSkillTemplates sharedInstance].agility.name : @(2)};
        [self saveSkillLevelsSet:set withName:nameHuman];
    }
    
    if (![self fetchSetNamed:nameDwarf]) {
        NSDictionary *set = @{[DefaultSkillTemplates sharedInstance].physique.name : @(2),
                              [DefaultSkillTemplates sharedInstance].intelligence.name : @(2),
                              
                              [DefaultSkillTemplates sharedInstance].strength.name : @(2),
                              [DefaultSkillTemplates sharedInstance].toughness.name : @(5),
                              [DefaultSkillTemplates sharedInstance].reason.name : @(2),
                              [DefaultSkillTemplates sharedInstance].control.name : @(2),
                              [DefaultSkillTemplates sharedInstance].perception.name : @(0),
                              [DefaultSkillTemplates sharedInstance].agility.name : @(2)};
        [self saveSkillLevelsSet:set withName:nameDwarf];
    }
}

-(void)saveSkillLevelsSet:(NSDictionary *)setDictionary withName:(NSString *)name
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:setDictionary];
    
    SkillLevelsSet *set = [self fetchSetNamed:name];
    if (!set) {
        set = [NSEntityDescription insertNewObjectForEntityForName:@"SkillLevelsSet" inManagedObjectContext:self.context];
        set.name = name;
    }
    
    set.data = data;
    [SkillLevelsSet saveContext:self.context];
    
}

-(NSDictionary *)loadSkillLevelsSetWithName:(NSString *)name
{
    SkillLevelsSet *set = [self fetchSetNamed:name];
    if (set) {
        return [self loadSkillLevelsSet:set];
    }
    else {
        return nil;
    }
}


-(NSDictionary *)loadSkillLevelsSet:(SkillLevelsSet *)set
{
    NSDictionary *setDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:set.data];
    return setDictionary;
}

-(SkillLevelsSet *)fetchSetNamed:(NSString *)name;
{
    NSArray *existingSet = [SkillLevelsSet fetchRequestForObjectName:@"SkillLevelsSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withContext:self.context];
    
    SkillLevelsSet *set;
    if (existingSet && existingSet.count) {
        set = [existingSet lastObject];
    }
    
    return set;
}

-(BOOL)deleteSkillSetWithName:(NSString *)name;
{
    return [SkillLevelsSet clearEntityForNameWithObjName:@"SkillLevelsSet" withPredicate:[NSPredicate predicateWithFormat:@"name = %@",name] withGivenContext:self.context];
}

@end
