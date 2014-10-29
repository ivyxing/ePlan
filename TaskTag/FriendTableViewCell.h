//
//  FriendTableViewCell.h
//  TaskTag
//
//  Created by Min Xing on 10/21/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Person;
@class Task;

@interface FriendTableViewCell : UITableViewCell

@property (strong, nonatomic) Person *userFriend;
@property (strong, nonatomic) Task *task;

@end
