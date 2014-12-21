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
#import "Event.h"
#import "Person.h"
#import "AppDelegate.h"
#import "ServerBackend.h"
#import "DataTypeConversion.h"
#import "Message.h"

@interface TaskDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
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
    [self.taskNameTextField setTextColor:[UIColor whiteColor]];
    
    if (self.task.parentEvent.persons && self.task.parentEvent.persons.count > 0) {
        for (Person* person in self.task.parentEvent.persons) {
            // Add the tagged friend.
            if ([person.taggedForTask isEqualToNumber:@YES]) {
                // Do not add duplicates.
                if (![self.friendsTagged containsObject:person]) {
                    [self.friendsTagged addObject:person];
                }
            } else if ([self.friendsTagged containsObject:person]) {
                // Remove untagged friends.
                [self.friendsTagged removeObject:person];
            }
        }
    }
    [self.friendsCollectionView reloadData];
    
    // Save to server.
    ServerBackend *sharedServerBackend = [ServerBackend sharedServerBackend];
    [sharedServerBackend persistEvent:self.task.parentEvent];
    
    // Get comments from server.
//    [sharedServerBackend getComments];
//    self.messages = sharedServerBackend.comments;
//    [self.commentsTableView reloadData];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.taskNameTextField) {
        // Hide keyboard.
        [self.taskNameTextField resignFirstResponder];
        // Save task title.
        self.task.name = textField.text;
        self.task.timeStamp = [NSDate date];
    } else if (textField == self.commentsTextField) {
        // Hide keyboard.
        [self.commentsTextField resignFirstResponder];
        // Store and send message.
        Message *msg = [Message new];
        msg.username = [self getCurrentUserFirstName];
        msg.content = textField.text;
        ServerBackend *sharedServerBackend = [ServerBackend sharedServerBackend];
        [sharedServerBackend sendCommentToServer:[msg messageToJSONDictionary]];
    }
    return YES;
}

// TODO: Add a send button.
- (IBAction)sendMessage:(id)sender {
    Message *msg = [Message new];
    msg.username = [self getCurrentUserFirstName];
    msg.content = self.commentsTextField.text;
    ServerBackend *sharedServerBackend = [ServerBackend sharedServerBackend];
    [sharedServerBackend sendCommentToServer:[msg messageToJSONDictionary]];
}

- (NSString *)getCurrentUserFirstName {
    for (Person *person in self.task.persons) {
        if (person.isCurrentUser) {
            return person.firstName;
        }
    }
    return nil;
}

#pragma mark - Table View Data Source

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
//
//    return cell;
//}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.messages[indexPath.row] content];
    return cell;
}

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
        friendViewController.addFriendsToEvent= NO;
    }
}

#pragma mark - Date Handling

- (void)datePicked:(NSDate*)date {
    self.task.dueDate = date;
    NSString *buttonTitle = [NSString stringWithFormat:@"Due Date: %@", [DataTypeConversion dateToString:date]];
    [self.dueDateButton setTitle:buttonTitle forState:UIControlStateNormal];
}

@end
