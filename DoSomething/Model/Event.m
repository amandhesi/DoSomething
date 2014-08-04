//
//  Event.m
//  DoSomething
//
//  Created by Aman Dhesi on 7/25/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "Event.h"

@implementation Event

- (instancetype)initWithPFObject:(PFObject *)object
{
    self = [super init];
    if (self)
    {
        self.object = object;
        self.name = object[@"name"];
        self.location = object[@"location"];
        self.time = object[@"time"];
        self.images = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSArray *)getAllForCurrentUserWithBlock:(void(^)(NSArray *, NSError *))block
{
    // need logic here to determine which events to get, depending on user's location and interests
    // for now, just get them all
    // for now, don't get images
    __block NSMutableArray *events = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for(PFObject *object in objects)
            {
                Event *event = [[Event alloc] initWithPFObject:object];
                [events addObject:event];
            }
            block(events, error);
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            block(events, error);
        }
    }];

    return events;
}

+ (void)createSomeArtificialEvents
{
    Event *event1 = [[Event alloc] init];
    Event *event2 = [[Event alloc] init];
    Event *event3 = [[Event alloc] init];
    Event *event4 = [[Event alloc] init];
    Event *event5 = [[Event alloc] init];
    
    event1.name = @"Party in the USA";
    event1.location = @"In the USA";
    event1.time = @"All the time";
    event1.images = [@[] mutableCopy];
    event1.object = [PFObject objectWithClassName:@"Event"];
    
    event2.name = @"Free Movie";
    event2.location = @"Bryant Park";
    event2.time = @"Tonight at 8:00";
    event2.images = [@[] mutableCopy];
    event2.object = [PFObject objectWithClassName:@"Event"];
    
    event3.name = @"Shakespeare in the Park";
    event3.location = @"Central Park";
    event3.time = @"Tomorrow at 6:00";
    event3.images = [@[] mutableCopy];
    event3.object = [PFObject objectWithClassName:@"Event"];
    
    event4.name = @"Happy Hour at The Bourgeois Pig";
    event4.location = @"E 7th bw 1st and Ave A";
    event4.time = @"Saturday 5:00-7:00";
    event4.images = [@[] mutableCopy];
    event4.object = [PFObject objectWithClassName:@"Event"];
    
    event5.name = @"Exhibit Opening at the Tenement Museum";
    event5.location = @"Lower East Side";
    event5.time = @"Sunday";
    event5.images = [@[] mutableCopy];
    event5.object = [PFObject objectWithClassName:@"Event"];
    
    [event1 saveToParseWithBlock:^(NSError *error) {}];
    [event2 saveToParseWithBlock:^(NSError *error) {}];
    [event3 saveToParseWithBlock:^(NSError *error) {}];
    [event4 saveToParseWithBlock:^(NSError *error) {}];
    [event5 saveToParseWithBlock:^(NSError *error) {}];
}

- (void) saveToParseWithBlock:(void(^)(NSError *))block
{
    self.object[@"name"] = self.name;
    self.object[@"location"] = self.location;
    self.object[@"time"] = self.time;
    self.object[@"images"] = self.images;
    [self.object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
            NSLog(@"%@", @"Event object saved");
    }];
}

+ (void)makeEveryoneLikeAllEvents
{
    
}

@end
