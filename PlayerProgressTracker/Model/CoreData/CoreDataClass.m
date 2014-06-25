//
//  CoreDataClass.m
//  BookShelf
//
//  Created by Vlad Antipin on 09.12.13.
//  Copyright (c) 2013 VolcanoSoft. All rights reserved.
//

#import "CoreDataClass.h"

@implementation CoreDataClass

+ (NSArray *)fetchRequestForObjectName:(NSString *)objName withPredicate:(NSPredicate *)predicate withContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = [NSEntityDescription entityForName:objName inManagedObjectContext:context];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *objPool = [context executeFetchRequest:request error:&error];
    
    if (!error)
    {
        return objPool;
    }
    
    return nil;
}

+ (BOOL)saveContext:(NSManagedObjectContext *)context;
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = context;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges])
        {
            if (![managedObjectContext save:&error])
            {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
                
                return false;
            }
            else
            {
                //save succeed
                
            }
        }
        else
        {
            NSLog(@"Context hasn't changed");
        }
    }
    
    return true;
}


+ (BOOL)clearEntityForNameWithObjName:(NSString *)name withPredicate:(NSPredicate *)predicate withGivenContext:(NSManagedObjectContext *)context
{
    
    NSArray *objectsPool = [self fetchRequestForObjectName:name withPredicate:predicate withContext:context];
    
    if (objectsPool.count > 0 )
    {
        for (id obj in objectsPool)
        {
            [context deleteObject:obj];
        }
        [self saveContext:context];
        return true;
        
    }
    return false;
}


+ (NSString *)standartDateFormat:(NSTimeInterval)date
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //[dateFormatter setDateFormat:@"dd.MM.YYYY hh:mm"];
    NSString *dateString = [NSString stringWithFormat:@"%f",date];//[dateFormatter stringFromDate:date];
    
    return dateString;
}
@end
