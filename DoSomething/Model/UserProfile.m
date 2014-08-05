//
//  UserProfile.m
//  DoSomething
//
//  Created by Aman Dhesi on 7/25/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "UserProfile.h"

@interface UserProfile()
@property (nonatomic, strong) BackendHelper *backendHelper;
@property (nonatomic, strong) NSMutableData *imageData;
@end


@implementation UserProfile

- (BackendHelper *)backendHelper
{
    if(!_backendHelper)
        _backendHelper = [[BackendHelper alloc] init];
    return _backendHelper;
}

- (instancetype) initWithPFObject:(PFObject *)object
{
    self = [super init];
    if(self)
    {
        self.object = object;
        self.firstname = object[@"firstname"];
        self.fbid = object[@"fbid"];
        self.age = [object[@"age"] integerValue];
        self.gender = object[@"gender"];
        self.bio = object[@"bio"];
        self.eventsLiked = [[NSMutableArray alloc] initWithArray: object[@"eventsLiked"]];
        self.usersLiked = [[NSMutableArray alloc] initWithArray:object[@"usersLiked"]];
        self.usersRejected = [[NSMutableArray alloc] initWithArray: object[@"usersRejected"]];
        self.images = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype) initWithFBResult:(id)result
{
    self = [super init];
    if(self)
    {
        self.object = [PFObject objectWithClassName:@"UserProfile"];
        self.firstname = result[@"first_name"];
        if(result[@"bio"]) self.bio = result[@"bio"];
        else self.bio = @"";
        if(result[@"gender"]) self.gender = result[@"gender"];
        else result[@"gender"] = @"unknown";
        self.fbid = result[@"id"];
        if(result[@"birthday"]) self.age = [BackendHelper calculateAge:result[@"birthday"]];
        else self.age = -1;
        self.eventsLiked = [[NSMutableArray alloc] init];
        self.usersLiked = [[NSMutableArray alloc] init];
        self.usersRejected = [[NSMutableArray alloc] init];
        self.images = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (void)loadCurrentUserFromParseWithBlock:(void(^)(UserProfile *, NSError *, NSInteger))block
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    [query whereKey:@"PFUser" equalTo:[PFUser currentUser]];
    //[query includeKey:@"eventsLiked"];
    //[query includeKey:@"usersLiked"];
    //[query includeKey:@"usersRejected"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            PFObject *object = [objects firstObject];
            if(object)
            {
                UserProfile *profile = [[UserProfile alloc] initWithPFObject:object];
                block(profile, error, -1);
                __block int i = 0;
                for (PFFile *imageFile in object[@"images"])
                {
                    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                    {
                        if(!error)
                        {
                            [profile.images addObject:data];
                            block(profile, error,i);
                            i++;
                        }
                        else
                        {
                            NSLog(@"Error: %@", error);
                            block(profile,error,0);
                        }
                    }];
                }
            }
            else
            {
                [UserProfile loadCurrentUserFromFacebookWithBlock:^(UserProfile *profile, NSError *error, NSInteger i)
                {
                    if(!error)
                        [profile saveToParseIncludingImagesWithBlock:^(NSError *error) { }];
                    block(profile, error,i);
                }];

            }
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            block(nil,error,0);
        }
    }];

}

+ (void)loadCurrentUserFromFacebookWithBlock:(void(^)(UserProfile *, NSError *, NSInteger))block
{
    [FBRequestConnection startWithGraphPath:@"/me?fields=id,first_name,bio,gender,birthday,picture.height(300)" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
    {
        if (!error)
        {
            UserProfile *profile = [[UserProfile alloc] initWithFBResult:result];
            profile.object[@"PFUser"] = [PFUser currentUser];
            block(profile, error, -1);
            __block int i = 0;
            NSURL *pictureURL = [NSURL URLWithString: result[@"picture"][@"data"][@"url"]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL                                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy                                                                                  timeoutInterval:2.0f];            
            // Run network request asynchronously
            MyConnection *connection = [[MyConnection alloc] initWithRequest:urlRequest];
            [connection setCompletionBlock:^(NSData *data, NSError *error)
            {
                if(!error)
                {
                    [profile.images addObject:data];
                    block(profile, error, i);
                    i++;
                }
            }];
            [connection start];
        }
        else
            [[[BackendHelper alloc] init] handleAuthError:error];
    }];
}

- (void) refreshObjectWithBlock:(void(^)(NSError *))block
{
    block(nil);
}

