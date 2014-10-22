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

@interface FriendViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Testing Only
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                               NSDictionary<FBGraphUser> *me, NSError *error) {
            if (!error) {
                cell.userObjectID = me.objectID;
                NSLog(@"user objectID: %@", me.objectID);
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
        cell.userName = @"Sign Me up";
    } else if (self.friendsList && [self.friendsList count] > 0){
        NSDictionary<FBGraphUser>* userDictionary = self.friendsList[indexPath.row - 1];
        cell.userObjectID = userDictionary.objectID;
        cell.userName = userDictionary.name;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    FriendTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    if ([segue.identifier isEqualToString:@"ShowFriendsList"]) {
        TaskDetailViewController *taskDetailViewController = [segue destinationViewController];
        
    }
}

@end
