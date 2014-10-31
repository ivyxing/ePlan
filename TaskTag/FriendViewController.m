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
#import "Task.h"
#import "Person.h"

@interface FriendViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *tag;

@property (strong, nonatomic) NSMutableArray *friendsListDiff;

@end

@implementation FriendViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        self.friendsListDiff = [result objectForKey:@"data"];
        // The user him/herself is included in self.task.persons, but FB does not count the user as his/her own friend.
        if (self.friendsListDiff && [self.friendsListDiff count] > ([self.task.persons count] - 1)) {
            NSMutableArray *oldFriends = [NSMutableArray arrayWithArray:[self.task.persons allObjects]];
            // The result is a set of the user's new friends who are now using the app.
            [self.friendsListDiff removeObjectsInArray:oldFriends];
        }
        [self.tableView reloadData];
    }];
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
        NSLog(@"Error saving to core data!");
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.friendsListDiff) {
        // Count the user him/herself in addition to the friends list.
        return [self.friendsListDiff count] + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    // Only populate friends the first time the table view is loaded, not during "reload data."
    if (!cell.userFriend) {
        // The first row shows the user him/herself. The other rows show the user's Facebook friends who have the app.
        if (indexPath.row == 0) {
            // First time adding user him/herself to the array.
            if (!self.task.persons || [self.task.persons count] == 0) {
                // Facebook API call;
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                                       NSDictionary<FBGraphUser> *me, NSError *error) {
                    // Get managed object context.
                    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
                    // Create a new object using the entity description.
                    Person *user = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
                    if (!error) {
                        user.fbProfilePictureID = me.objectID;
                        user.name = @"Sign Me up";
                        cell.userFriend = user;
                        [self.task addPersonsObject:user];
                    } else {
                        // See: https://developers.facebook.com/docs/ios/errors
                        NSLog(@"Error occured while getting user profile info.");
                    }
                }];
            } else {
                // User is already stored in array, get user profile info.
                for (Person *person in self.task.persons) {
                    if ([person.name isEqualToString:@"Sign Me up"]) {
                        cell.userFriend = person;
                    }
                }
            }
        // Add the user's Facebook friends who use the app and check if there are new friends.
        } else if ([self.friendsListDiff count] > 0) {
            // Get managed object context.
            NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
            // Create a new object using the entity description.
            Person *user = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
            
            NSDictionary<FBGraphUser>* userDictionary = self.friendsListDiff[indexPath.row - 1];
            user.fbProfilePictureID = userDictionary.objectID;
            user.name = userDictionary.name;
            user.firstName = userDictionary.first_name;
            cell.userFriend = user;
            [self.task addPersonsObject:user];
        // The user him/herself is included in self.task.persons.
        } else if ([self.task.persons count] > 1) {
            // Show the cached friends.
            NSArray *oldFriends = [self.task.persons allObjects];
            cell.userFriend = oldFriends[indexPath.row - 1];
        }
    }
    
    // Check/uncheck as user selects/deselects cells.
    if ([cell.userFriend.tagged isEqualToNumber:@YES]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove highlighting effect.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Selecting and deselecting cells.
    FriendTableViewCell *cell = (FriendTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell.userFriend.tagged isEqualToNumber:@YES]) {
        cell.userFriend.tagged = @NO;
    } else {
        cell.userFriend.tagged = @YES;
    }
    [tableView reloadData];
}

@end