//
//  SelectedChatViewController.h
//  DoSomething
//
//  Created by Aman Dhesi on 8/8/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "UserProfile.h"
#import "Chat.h"

@interface SelectedChatViewController : UIViewController<UIBubbleTableViewDataSource>

@property (strong, nonatomic) UserProfile *otherProfile;

@end
