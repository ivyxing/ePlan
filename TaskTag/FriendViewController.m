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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        if ([self.task.persons count] == 0) {
            // First time populating set of friends in core data.
            // Get user profile info and add user him/herself.
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
                    [self.task addPersonsObject:user];
                } else {
                    // See: https://developers.facebook.com/docs/ios/errors
                    NSLog(@"Error occured while getting user profile info.");
                }
            }];
            // Add the user's friends.
            NSArray *userFriendDictionaryArray = [result objectForKey:@"data"];
            for (NSDictionary<FBGraphUser>* userFriendDictionary in userFriendDictionaryArray) {
                // Create a new object using the entity description.
                NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
                Person *userFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
                userFriend.fbProfilePictureID = userFriendDictionary.objectID;
                userFriend.name = userFriendDictionary.name;
                userFriend.firstName = userFriendDictionary.first_name;
                [self.task addPersonsObject:userFriend];
            }
        } else {
            self.friendsListDiff = [result objectForKey:@"data"];
        }
        // The user him/herself is included in self.task.persons, but FB does not count the user as his/her own friend.
        if (self.friendsListDiff && [self.friendsListDiff count] > ([self.task.persons count] - 1)) {
            NSMutableArray *oldFriends = [NSMutableArray arrayWithArray:[self.task.persons allObjects]];
            // The result is a set of the user's new friends who are now using the app.
            [self.friendsListDiff removeObjectsInArray:oldFriends];
        } else {
            self.friendsListDiff = nil;
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
    if (self.task.persons) {
        // Count the user him/herself in addition to the friends list.
        return [self.task.persons count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    // Only populate friends the first time the table view is loaded, not during "reload data."
    if (!cell.userFriend) {
               // Add the user's Facebook friends who use the app and check if there are new friends.
        if (self.friendsListDiff && [self.friendsListDiff count] > 0) {
            // Get managed object context.
            NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
            // Create a new object using the entity description.
            Person *userFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
            
            NSDictionary<FBGraphUser>* userDictionary = self.friendsListDiff[indexPath.row];
            userFriend.fbProfilePictureID = userDictionary.objectID;
            userFriend.name = userDictionary.name;
            userFriend.firstName = userDictionary.first_name;
            cell.userFriend = userFriend;
            [self.task addPersonsObject:userFriend];
        // The user him/herself is included in self.task.persons.
        } else if (self.task.persons && [self.task.persons count] > 0) {
            if (indexPath.row == 0) {
                // Show the user him/herself.
                for (Person *person in self.task.persons) {
                    if ([person.name isEqualToString:@"Sign Me up"]) {
                        cell.userFriend = person;
                    }
                }                
            } else {
                // Show the cached friends.
                NSArray *oldFriends = [self.task.persons allObjects];
                cell.userFriend = oldFriends[indexPath.row];
            }
        }
        [self.tableView reloadData];
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