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
    
    PNConfiguration *myConfig = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com"
                    publishKey:@"pub-c-e8120ee5-ac19-48bc-9da6-957929f74e39"
                  subscribeKey:@"sub-c-8721286c-1c2a-11e4-a1db-02ee2ddab7fe"
                     secretKey:@"sec-c-OTk2N2U1OGUtNTE2Yi00ZDQ0LTk2OGYtMjA0N2JlYzMzODNi"];
    
    
    [PubNub setConfiguration:myConfig];
    
    [PubNub connect];
    
    PNChannel *my_channel = [PNChannel channelWithName:@"a"
                                 shouldObservePresence:YES];
    
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self withCallbackBlock:^(NSString *origin, BOOL connected, PNError *connectionError){
        if (connected)
        {
            NSLog(@"OBSERVER: Successful Connection!");
            [PubNub subscribeOnChannel:my_channel];
            [PubNub unsubscribeFromChannel:my_channel];
        }
        else if (!connected || connectionError)
        {
            NSLog(@"OBSERVER: Error %@, Connection Failed!", connectionError.localizedDescription);
        }
    }];
    
    [[PNObservationCenter defaultCenter] addClientChannelSubscriptionStateObserver:self withCallbackBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *error){
        switch (state) {
            case PNSubscriptionProcessSubscribedState:
                NSLog(@"OBSERVER: Subscribed to Channel: %@", channels[0]);
                break;
            case PNSubscriptionProcessNotSubscribedState:
                NSLog(@"OBSERVER: Not subscribed to Channel: %@, Error: %@", channels[0], error);
                break;
            case PNSubscriptionProcessWillRestoreState:
                NSLog(@"OBSERVER: Will re-subscribe to Channel: %@", channels[0]);
                break;
            case PNSubscriptionProcessRestoredState:
                NSLog(@"OBSERVER: Re-subscribed to Channel: %@", channels[0]);
                break;
        }
    }];
    
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self withBlock:^(PNMessage *message) {
        NSLog(@"OBSERVER: Channel: %@, Message: %@", message.channel.name, message.message);
    }];
    
    [[PNObservationCenter defaultCenter] addClientChannelUnsubscriptionObserver:self withCallbackBlock:^(NSArray *channel, PNError *error) {
        if ( error == nil )
        {
            NSLog(@"OBSERVER: Unsubscribed from Channel: %@", channel[0]);
        }
        else
        {
            NSLog(@"OBSERVER: Unsubscribed from Channel: %@, Error: %@", channel[0], error);
        }
    }];
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
