//
//  DoSomethingFirstViewController.m
//  DoSomething
//
//  Created by Aman Dhesi on 7/21/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameAgeLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioTextField;
@property (strong, nonatomic) UserProfile *profile;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) BackendHelper *backendHelper;
@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkFacebookAuth];
    //[UserProfile createSomeArtificialUsers];
    //[UserProfile makeEveryoneLikeAllEvents];
}

- (BackendHelper *)backendHelper
{
    if(!_backendHelper)
        _backendHelper = [[BackendHelper alloc] init];
    return _backendHelper;
}

// Initial setup involves loading the user's profile info
// from the backend
-(void)doInitialSetup
{
    if(!self.profile)
    {
        [UserProfile loadCurrentUserFromParseWithBlock:^(UserProfile *profile, NSError * error, NSInteger i)
        {
            if(!error)
            {
                if(i==-1)
                {
                    self.profile = profile;
                    self.nameAgeLabel.text = [NSString stringWithFormat:@"%@, %d", self.profile.firstname, self.profile.age];
                    self.bioTextField.text = self.profile.bio;
                }
                else if(i==0)
                {
                    self.profilePictureImageView.image = [UIImage imageWithData:self.profile.images[0]];
                }
            }
            else
                NSLog(@"Error: %@", error);
        }];
    }

}


- (void)checkFacebookAuth
{
    if (!([PFUser currentUser] && // Check if a user is cached
          [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])) // Check if user is linked to Facebook
        [self goToLoginScreen];
    else
    {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                NSLog(@"FB authentication succesful");
                [self doInitialSetup];
            }
            else
                [self.backendHelper handleAuthError:error];
        }];
    }
}

- (void)goToLoginScreen
{
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

- (IBAction)logoutButtonTouchHandler:(UIButton *)sender
{
    // Logout and Modal seque to login screen
    [PFUser logOut];
    [self goToLoginScreen];
}

@end
