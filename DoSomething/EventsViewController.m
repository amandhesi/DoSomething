//
//  DoSomethingSecondViewController.m
//  DoSomething
//
//  Created by Aman Dhesi on 7/21/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "EventsViewController.h"

@interface EventsViewController ()
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSArray *eventNames;
@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;
@end

@implementation EventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [Event getAllForCurrentUserWithBlock:^(NSArray *events, NSError *error) {
        if(!error)
        {
            self.events = events;
            NSMutableArray *eventNames = [[NSMutableArray alloc] init];
            for (Event *event in events)
                 [eventNames addObject:event.name];
            self.eventNames = eventNames;
            [self.eventsTableView reloadData];
        }
        else
            NSLog(@"Error: %@", error);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.eventNames objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"first"];
    return cell;
}

@end
