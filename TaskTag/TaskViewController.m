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
#import "ServerBackend.h"
#import "DataTypeConversion.h"

@interface TaskViewController ()

@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property (weak, nonatomic) IBOutlet UIButton *eventTitleButton;
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;

@end

@implementation TaskViewController

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.taskTableView reloadData];
    [self.eventTitleButton setTitle:self.event.title forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Save event name and image.
    self.event.title = self.eventTitleButton.currentTitle;
  
    // Get the NSManagedObject context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Create an error variable to pass to the save method.
    NSError *error = nil;
    // Attempt to save the context and persist our changes.
    [context save:&error];
    if (error) {
        // Error handling, e.g. display error to user.
    }
    
    // Save to server.
    ServerBackend *sharedServerBackend = [ServerBackend sharedServerBackend];
    [sharedServerBackend persistEvent:self.event];
}

#pragma mark - User Interaction

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
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
    NSArray *tasksArray = [DataTypeConversion tasksObjectSortedArrayFromTasksObjectSet:self.event.tasks];
    cell.textLabel.text = [tasksArray[indexPath.row] name];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Get and delete object
    NSArray *tasksArray = [DataTypeConversion tasksObjectSortedArrayFromTasksObjectSet:self.event.tasks];
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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowEventInfo"]) {
        EventInfoTableViewController *eventInfoTableViewController = [segue destinationViewController];
        eventInfoTableViewController.event = self.event;
    } else if ([segue.identifier isEqualToString:@"ShowTaskDetail"]) {
        TaskDetailViewController *taskDetailViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.taskTableView.indexPathForSelectedRow;
        NSArray *tasksArray = [DataTypeConversion tasksObjectSortedArrayFromTasksObjectSet:self.event.tasks];
        taskDetailViewController.task = tasksArray[selectedIndexPath.row];
        Task * task = tasksArray[selectedIndexPath.row];
        
        if ([task.timeStamp isKindOfClass:[NSString class]]) {
            NSLog(@"Timestamp is string");
        }
        
        taskDetailViewController.task.parentEvent = self.event;
    }
}

@end
