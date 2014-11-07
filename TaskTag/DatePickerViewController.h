//
//  DatePickerViewController.h
//  TaskTag
//
//  Created by Min Xing on 10/6/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskDetailViewController, Task;

@protocol DatePickerViewControllerDelegate

- (void)datePicked:(NSDate*)date;

@end

@interface DatePickerViewController : UIViewController

@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) id<DatePickerViewControllerDelegate> delegate;
@property (strong, nonatomic) NSDate *displayDate;

@end
