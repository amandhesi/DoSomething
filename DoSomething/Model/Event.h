//
//  Event.h
//  DoSomething
//
//  Created by Aman Dhesi on 7/25/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) PFObject *object;

- (instancetype)initWithPFObject:(PFObject *)object;
+ (NSArray *)getAllForCurrentUserWithBlock:(void(^)(NSArray*, NSError *))block;
+ (void)createSomeArtificialEvents;

@end
