//
//  CoreDataClass.h
//  BookShelf
//
//  Created by Vlad Antipin on 09.12.13.
//  Copyright (c) 2013 VolcanoSoft. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CoreDataClass : NSManagedObject

+ (NSArray *)fetchRequestForObjectName:(NSString *)objName withPredicate:(NSPredicate *)predicate withContext:(NSManagedObjectContext *)context;
+ (BOOL)clearEntityForNameWithObjName:(NSString *)name withPredicate:(NSPredicate *)predicate withGivenContext:(NSManagedObjectContext *)context;
+ (BOOL)saveContext:(NSManagedObjectContext *)context;
+ (NSString *)generateId;

+ (NSString *)standartDateFormat:(NSTimeInterval)date;
@end
