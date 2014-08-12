//
//  SelectedChatViewController.m
//  DoSomething
//
//  Created by Aman Dhesi on 8/8/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "SelectedChatViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"

@interface SelectedChatViewController ()
@property (strong, nonatomic) UserProfile *selfProfile;
@property (strong, nonatomic) Chat *chat;
@property (weak, nonatomic) IBOutlet UIBubbleTableView *bubbleTable;
@property (strong, nonatomic) NSMutableArray *bubbleData;
//@property (weak, nonatomic) IBOutlet UIView *textInputView;
//@property (weak, nonatomic) IBOutlet UITextField *textInput;
@end

@implementation SelectedChatViewController

- (NSMutableArray *)bubbleData
{
    if(!_bubbleData)
        _bubbleData = [[NSMutableArray alloc] init];
    return _bubbleData;
}

- (void)setParameters
{
    self.bubbleTable.bubbleDataSource = self;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    self.bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    //self.bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    //self.bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setParameters];
    [Chat loadChatWithUser:self.otherProfile WithBlock:^(Chat *chat, NSError *error)
    {
        if(!error)
        {
            self.chat = chat;
            for (int i = [self.chat.chatMessages count]-1; i >=0; i--)
            {
                ChatMessage *chatMessage = (ChatMessage *)chat.chatMessages[i];
                NSBubbleData *bubble;
                if (chatMessage.isSenderSelf)
                {
                    bubble = [NSBubbleData dataWithText:chatMessage.text date:chatMessage.timestamp type:BubbleTypeMine];
                }
                else
                {
                    bubble = [NSBubbleData dataWithText:chatMessage.text date:chatMessage.timestamp type:BubbleTypeSomeoneElse];
                }
                [self.bubbleData addObject:bubble];
            }
            [self refreshChat];
        }
        else
            NSLog(@"Error : %@", error);
    }];
    
    //---------------------------------------------------------------------------
//    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
//    heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
//    
//    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
//    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
//    
//    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
//    replyBubble.avatar = nil;
//    
//    self.bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, photoBubble, replyBubble, nil];
}

- (void)refreshChat
{
    [self.bubbleTable reloadData];
}

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [self.bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [self.bubbleData objectAtIndex:row];
}


@end
