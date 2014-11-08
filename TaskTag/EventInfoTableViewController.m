//
//  EventInfoTableViewController.m
//  TaskTag
//
//  Created by Min Xing on 10/2/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "EventInfoTableViewController.h"
#import "Event.h"
#import "Task.h"
#import "Person.h"
#import "TaskViewController.h"
#import "FriendViewController.h"
#import "FriendCollectionViewCell.h"
#import "AppDelegate.h"
#import "ServerBackend.h"

@interface EventInfoTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *friendsTagged;

@end

@implementation EventInfoTableViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // To get rid of the extra lines in the table views.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.friendsTagged = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Display description and location.
    if (self.event.title) {
        [self.eventTitleTextField setText:self.event.title];
    }
    if (self.event.summary) {
        [self.summaryTextView setText:self.event.summary];
    }
    if (self.event.location) {
        [self.locationTextField setText:self.event.location];
    }
    // Display start and end time.
    if (self.event.startTime) {
        // TODO: Fix start time and end time
        NSString* startTimeStr = [self dateToString:self.event.startTime];
    }
    if (self.event.endTime) {
        NSString* endTimeStr = [self dateToString:self.event.endTime];
    }
    // Stored tagged friends for event.
    if (self.event.persons && self.event.persons.count > 0) {
        for (Person* person in self.event.persons) {
            if ([person.isCurrentUser isEqualToNumber:@YES]) {
                person.taggedForEvent = @YES;
            }
            // Add the tagged friend.
            if ([person.taggedForEvent isEqualToNumber:@YES]) {
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
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.event.title = self.eventTitleTextField.text;
    self.event.summary = self.summaryTextView.text;
    self.event.location = self.locationTextField.text;
    
    // Get the NSManagedObject context
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
    if (textField == self.eventTitleTextField) {
        [self.eventTitleTextField resignFirstResponder];
    } else if (textField ==  self.locationTextField) {
        [self.locationTextField resignFirstResponder];
    }
    return YES;
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
#pragma message "It is fairly untypical to present the DatePickerViewController as a separate ViewController, except you want to display more than only a DatePicker within the ViewController. In most cases the DatePicker gets displayed on top of the current View Controller until a date is selected"
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickStartTime"]) {
        DatePickerViewController *datePickerViewController = [segue destinationViewController];
        datePickerViewController.delegate = self;
        datePickerViewController.displayDate = self.event.startTime;
    } else if ([segue.identifier isEqualToString:@"PickEndTime"]) {
        DatePickerViewController *datePickerViewController = [segue destinationViewController];
        datePickerViewController.delegate = self;
        datePickerViewController.displayDate = self.event.endTime;
    } else if ([segue.identifier isEqualToString:@"ShowEventTasks"]) {
        TaskViewController *taskViewController = [segue destinationViewController];
        taskViewController.event = self.event;
    } else if ([segue.identifier isEqualToString:@"ShowFriendList"]) {
        FriendViewController *friendViewController = [segue destinationViewController];
        friendViewController.event = self.event;
        friendViewController.addFriendsToEvent = YES;
    }
}

#pragma mark - Date/Time Handling
#pragma message "Having state variables such as 'settingStartTime' and 'settingEndTime' is usually not a good practice. In this specific case a better solution could be that the date picker knows which date it is picking and passes that information on to the callback method"

- (void)datePicked:(NSDate*)date {
    NSString *buttonTitle = [self dateToString:date];
}

- (NSString*)dateToString:(NSDate*)date {
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    return dateString;
}

#pragma mark - Calendar Handling

- (IBAction)addToCalendar:(id)sender {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = self.event.title;
            event.location = self.event.location;
            event.startDate = self.event.startTime;
            event.endDate = self.event.endTime;
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        }
    }];
}

@end
