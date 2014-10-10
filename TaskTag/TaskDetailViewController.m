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


@interface TaskDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITableView *dueDateAlertTableView;
@property (weak, nonatomic) IBOutlet UIButton *dueDateButton;

@end

@implementation TaskDetailViewController 

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Display task name.
    [self.taskNameTextField setText:self.task.name];
    [self.view reloadInputViews];
}

#pragma mark - User Interaction

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.taskNameTextField) {
        // Hide keyboard.
        [self.taskNameTextField resignFirstResponder];
        // Save task title.
        self.task.name = textField.text;
    }
    return YES;
}

#pragma mark - Set Date

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickDueDate"]) {
        DatePickerViewController *datePickerViewController = [segue destinationViewController];
        datePickerViewController.delegate = self;
        datePickerViewController.displayDate = self.task.dueDate;
    }
}

- (void)datePicked:(NSDate*)date {
    self.task.dueDate =  date;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    NSString *buttonTitle = [NSString stringWithFormat:@"Due Date: %@", dateString];
    [self.dueDateButton setTitle:buttonTitle forState:UIControlStateNormal];
}

#pragma mark - Table view data source

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
//    
//    return cell;
//}

@end
