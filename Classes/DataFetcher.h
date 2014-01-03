//
//  FlickrFetcher.h
//  Flickr3
//
//  Created by Alan Cannistraro on 11/20/09.
//  Copyright 2009 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataFetcher : NSObject {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

// Returns the 'singleton' instance of this class
+ (id)sharedInstance;

// Checks to see if any database exists on disk
- (BOOL)databaseExists;

// Returns the NSManagedObjectContext for inserting and fetching objects into the store
- (NSManagedObjectContext *)managedObjectContext;

// Returns an array of objects already in the database for the given Entity Name and Predicate
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate;

// Returns an NSFetchedResultsController for a given Entity Name and Predicate and Sort Descriptor
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate withSortDescriptor:(NSSortDescriptor *) sortDescriptor;

// Returns an NSFetchedResultsController for a given Entity Name and Predicate
- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate;


@end
