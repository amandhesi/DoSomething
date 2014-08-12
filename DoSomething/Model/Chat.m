//
//  Chat.m
//  DoSomething
//
//  Created by Aman Dhesi on 8/7/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "Chat.h"

@implementation Chat

- (NSMutableArray *)chatMessages
{
    if(!_chatMessages)
        _chatMessages = [[NSMutableArray alloc] init];
    return _chatMessages;
}

+ (void) loadChatWithUser:(UserProfile *)otherProfile WithBlock:(void(^)(Chat *, NSError *))block
{
    PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
    [query whereKey:@"selfProfile" equalTo:[UserProfile currentUser].object.objectId];
    [query whereKey:@"otherProfile" equalTo:otherProfile.object.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            PFObject *object = [objects firstObject];
            if(object)
            {
                Chat *chat = [[Chat alloc] init];
                chat.selfProfile = [UserProfile currentUser];
                chat.otherProfile = otherProfile;
                NSArray *chatMessages = object[@"chatMessages"];
                PFQuery *queryChatMessage = [PFQuery queryWithClassName:@"ChatMessage"];
                [queryChatMessage whereKey:@"objectId" containedIn:chatMessages];
                [queryChatMessage findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                {
                    if(!error)
                    {
                        for (PFObject *chatMessageObject in objects)
                        {
                            ChatMessage *chatMessage = [[ChatMessage alloc] init];
                            chatMessage.chatId = object.objectId;
                            if ([chatMessageObject[@"senderProfile"] isEqualToString: chat.selfProfile.object.objectId])
                            {
                                chatMessage.senderProfile = chat.selfProfile;
                                chatMessage.receiverProfile = chat.otherProfile;
                            }
                            else
                            {
                                chatMessage.senderProfile = chat.otherProfile;
                                chatMessage.receiverProfile = chat.selfProfile;
                            }
                                
                            chatMessage.text = chatMessageObject[@"text"];
                            chatMessage.timestamp = chatMessageObject[@"timestamp"];
                            [chat.chatMessages addObject:chatMessage];
                        }
                        block(chat, error);
                    }
                    else
                        block(nil, error);
                }];
            }
        }
        else
            block(nil, error);
    }];
}


//------------------------------------------------------------------------
// Testing purposes only
//------------------------------------------------------------------------

+ (void)addSomeChats
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    [query whereKey:@"objectId" containedIn:[UserProfile currentUser].matches];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             for (PFObject *object in objects)
             {
                 PFObject *chatMessage1 = [[PFObject alloc] initWithClassName:@"ChatMessage"];
                 chatMessage1[@"text"] = @"Hey, this is the first message";
                 chatMessage1[@"timestamp"] = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                 chatMessage1[@"senderProfile"] = [UserProfile currentUser].object.objectId;
                 chatMessage1[@"receiverProfile"] = object.objectId;
                 PFObject *chatMessage2 = [[PFObject alloc] initWithClassName:@"ChatMessage"];
                 chatMessage2[@"text"] = @"Hey, this is the second message";
                 chatMessage2[@"timestamp"] = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                 chatMessage2[@"senderProfile"] = object.objectId;
                 chatMessage2[@"receiverProfile"] =[UserProfile currentUser].object.objectId;
                 [chatMessage1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     [chatMessage2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         PFObject *chat = [[PFObject alloc] initWithClassName:@"Chat"];
                         chat[@"chatMessages"] = @[chatMessage1.objectId, chatMessage2.objectId];
                         chat[@"selfProfile"] = [UserProfile currentUser].object.objectId;
                         chat[@"otherProfile"] = object.objectId;
                         [chat saveInBackground];
                     }];
                 }];
             }
         }
         else
             NSLog(@"Error : %@", error);
     }];
}

@end
