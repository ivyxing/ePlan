//
//  EventTaskDetailViewController.h
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Task;

@interface EventTaskDetailViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Task *task;

@end
