//
//  BackendHelper.h
//  DoSomething
//
//  Created by Aman Dhesi on 7/25/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//
// This is a helper class that handles all aspects
// of connecting to Parse (both read & write)

@class UserProfile;
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "UserProfile.h"

@interface BackendHelper : NSObject

- (UserProfile *)getUserProfile;
- (UserProfile *)getUserProfileWithId: (NSNumber *)id;
- (void)handleAuthError:(NSError *)error;
+ (int)calculateAge:(NSString *)birthday;


@end