- (void) saveToParseWithBlock:(void(^)(NSError *))block
{
    self.object[@"firstname"] = self.firstname;
    self.object[@"fbid"] = self.fbid;
    self.object[@"age"] = [NSString stringWithFormat:@"%d",self.age];
    self.object[@"gender"] = self.gender;
    self.object[@"bio"] = self.bio;
    self.object[@"eventsLiked"] = self.eventsLiked;
    self.object[@"usersLiked"] = self.usersLiked;
    self.object[@"usersRejected"] = self.usersRejected;
    [self.object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(error);
    }];
}

- (void) saveToParseIncludingImagesWithBlock:(void(^)(NSError *))block
{
    self.object[@"firstname"] = self.firstname;
    self.object[@"fbid"] = self.fbid;
    self.object[@"age"] = [NSString stringWithFormat:@"%d",self.age];
    if(self.gender) self.object[@"gender"] = self.gender;
    self.object[@"bio"] = self.bio;
    self.object[@"eventsLiked"] = self.eventsLiked;
    self.object[@"usersLiked"] = self.usersLiked;
    self.object[@"usersRejected"] = self.usersRejected;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    int i = 0;
    for (NSData *data in self.images)
    {
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"image%d.jpg", i] data:data];
        [images addObject:imageFile];
        i++;
    }
    self.object[@"images"] = images;
    [self.object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(error);
    }];
}


- (void)likeUser:(UserProfile *)userProfile withBlock:(void(^)(NSError *))block
{
    [self.usersLiked addObject:userProfile.object.objectId];
    [self saveToParseWithBlock:block];
}

- (void)rejectUser:(UserProfile *)userProfile withBlock:(void(^)(NSError *))block
{
    [self.usersRejected addObject:userProfile.object.objectId];
    [self saveToParseWithBlock:block];
}

- (void)likeEvent:(Event *)event withBlock:(void(^)(NSError *))block
{
    [self.eventsLiked addObject:event.object.objectId];
    [self saveToParseWithBlock:block];
}

- (void)unlikeEvent:(Event *)event withBlock:(void(^)(NSError *))block
{
    [self.eventsLiked removeObjectAtIndex:[self.eventsLiked indexOfObject:event.object.objectId]];
    [self saveToParseWithBlock:block];
}

- (void)isMutualLike:(UserProfile *)userProfile withBlock:(void(^)(NSError *, BOOL))block
{
    if([userProfile.usersLiked containsObject:self.object.objectId])
    {
        // match found!
        block(nil, YES);
    }
    [userProfile refreshObjectWithBlock:^(NSError *error)
    {
        if(!error)
        {
            if([userProfile.usersLiked containsObject:self.object.objectId])
            {
                // match found after refreshing!
                block(error, YES);
            }
            else
                block(error, NO);
        }
        else
        {
            NSLog(@"Error: %@", error);
            block(error, NO);
        }
    }];
}



// -------------------------------------------------------------------------
// TESTING PURPOSES
// -------------------------------------------------------------------------

+ (void)createSomeArtificialUsers
{
    //Get 20 of current user's friends from FB and make profiles for each one of them
    NSArray *friends = [LongAssFriendsArray getLongAssFriendsArray];
    for (id friend in friends)
    {
        PFUser *user = [PFUser user];
        user.username = friend[@"id"];
        user.password = @"password";
        user.email = [NSString stringWithFormat:@"%@@example.com", friend[@"id"]];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                UserProfile *profile = [[UserProfile alloc] initWithFBResult:friend];
                profile.object[@"PFUser"] = user;
                NSURL *pictureURL = [NSURL URLWithString: friend[@"picture"]];
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL                                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy                                                                                  timeoutInterval:10.0f];
                // Run network request asynchronously
                MyConnection *connection = [[MyConnection alloc] initWithRequest:urlRequest];
                [connection setCompletionBlock:^(NSData *data, NSError *error)
                 {
                     if(!error)
                     {
                         [profile.images addObject:data];
                         [profile saveToParseIncludingImagesWithBlock:^(NSError *error) {}];
                     }
                     else
                         NSLog(@"Error: %@", error);
                 }];
                [connection start];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@", errorString);
            }
        }];
    }
}

+ (void) makeEveryoneLikeAllEvents
{
    NSMutableArray *allEvents = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if(!error)
        {
            for (PFObject *object in objects)
                [allEvents addObject:object.objectId];
            PFQuery *query2 = [PFQuery queryWithClassName:@"UserProfile"];
            [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
             {
                 if(!error)
                 {
                     for (PFObject *object in objects)
                     {
                         object[@"eventsLiked"] = allEvents;
                         [object saveInBackground];
                     }
                 }
             }];
        }
        
    }];
    
}


@end
