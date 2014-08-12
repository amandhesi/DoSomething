//
//  Chat.h
//  DoSomething
//
//  Created by Aman Dhesi on 8/7/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"
#import "ChatMessage.h"

@interface Chat : NSObject

@property (nonatomic,strong) NSMutableArray *chatMessages;
@property (nonatomic, strong) UserProfile *selfProfile;
@property (nonatomic,strong) UserProfile *otherProfile;

+ (void)loadChatWithUser:(UserProfile *)otherProfile WithBlock:(void(^)(Chat *, NSError *))block;
+ (void)addSomeChats;
@end
