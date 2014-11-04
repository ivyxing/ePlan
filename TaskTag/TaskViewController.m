//
//  EventTaskViewController.m
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskDetailViewController.h"
#import "EventInfoTableViewController.h"
#import "TaskDetailViewController.h"
#import "Task.h"
#import "Event.h"
#import "AppDelegate.h"


@interface TaskViewController ()

@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;

@end


@implementation TaskViewController

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.taskTableView reloadData];
    self.eventTitle.text = self.event.title;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Save event name and image.
    self.event.title = self.eventTitle.text;
  
    // Get the NSManagedObject context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Create an error variable to pass to the save method.
    NSError *error = nil;
    // Attempt to save the context and persist our changes.
    [context save:&error];
    if (error) {
        // Error handling, e.g. display error to user.
    }
}

#pragma mark - User Interaction

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.taskNameTextField) {
        // Hide keyboard.
        [self.taskNameTextField resignFirstResponder];
        // Create new task.
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        // Create a new object using the entity description.
        Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
        task.name = textField.text;
        task.timeStamp = [NSDate date];
        [self.event addTasksObject:task];
        // Clear the text field.
        [textField setText:@""];
        [self.taskTableView reloadData];
    }
    return YES;
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.event.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    NSArray *tasksArray = [self tasksSetToSortedArray:self.event.tasks];
    cell.textLabel.text = [tasksArray[indexPath.row] name];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EventInfo"]) {
        EventInfoTableViewController *eventInfoTableViewController = [segue destinationViewController];
        eventInfoTableViewController.event = self.event;
    } else if ([segue.identifier isEqualToString:@"ShowTaskDetail"]) {
        TaskDetailViewController *taskDetailViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.taskTableView.indexPathForSelectedRow;
        NSArray *tasksArray = [self tasksSetToSortedArray:self.event.tasks];
        taskDetailViewController.task = tasksArray[selectedIndexPath.row];
        taskDetailViewController.task.parentEvent = self.event;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Get and delete object
    NSArray *tasksArray = [self tasksSetToSortedArray:self.event.tasks];
    Task *task = [tasksArray objectAtIndex:indexPath.row];
    [context deleteObject:task];
    // Create an error variable to pass to the save method.
    NSError *error = nil;
    // Attempt to save the context and persist our changes.
    [context save:&error];
    if (error) {
        //Error
    }
    
    // Delete entry in the array.
    [self.event removeTasksObject:task];
    // Delete entry in the UI.
    [self.taskTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Data Type Convertion

- (NSArray*)tasksSetToSortedArray:(NSSet*)tasksSet {
    NSArray *tasksArray = [tasksSet allObjects];
    NSArray *sortedArray = [tasksArray sortedArrayUsingComparator:^NSComparisonResult(Task* a, Task* b) {
        return [a.timeStamp compare:b.timeStamp];
    }];
    
    return sortedArray;
}

@end
