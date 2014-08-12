//
//  ChatsViewController.m
//  DoSomething
//
//  Created by Aman Dhesi on 7/28/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "ChatsViewController.h"

@interface ChatsViewController ()

@property (strong, nonatomic) UserProfile *userProfile;
@property (weak, nonatomic) IBOutlet UITableView *chatsTableView;
@property (strong, nonatomic) NSMutableArray *matches;
@property (strong, nonatomic) NSMutableArray *matchNames;

@end

@implementation ChatsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[Chat addSomeChats];
    self.userProfile = [UserProfile currentUser];
    self.matches = [[NSMutableArray alloc] init];
    self.matchNames = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    [query whereKey:@"objectId" containedIn:self.userProfile.matches];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             for (PFObject *object in objects)
             {
                 UserProfile *profile = [[UserProfile alloc] initWithPFObject:object];
                 NSLog(@"%@", profile.firstname);
                 [self.matches addObject:profile];
                 [self.matchNames addObject:profile.firstname];
             }
             [self.chatsTableView reloadData];
         }
         else
             NSLog(@"Error : %@", error);
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *chatCellIdentifier = @"ChatCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatCellIdentifier];
    }
    
    cell.textLabel.text = [self.matchNames objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"first"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectChatSegue"])
    {
        SelectedChatViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.chatsTableView indexPathForSelectedRow];
        destViewController.otherProfile = self.matches[indexPath.row];
    }
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
