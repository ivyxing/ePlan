//
//  FriendViewController.h
//  TaskTag
//
//  Created by Min Xing on 10/21/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class Task, Event, LoginViewController;

@interface FriendViewController : UIViewController

@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) Event *event;
@property (assign, nonatomic) BOOL addFriendsToEvent;


@end
