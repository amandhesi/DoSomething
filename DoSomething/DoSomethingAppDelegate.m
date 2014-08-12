//
//  DoSomethingAppDelegate.m
//  DoSomething
//
//  Created by Aman Dhesi on 7/21/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "DoSomethingAppDelegate.h"


@implementation DoSomethingAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"9x9SI5qIIKpJvy7D4jl1slBprPxgSFgdhf8lbkwH"
                  clientKey:@"tEeyA3ZRNUFP28CpAXgiH0SjIdmQ4YA0uyRmMAo2"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    [PubNub setDelegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
    return wasHandled;
}
							
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
}

- (void)pubnubClient:(PubNub *)client didConnectToOrigin:(NSString *)origin {
    NSLog(@"DELEGATE: Connected to  origin: %@", origin);
}

- (void)pubnubClient:(PubNub *)client didSubscribeOnChannels:(NSArray *)channels {
    NSLog(@"DELEGATE: Subscribed to channel:%@", channels);
}
// #2 Delegate looks for message receive events
- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message {
    NSLog(@"DELEGATE: Message received.");
}

@end
