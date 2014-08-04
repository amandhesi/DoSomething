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
    if(!self.userProfile)
    {
        [UserProfile loadCurrentUserFromParseWithBlock:^(UserProfile *profile, NSError * error, NSInteger i)
         {
             if(!error)
             {
                 if(i==-1)
                 {
                     self.userProfile = profile;
                     [self getPotentialMatches];
                 }
             }
             else
                 NSLog(@"Error: %@", error);
         }];
    }
}

- (void)getPotentialMatches
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    //[query whereKey:@"eventsLiked" containedIn:self.userProfile.eventsLiked];
    NSMutableSet *alreadySwiped = [[NSMutableSet alloc] initWithArray:self.userProfile.usersLiked];
    [alreadySwiped addObjectsFromArray:self.userProfile.usersRejected];
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
        [self.userProfile.usersLiked addObject:self.currentMatch.object.objectId];
        [self.userProfile saveToParseWithBlock:^(NSError *error) {}];
        //if(self.currentMatch.usersLiked containsObject:<#(id)#>)
        
        [self loadNext];
     }
}

- (IBAction)passButtonTouchHandler:(UIButton *)sender
{
    if(self.currentMatch)
    {
        [self.userProfile.usersRejected addObject:self.currentMatch.object.objectId];
        [self.userProfile saveToParseWithBlock:^(NSError *error) {}];
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
