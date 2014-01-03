//
//  Feed.h
//  Snpptz
//
//  Created by David Wang on 5/22/10.
//  Copyright 2010 UDFI, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Blog : NSManagedObject {
	
}

@property (nonatomic, retain) NSNumber *blogID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *slug;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSNumber *isFollowing;
@property (nonatomic, retain) NSString *blogDescription;
@property (nonatomic, retain) NSString *smallIcon;
@property (nonatomic, retain) NSString *largeIcon;
@property (nonatomic, retain) NSMutableData *smallIconImage;
@property (nonatomic, retain) NSMutableData *largeIconImage;
@property (nonatomic, retain) NSNumber *isSmallIconImageAvailable;
@property (nonatomic, retain) NSNumber *isLargeIconImageAvailable;

+ (Blog *) createBlog:(NSDictionary *) blogInfo isFollowing:(BOOL) following;

@end

@interface Blog (CoreDataGeneratedAccessors)
- (void)addSnipsObject:(NSManagedObject *)value;
- (void)removeSnipsObject:(NSManagedObject *)value;
- (void)addSnips:(NSSet *)value;
- (void)removeSnips:(NSSet *)value;

- (void)downloadImage: (Blog *) blog;

@end


