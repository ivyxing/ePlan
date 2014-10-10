//
//  EventInfoTableViewController.h
//  TaskTag
//
//  Created by Min Xing on 10/2/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
@class Event;


@interface EventInfoTableViewController : UITableViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, DatePickerViewControllerDelegate>

@property (strong, nonatomic) Event *event;

@end
