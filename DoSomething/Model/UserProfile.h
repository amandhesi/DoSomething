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

@interface UserProfile : NSObject

@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSNumber *fbid;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic) NSUInteger age;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSMutableArray *eventsLiked;
@property (nonatomic, strong) NSMutableArray *usersLiked;
@property (nonatomic, strong) NSMutableArray *usersRejected;
@property (nonatomic, strong) PFObject *object;

- (instancetype)initWithPFObject:(PFObject *)object;
+ (void)loadCurrentUserFromParseWithBlock:(void(^)(UserProfile *, NSError *, NSInteger))block;
- (void) saveToParseWithBlock:(void(^)(NSError *))block;
- (void) saveToParseIncludingImagesWithBlock:(void(^)(NSError *))block;

+ (void)createSomeArtificialUsers;

@end
