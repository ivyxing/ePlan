//
//  FriendViewController.m
//  TaskTag
//
//  Created by Min Xing on 10/21/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendTableViewCell.h"
#import "TaskDetailViewController.h"
#import "AppDelegate.h"
#import "Event.h"
#import "Task.h"
#import "Person.h"
#import "LoginViewController.h"
#import "ServerBackend.h"

@interface FriendViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *friendsList;

@end

@implementation FriendViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsList = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.addFriendsToEvent) {
        if (self.event.persons.count <= 1) {
            // First time populating friends. Load all Facebook friends who have the app.
            FBRequest* friendsRequest = [FBRequest requestForMyFriends];
            [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary* result,
                                                          NSError *error) {
                [self helperAddPersons:[result objectForKey:@"data"]];
                self.friendsList = [NSMutableArray arrayWithArray:[self.event.persons allObjects]];
                [self.tableView reloadData];
            }];
        } else {
            self.friendsList = [NSMutableArray arrayWithArray:[self.event.persons allObjects]];
            // TODO: Add new friends.
        }
    } else {
        // In task tagging view.
        for (Person *friend in self.task.parentEvent.persons) {
            if (friend.taggedForEvent) {
                if (friend.isCurrentUser) {
                    friend.name = @"Sign Me up";
                    friend.firstName = @"Me";
                }
                [self.friendsList addObject:friend];
            }
        }
    }
    [self.tableView reloadData];
}

// Add Facebook friends to the allFriends array.
- (void)helperAddPersons:(NSArray*)userFriendDictionaryArray {
    for (NSDictionary<FBGraphUser>* userFriendDictionary in userFriendDictionaryArray) {
        // Create a new object using the entity description.
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        Person *userFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
        userFriend.fbProfilePictureID = userFriendDictionary.objectID;
        userFriend.name = userFriendDictionary.name;
        userFriend.firstName = userFriendDictionary.first_name;
        [self.event addPersonsObject:userFriend];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Get the NSManagedObject context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Create an error variable to pass to the save method.
    NSError *error = nil;
    // Attempt to save the context and persist our changes.
    [context save:&error];
    if (error) {
        // Error handling, e.g. display error to user.
        NSLog(@"Error saving to core data.");
    }
    
    // Save to server.
    ServerBackend *sharedServerBackend = [ServerBackend sharedServerBackend];
    if (self.addFriendsToEvent) {
        [sharedServerBackend persistEvent:self.event];
    } else {
        [sharedServerBackend persistEvent:self.task.parentEvent];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.friendsList) {
        return self.friendsList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    // Only populate friends the first time the table view is loaded; do not reload when selecting cells.
    if (!cell.userFriend && self.friendsList) {
            cell.userFriend = self.friendsList[indexPath.row];
    }
    // Check/uncheck as user selects/deselects cells.
    if ([cell.userFriend.taggedForTask isEqualToNumber:@YES] || (self.addFriendsToEvent && ([cell.userFriend.taggedForEvent isEqualToNumber:@YES] || [cell.userFriend.isCurrentUser isEqualToNumber:@YES]))) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove highlighting effect.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Select and deselect cells.
    FriendTableViewCell *cell = (FriendTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (self.addFriendsToEvent) {
        // Tagging for event.
        if ([cell.userFriend.taggedForEvent isEqualToNumber:@YES]) {
            cell.userFriend.taggedForEvent = @NO;
        } else {
            cell.userFriend.taggedForEvent = @YES;
        }
    } else {
        // Tagging friends for task.
        if ([cell.userFriend.taggedForTask isEqualToNumber:@YES]) {
            cell.userFriend.taggedForTask = @NO;
        } else {
            cell.userFriend.taggedForTask = @YES;
        }
    }
    [tableView reloadData];
}

@end