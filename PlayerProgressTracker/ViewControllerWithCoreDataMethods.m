//
//  ViewControllerWithCoreDataMethods.m
//  BookShelf
//
//  Created by Vlad Antipin on 09.12.13.
//  Copyright (c) 2013 VolcanoSoft. All rights reserved.
//

#import "ViewControllerWithCoreDataMethods.h"

@interface ViewControllerWithCoreDataMethods ()

@end

@implementation ViewControllerWithCoreDataMethods

@synthesize managedObjectContext = thisManagedObjectContext;
@synthesize managedObjectModel = thisManagedObjectModel;
@synthesize persistentStoreCoordinator = thisPersistentStoreCoordinator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (thisManagedObjectContext == nil)
    {
        thisManagedObjectContext = [ViewControllerWithCoreDataMethods newManagedObjectContextWithPersistantStoreCoordinator:self.persistentStoreCoordinator];
    }
    
    return thisManagedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (thisManagedObjectModel == nil)
    {
        thisManagedObjectModel = [ViewControllerWithCoreDataMethods newManagedObjectModel];
    }
    return thisManagedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (thisPersistentStoreCoordinator == nil) {
        thisPersistentStoreCoordinator = [ViewControllerWithCoreDataMethods newPersistentStoreCoordinatorWithModel:[self managedObjectModel]];
    }
    
    return thisPersistentStoreCoordinator;
}

#pragma mark - Core Data manage methods
+ (NSManagedObjectContext *)newManagedObjectContextWithPersistantStoreCoordinator:(NSPersistentStoreCoordinator *)persistentCoordinator
{
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *coordinator = persistentCoordinator;
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

+ (NSManagedObjectModel *)newManagedObjectModel
{
    NSManagedObjectModel *managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

+ (NSPersistentStoreCoordinator *)newPersistentStoreCoordinatorWithModel:(NSManagedObjectModel *)managedObjectModel
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    NSURL *storeURL = [[ViewControllerWithCoreDataMethods applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
