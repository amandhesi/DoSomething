//
//  UserProfile.h
//  DoSomething
//
//  Created by Aman Dhesi on 7/25/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "BackendHelper.h"
#import "MyConnection.h"
#import "LongAssFriendsArray.h"
#import "Event.h"

@interface UserProfile : NSObject

@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSNumber *fbid;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic) NSUInteger age;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *bio;
//  Right now, eventsLiked, usersLiked and usersRejected are arrays that contain strings that are the object id's of the relevant PFObjects.
//  An alternative would be to store the PFObjects themselves ie Parse pointers to events and users respectively (the .object property).
@property (nonatomic, strong) NSMutableArray *eventsLiked;
@property (nonatomic, strong) NSMutableArray *usersLiked;
@property (nonatomic, strong) NSMutableArray *usersRejected;
@property (nonatomic, strong) PFObject *object;

+ (UserProfile *)currentUser;
- (instancetype)initWithPFObject:(PFObject *)object;
+ (void)loadCurrentUserFromParseWithBlock:(void(^)(UserProfile *, NSError *, NSInteger))block;
- (void) saveToParseWithBlock:(void(^)(NSError *))block;
- (void) saveToParseIncludingImagesWithBlock:(void(^)(NSError *))block;

+ (void)createSomeArtificialUsers;
+ (void) makeEveryoneLikeAllEvents;

- (void)likeUser:(UserProfile *)userProfile withBlock:(void(^)(NSError *))block;

- (void)rejectUser:(UserProfile *)userProfile withBlock:(void(^)(NSError *))block;

- (void)likeEvent:(Event *)event withBlock:(void(^)(NSError *))block;

- (void)unlikeEvent:(Event *)event withBlock:(void(^)(NSError *))block;

- (void)isMutualLike:(UserProfile *)userProfile withBlock:(void(^)(NSError *, BOOL))block;

@end
