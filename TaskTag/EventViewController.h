//
//  EventViewController.h
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface EventViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, NSURLSessionDataDelegate>

@property (strong, nonatomic) Person *currentUser;

@end
