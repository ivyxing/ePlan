//
//  DatePickerViewController.m
//  TaskTag
//
//  Created by Min Xing on 10/6/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "DatePickerViewController.h"
#import "Task.h"

@interface DatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end


@implementation DatePickerViewController

#pragma message "Missing super call in 'viewWillAppear'"

- (void)viewWillAppear:(BOOL)animated {
    if (self.displayDate) {
        _datePicker.date = self.displayDate;
    }
}

#pragma message "Missing super call in 'viewWillDisappear'"

- (void)viewWillDisappear:(BOOL)animated {
    NSDate *pickedDate = [_datePicker date];
    if (self.delegate) {
        [self.delegate datePicked:pickedDate];
    }
}

@end
