//
//  EventTaskDetailViewController.m
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "DatePickerViewController.h"
#import "FriendViewController.h"
#import "FriendCollectionViewCell.h"
#import "Task.h"
#import "Person.h"
#import "AppDelegate.h"

@interface TaskDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITableView *dueDateAlertTableView;
@property (weak, nonatomic) IBOutlet UIButton *dueDateButton;
@property (weak, nonatomic) IBOutlet UICollectionView *friendsCollectionView;

@property (strong, nonatomic) NSMutableArray *friendsTagged;

@end

@implementation TaskDetailViewController 

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsTagged = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Display task name.
    [self.taskNameTextField setText:self.task.name];
    
    if (self.task.persons && [self.task.persons count] > 0) {
        for (Person* person in self.task.persons) {
            // Add the tagged friend.
            if ([person.tagged isEqualToNumber:@YES]) {
                // Do not add duplicated entries.
                if (![self.friendsTagged containsObject:person]) {
                    [self.friendsTagged addObject:person];
                }
            } else if ([self.friendsTagged containsObject:person]) {
                // Remove untagged friend.
                [self.friendsTagged removeObject:person];
            }
        }
    }
    [self.friendsCollectionView reloadData];
    [self.dueDateAlertTableView reloadData];
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

#pragma mark - Table View Data Source

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
//
//    return cell;
//}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.friendsTagged.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaggedFriendCell" forIndexPath:indexPath];
    cell.userFriend = self.friendsTagged[indexPath.row];
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickDueDate"]) {
        DatePickerViewController *datePickerViewController = [segue destinationViewController];
        datePickerViewController.delegate = self;
        datePickerViewController.displayDate = self.task.dueDate;
    } else if ([segue.identifier isEqualToString:@"ShowFriendsList"]) {
        FriendViewController *friendViewController = [segue destinationViewController];
        friendViewController.task = self.task;
    }
}

#pragma mark - Date Handling

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
