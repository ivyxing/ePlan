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

@interface FriendViewController : UIViewController

@property (strong, nonatomic) NSArray *friendsList;
@property (strong, nonatomic) Task *task;

@end
