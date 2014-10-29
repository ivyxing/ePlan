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
#import "Person.h"

@interface FriendViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *tag;

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Count the user him/herself in addition to the friends list.
    if (self.friendsList) {
        return [self.friendsList count] + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    // The first row shows the user him/herself. The other rows show the user's Facebook friends who have the app.
    if (indexPath.row == 0) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                               NSDictionary<FBGraphUser> *me, NSError *error) {
            if (!error) {
                NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
                // Create a new object using the entity description.
                Person *user = [NSEntityDescription insertNewObjectForEntityForName:@"Person"
                                                                   inManagedObjectContext:context];
                user.fbProfilePictureID = me.objectID;
                user.name = @"Sign Me up";
                cell.userFriend = user;
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
    } else if (self.friendsList && [self.friendsList count] > 0) {
        NSDictionary<FBGraphUser>* userDictionary = self.friendsList[indexPath.row - 1];
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        // Create a new object using the entity description.
        Person *userFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
        userFriend.fbProfilePictureID = userDictionary.objectID;
        userFriend.name = userDictionary.name;
        userFriend.firstName = userDictionary.first_name;
        cell.userFriend = userFriend;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
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