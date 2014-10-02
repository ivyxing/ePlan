//
//  EventTaskViewController.m
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "EventTaskViewController.h"
#import "EventTaskDetailViewController.h"
#import "EventInfoTableViewController.h"
#import "Task.h"
#import "Event.h"
#import "AppDelegate.h"

@interface EventTaskViewController ()

@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;

@end

@implementation EventTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.taskTableView.delegate = self;
    self.taskTableView.dataSource = self;
    self.eventTitleTextField.delegate = self;
    self.taskNameTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interaction

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.eventTitleTextField) {
        // Hide keyboard.
        [self.eventTitleTextField resignFirstResponder];
        // Save event title.
        self.event.title = textField.text;
    } else if (textField == self.taskNameTextField) {
        // Hide keyboard.
        [self.taskNameTextField resignFirstResponder];
        // Create new task.
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        // Create a new object using the entity description.
        Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
        task.name = textField.text;
        [self.event addTasksObject:task];
        // Clear the text field.
        [textField setText:@""];
        [self.taskTableView reloadData];
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.event.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    NSArray *tasksArray = [self.event.tasks allObjects];
    cell.textLabel.text = [tasksArray[indexPath.row] name];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.eventTitleTextField.text = self.event.title;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Event Info"]) {
        EventInfoTableViewController *eventInfoTableViewController = [segue destinationViewController];
        eventInfoTableViewController.event = self.event;
    } else if ([segue.identifier isEqualToString:@"EventDetail"]) {
        EventTaskDetailViewController *eventTaskDetailViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.taskTableView.indexPathForSelectedRow;
        NSArray *tasksArray = [self.event.tasks allObjects];
        eventTaskDetailViewController.task = tasksArray[selectedIndexPath.row];
    }
}

#pragma mark - Save Changes

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Save event name and image.
    self.event.title = self.eventTitleTextField.text;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
