//
//  AppDelegate.m
//  pillbox
//
//  Created by Jordi Coscolla on 20/04/13.
//  Copyright (c) 2013 Jordi Coscolla. All rights reserved.
//

#import "AppDelegate.h"
#import "PillCrudController.h"
#import "PillListViewController.h"
#import "NextPillViewController.h"
#import <GAI.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //PillCrudController *rootViewController = [[PillCrudController alloc] initWithNibName:@"PillCrudController" bundle:nil];
    //PillListViewController *rootViewController = [[PillListViewController alloc] initWithStyle:UITableViewStylePlain];
    NextPillViewController *rootViewController = [[NextPillViewController alloc] initWithNibName: @"NextPillViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: rootViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [GAI sharedInstance].debug = NO;
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-40317091-1"];
    
    if([launchOptions count]>0)
        [tracker sendEventWithCategory:@"reminder"
                        withAction:@"show"
                         withLabel:@""
                         withValue:[NSNumber numberWithInt:100]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSError *error;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [app managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Pill" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *pills = [context executeFetchRequest:fetchRequest error:&error];
    [self createLocalNotifications: pills];
}

-(void) createLocalNotifications:(NSArray*) pills
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSMutableArray *pillsDates = [[NSMutableArray alloc] init];
    
    for (Pill *pill in pills) {
        for (NSDate *date in [pill timeRemaining:pill.next_time nValues:64]) {
            [pillsDates addObject: @{@"pill": pill, @"date": date}];
        }
    }
    
    NSArray* pillsSorted = [pillsDates sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *d1 = [obj1 objectForKey:@"date"];
        NSDate *d2 = [obj1 objectForKey:@"date"];
        
        return [d1 compare: d2];
    }];
    
    for(int i = 0 ; i<64; i++)
    {
        NSDictionary *info = [pillsSorted objectAtIndex: i];
        Pill *pill = [info objectForKey: @"pill"];
        NSDate *date = [info objectForKey: @"date"];
        
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        notif.fireDate = date;
        NSString *format = NSLocalizedString(@"Time to take %@", @"");
        notif.alertBody = [NSString stringWithFormat: format , pill.name];
        NSDictionary *_info = @{@"name": pill.name};
        notif.userInfo = _info;
        notif.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification: notif];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"pillbox" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"pillbox.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
        //abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
