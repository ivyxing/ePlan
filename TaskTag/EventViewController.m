//
//  EventViewController.m
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "EventViewController.h"
#import "TaskViewController.h"
#import "EventInfoTableViewController.h"
#import "Event.h"
#import "AppDelegate.h"
#import "ServerBackend.h"

@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UITableView *eventTableView;
@property (strong, nonatomic) NSMutableArray *events;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.events = [NSMutableArray array];
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Pull events from server.
    ServerBackend *sharedServerBackend = [ServerBackend sharedServerBackend];
    [sharedServerBackend import];
    
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
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    cell.textLabel.text = [self.events[indexPath.row] title];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewEvent"]) {
        // Get access to the managed object context.
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        // Create a new object using the entity description.
        Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        EventInfoTableViewController *eventInfoTableViewController = [segue destinationViewController];
        eventInfoTableViewController.event = newEvent;
        [eventInfoTableViewController.event addPersonsObject:self.currentUser];
        [self.events addObject:newEvent];
    } else if ([segue.identifier isEqualToString:@"ExistingEvent"]) {
        TaskViewController *eventTaskViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.eventTableView.indexPathForSelectedRow;
        eventTaskViewController.event = self.events[selectedIndexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Get and delete object
    Event *event = [self.events objectAtIndex:indexPath.row];
    [context deleteObject:event];
    // Create an error variable to pass to the save method.
    NSError *error = nil;
    // Attempt to save the context and persist our changes.
    [context save:&error];
    if (error) {
        //Error
    }
    
    // Delete entry in the array.
    [self.events removeObjectAtIndex:indexPath.row];
    // Delete entry in the UI.
    [self.eventTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
