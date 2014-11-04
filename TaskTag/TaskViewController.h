//
//  EventTaskViewController.h
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;

@interface TaskViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) Event *event;

@end
