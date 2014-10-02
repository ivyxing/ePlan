//
//  EventViewController.m
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "EventViewController.h"
#import "EventTaskViewController.h"
#import "Event.h"
#import "AppDelegate.h"

@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UITableView *eventTableView;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventTableView.delegate = self;
    self.eventTableView.dataSource = self;
    self.events = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Get access to the managed object context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Create a new object using the entity description.
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Create an error variable to pass to the execute method.
    NSError *error;
    // Retrieve results.
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil) {
        // Error handling, e.g. display error to user.
    }
    self.events = [array mutableCopy];
    [self.eventTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = [self.events[indexPath.row] title];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewEvent"]) {
        // Get access to the managed object context.
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        // Create a new object using the entity description.
        Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        EventTaskViewController *eventTaskViewController = [segue destinationViewController];
        eventTaskViewController.event = newEvent;
        [self.events addObject:newEvent];
    } else if ([segue.identifier isEqualToString:@"ExistingEvent"]) {
        EventTaskViewController *eventTaskViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.eventTableView.indexPathForSelectedRow;
        eventTaskViewController.event =self.events[selectedIndexPath.row];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
