//
//  EventTaskDetailViewController.h
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
@class Task;

@interface TaskDetailViewController : UIViewController <UITextFieldDelegate, DatePickerViewControllerDelegate>

@property (strong, nonatomic) Task *task;

- (void)showTaggedFriendsWith:(NSString *)objectID and:(NSString *)name;

@end
