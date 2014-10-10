//
//  EventTaskDetailViewController.m
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "DatePickerViewController.h"
#import "Task.h"
#import "AppDelegate.h"


@interface TaskDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITableView *dueDateAlertTableView;
@property (weak, nonatomic) IBOutlet UIButton *dueDateButton;

@end

@implementation TaskDetailViewController 

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated {
    [self.dueDateAlertTableView reloadData];
    // Display task name.
    [self.taskNameTextField setText:self.task.name];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Save event name and image.
    self.task.name = self.taskNameTextField.text;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.taskNameTextField) {
        // Hide keyboard.
        [self.taskNameTextField resignFirstResponder];
        // Save task title.
        self.task.name = textField.text;
        self.task.timeStamp = [NSDate date];
    }
    return YES;
}

#pragma mark - Table view data source

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
//
//    return cell;
//}

#pragma mark - Date Handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickDueDate"]) {
        DatePickerViewController *datePickerViewController = [segue destinationViewController];
        datePickerViewController.delegate = self;
        datePickerViewController.displayDate = self.task.dueDate;
    }
}

- (void)datePicked:(NSDate*)date {
    self.task.dueDate = date;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    NSLog(@"%@", dateString);
    NSString *buttonTitle = [NSString stringWithFormat:@"Due Date: %@", dateString];
    [self.dueDateButton setTitle:buttonTitle forState:UIControlStateNormal];
}

@end
