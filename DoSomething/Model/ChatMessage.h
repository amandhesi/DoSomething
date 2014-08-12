//
//  ChatMessage.h
//  DoSomething
//
//  Created by Aman Dhesi on 8/7/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"

@interface ChatMessage : NSObject

@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, strong) UserProfile *senderProfile;
@property (nonatomic, strong) UserProfile *receiverProfile;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *timestamp;

- (BOOL)isSenderSelf;

@end
