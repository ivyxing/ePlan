//
//  FriendViewController.h
//  TaskTag
//
//  Created by Min Xing on 10/21/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@class Task;
@class Event;

@interface FriendViewController : UIViewController

@property (strong, nonatomic) Task *task;
@property (assign, nonatomic) BOOL loadFriendsInEventInfoTableView;

@end
