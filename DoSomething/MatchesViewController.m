//
//  MatchesViewController.m
//  DoSomething
//
//  Created by Aman Dhesi on 7/28/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "MatchesViewController.h"

@interface MatchesViewController ()
@property (nonatomic, strong) NSMutableArray *matchesInBuffer;
@property (nonatomic, strong) UserProfile *currentMatch;
@property (weak, nonatomic) IBOutlet UILabel *nameAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) UserProfile *userProfile;
@end

@implementation MatchesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Query potential matches from Parse and load them into loadedMatches
    
    [self doInitialSetup];
}

- (NSMutableArray *)matchesInBuffer
{
    if(!_matchesInBuffer)
        _matchesInBuffer = [[NSMutableArray alloc] init];
    return _matchesInBuffer;
}

// Initial setup involves loading the user's profile info
// from the backend
- (void)doInitialSetup
{
    self.userProfile = [UserProfile currentUser];
    [self getPotentialMatches];
}

- (void)getPotentialMatches
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    [query whereKey:@"eventsLiked" containedIn:self.userProfile.eventsLiked];
    
    // must do string comparison on object id unfortunately
    NSMutableSet *alreadySwiped = [[NSMutableSet alloc] initWithArray:self.userProfile.usersLiked];
    [alreadySwiped addObjectsFromArray:self.userProfile.usersRejected];
    [alreadySwiped addObject:self.userProfile.object.objectId];
    [query whereKey:@"objectId" notContainedIn:[alreadySwiped allObjects]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if(!error)
        {
            for (PFObject *object in objects)
            {
                UserProfile *profile = [[UserProfile alloc] initWithPFObject:object];
                [self.matchesInBuffer addObject:profile];
            }
            [self loadNext];
        }
        else
            NSLog(@"Error : %@", error);
    }];
    
}

- (IBAction)likeButtonTouchHandler:(UIButton *)sender
{
    if(self.currentMatch)
    {
        [self.userProfile likeUser:self.currentMatch withBlock:^(NSError *error) {}];
        [self.userProfile isMutualLike:self.currentMatch withBlock:^(NSError *error, BOOL isMutualLike)
        {
            if (isMutualLike)
            {
                // Mutual like found! Handle it here.
                // Might need to use something like PubNub to send a message to the other user
                UIAlertView *messageAlert = [[UIAlertView alloc]
                                             initWithTitle:@"Match!" message:[NSString stringWithFormat:@"You've just matched with %@", self.currentMatch.firstname] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [messageAlert show];
            }
        }];
        [self loadNext];
     }
}

- (IBAction)passButtonTouchHandler:(UIButton *)sender
{
    if(self.currentMatch)
    {
        [self.userProfile rejectUser:self.currentMatch withBlock:^(NSError *error) {}];
        [self loadNext];
    }
}

- (void)loadNext
{
    self.currentMatch = [self.matchesInBuffer firstObject];
    if(self.currentMatch)
    {
        self.nameAgeLabel.text = [NSString stringWithFormat:@"%@, %d", self.currentMatch.firstname, self.currentMatch.age];
        self.bioLabel.text = self.currentMatch.bio;
        [self.bioLabel sizeToFit];
        [self.matchesInBuffer removeObject:self.currentMatch];
        __block int i = 0;
        for (PFFile *imageFile in self.currentMatch.object[@"images"])
        {
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
             {
                 if(!error)
                 {
                     [self.currentMatch.images addObject:data];
                     if(i==0) self.profilePictureImageView.image = [UIImage imageWithData:self.currentMatch.images[0]];
                     i++;
                 }
                 else
                     NSLog(@"Error: %@", error);
             }];
        }
    }
    else
    {
        self.nameAgeLabel.text = @"No more matches available";
        self.bioLabel.text = @"";
        self.profilePictureImageView.image = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
