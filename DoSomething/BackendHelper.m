//
//  BackendHelper.m
//  DoSomething
//
//  Created by Aman Dhesi on 7/25/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "BackendHelper.h"

@implementation BackendHelper

// Get profile of current user from backend
// If it doesn't exist in Parse, load from Facebook
- (UserProfile *)getUserProfile
{
    
    return nil;
}

- (void)saveProfile:(UserProfile *)userProfile
{
    
}

- (UserProfile *)getUserProfileWithId:(NSNumber *)id
{
    return nil;
}

- (UserProfile *)createProfileFromFB
{
    return nil;
}

- (void)handleAuthError:(NSError *)error
{
    NSString *alertText;
    NSString *alertTitle;
    
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
    {
        // Error requires people using you app to make an action outside your app to recover
        alertTitle = @"Something went wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        [self showMessage:alertText withTitle:alertTitle];
        
    }
    else
    {
        // You need to find more information to handle the error within your app
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            //The user refused to log in into your app, either ignore or...
            alertTitle = @"Login cancelled";
            alertText = @"You need to login to access this part of the app";
            [self showMessage:alertText withTitle:alertTitle];
            
        } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
            // We need to handle session closures that happen outside of the app
            alertTitle = @"Session Error";
            alertText = @"Your current session is no longer valid. Please log in again.";
            [self showMessage:alertText withTitle:alertTitle];
            
        } else {
            // All other errors that can happen need retries
            // Show the user a generic error message
            alertTitle = @"Something went wrong";
            alertText = @"Please retry";
            [self showMessage:alertText withTitle:alertTitle];
        }
    }
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)scrapeFriendsFromFB
{
    [FBRequestConnection startWithGraphPath:@"" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
       if(!error)
       {
           
       }
       else
       {
            
       }
    }];
}

- (void)createSomeEvents
{
    
}

+ (int)calculateAge:(NSString *)birthday
{
    NSArray *birth = [birthday componentsSeparatedByString:@"/"];
    int m1 = [birth[0] integerValue];
    int d1 = [birth[1] integerValue];
    if([birth count] < 3) return -1;
    int y1 = [birth[2] integerValue];
    NSDate *now = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:now];
    int m2 = [components month];
    int d2 = [components day];
    int y2 = [components year];
    int delm = m2-m1;
    int deld = d2-d1;
    int dely = y2-y1;
    if(delm >0) return dely;
    else if(delm == 0 && deld >=0) return dely;
    else return dely-1;
}

@end
