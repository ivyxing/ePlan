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

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsList = [NSArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Count the user him/herself in addition to the friends list.
    return [self.friendsList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    // The first row always shows the user him/herself.
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
    }
    // The other rows shows the user's taggable friends.
    if (self.friendsList && [self.friendsList count] > 0) {
        NSDictionary<FBGraphUser>* userDictionary = self.friendsList[indexPath.row - 1];
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        // Create a new object using the entity description.
        Person *userFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
        userFriend.fbProfilePictureID = userDictionary.objectID;
        userFriend.name = userDictionary.name;
        cell.userFriend = userFriend;
    }
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    FriendTableViewCell *cell = (FriendTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    TaskDetailViewController *taskDetailViewController = [segue destinationViewController];
    [taskDetailViewController tagFriend:cell.userFriend];
}

@end