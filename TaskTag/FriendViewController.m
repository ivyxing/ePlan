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

@property (strong, nonatomic) NSArray *friendsList;
@property (strong, nonatomic) NSMutableArray *friendsSelected;

@end

@implementation FriendViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsSelected = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result objectForKey:@"data"];
        self.friendsList = friends;
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
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.friendsList) {
        // Count the user him/herself in addition to the friends list.
        return [self.friendsList count] + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    // Only populate the first time the table is loaded.
    if (!cell.userFriend) {
        // The first row shows the user him/herself. The other rows show the user's Facebook friends who have the app.
        if (indexPath.row == 0) {
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
                } else {
                    // An error occurred, we need to handle the error
                    // See: https://developers.facebook.com/docs/ios/errors
                }
            }];
        } else if (self.friendsList && [self.friendsList count] > 0) {
            // Get managed object context.
            NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
            // Create a new object using the entity description.
            Person *user = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
            
            NSDictionary<FBGraphUser>* userDictionary = self.friendsList[indexPath.row - 1];
            user.fbProfilePictureID = userDictionary.objectID;
            user.name = userDictionary.name;
            user.firstName = userDictionary.first_name;
            cell.userFriend = user;
        }
    }
    
    
    // DEBUGGING
    NSArray *personsArray = [self.task.persons allObjects];
    if ([personsArray count] > 0) {
        Person *person = personsArray[0];
        NSLog(@"Reloading table - first person name: %@", person.name);
    }
    if ([self.task.persons containsObject:cell.userFriend]) {
        NSLog(@"YES, self.task.persons contains userFriend");
    }
    
    
    // Load the checkmarks as the user selects the cells.
    if ([self.friendsSelected containsObject:indexPath] || [self.task.persons containsObject:cell.userFriend]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove highlighting effect.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FriendTableViewCell *cell = (FriendTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([self.friendsSelected containsObject:indexPath]) {
        [self.friendsSelected removeObject:indexPath];
        [self.task removePersonsObject:cell.userFriend];
    } else {
        [self.friendsSelected addObject:indexPath];
        NSLog(@"name: %@", cell.userFriend.name);
        [self.task addPersonsObject:cell.userFriend];
    
        
        // DEBUGGING
        NSArray *personsArray = [self.task.persons allObjects];
        if ([personsArray count] > 0) {
            Person *person = personsArray[0];
            NSLog(@"After adding person - first person name: %@", person.name);
        }
        
    }
    [tableView reloadData];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    FriendTableViewCell *cell = (FriendTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    TaskDetailViewController *taskDetailViewController = [segue destinationViewController];
    [taskDetailViewController tagFriend:cell.userFriend];
}

@end