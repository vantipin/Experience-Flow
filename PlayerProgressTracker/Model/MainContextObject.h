//
//  ViewControllerWithCoreDataMethods.h
//  BookShelf
//
//  Created by Vlad Antipin on 09.12.13.
//  Copyright (c) 2013 VolcanoSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MainContextObject : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

+(MainContextObject *)sharedInstance;

+ (NSManagedObjectContext *)newManagedObjectContextWithPersistantStoreCoordinator:(NSPersistentStoreCoordinator *)persistentCoordinator;
+ (NSManagedObjectModel *)newManagedObjectModel;
+ (NSPersistentStoreCoordinator *)newPersistentStoreCoordinatorWithModel:(NSManagedObjectModel *)managedObjectModel;
+ (NSURL *)applicationDocumentsDirectory;

@end
