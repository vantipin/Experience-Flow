//
//  SkillTemplateDiskData.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 07.05.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillTemplate.h"


@interface SkillTemplateDataArchiver : NSObject <NSCoding>

+(SkillTemplate *)newSkillTemplateWithDocPath:(NSString *)docPath withContext:(NSManagedObjectContext *)context;

+(void)saveData:(SkillTemplate *)skillTemplate toPath:(NSString *)docPath;
+(void)deleteDocToPath:(NSString *)docPath;

+(NSMutableArray *)loadSkillTemplates;

+(NSString *)getPrivateDocsDir;

@end
