//
//  LoginViewController.m
//  DoSomething
//
//  Created by Aman Dhesi on 7/24/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (NSArray *)permissionsRequired
{
    return @[ @"user_about_me", @"user_friends", @"user_birthday", @"user_photos", @"user_likes"];
}

- (IBAction)loginButtonTouchHandler:(UIButton *)sender
{
    NSArray *permissionsArray = [LoginViewController permissionsRequired];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user)
        {
            if (!error) NSLog(@"Uh oh. The user cancelled the Facebook login.");
             else NSLog(@"Uh oh. An error occurred: %@", error);
        }
        else
        {
            if (user.isNew) NSLog(@"User with facebook signed up and logged in!");
            else NSLog(@"User with facebook logged in!");
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    }];
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
