//
//  SkillLevelsSet.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 25.06.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataClass.h"


@interface SkillLevelsSet : CoreDataClass

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * name;

@end
