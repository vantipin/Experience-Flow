//
//  SkillTemplateDiskData.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 07.05.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillTemplate.h"


@interface SkillTemplateDiskData : NSObject <NSCoding>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * skillDescription;
@property (nonatomic, retain) NSString * skillRules;
@property (nonatomic, retain) NSString * skillRulesExamples;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic) float levelBasicBarrier;
@property (nonatomic) float levelProgression;
@property (nonatomic) float levelGrowthGoesToBasicSkill;
@property (nonatomic) int16_t skillStartingLvl;
@property (nonatomic) SkillClassesType skillEnumType;
@property (nonatomic) NSString *nameForBasicSkillTemplate;
@property (nonatomic) NSArray *namesForSubSkillTemplates;

+(SkillTemplate *)newSkillTemplateWithDocPath:(NSString *)docPath withContext:(NSManagedObjectContext *)context;

+(void)saveData:(SkillTemplate *)skillTemplate toPath:(NSString *)docPath;
+(void)deleteDocToPath:(NSString *)docPath;

+(NSMutableArray *)loadSkillTemplates;

+(NSString *)getPrivateDocsDir;

@end
