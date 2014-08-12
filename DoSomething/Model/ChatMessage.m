//
//  ChatMessage.m
//  DoSomething
//
//  Created by Aman Dhesi on 8/7/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

- (BOOL)isSenderSelf
{
    if ([self.senderProfile.object.objectId isEqualToString:[UserProfile currentUser].object.objectId]) return YES;
    return NO;
}

@end
