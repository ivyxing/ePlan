//
//  EventInfoTableViewController.m
//  TaskTag
//
//  Created by Min Xing on 10/2/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "EventInfoTableViewController.h"
#import "Event.h"
#import "AppDelegate.h"

@interface EventInfoTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UITextView *notesTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;

@property (strong, nonatomic) UIImagePickerController *imgPicker;

@end

@implementation EventInfoTableViewController {
    BOOL settingStartTime;
    BOOL settingEndTime;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // To get rid of the extra lines in the table views.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Initialize the image picker.
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.allowsEditing = YES;
    self.imgPicker.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Display image.
    if (self.event.image) {
        UIImage *img = [[UIImage alloc] initWithData:self.event.image];
        [self.addPhotoButton setBackgroundImage:img forState:UIControlStateNormal];
        [self.addPhotoButton setTitle:nil forState:UIControlStateNormal];
    }
    // Display description.
    if (self.event.notes) {
        [self.notesTextField setText:self.event.notes];
    }
    // Display start and end time.
    if (self.event.startTime) {
        NSString* startTimeStr = [self dateToString:self.event.startTime];
        [self.startTimeButton setTitle:startTimeStr forState:UIControlStateNormal];
    }
    if (self.event.endTime) {
        NSString* endTimeStr = [self dateToString:self.event.endTime];
        [self.endTimeButton setTitle:endTimeStr forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.event.notes = self.notesTextField.text;
    
    // Get the NSManagedObject context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Create an error variable to pass to the save method.
    NSError *error = nil;
    // Attempt to save the context and persist our changes.
    [context save:&error];
    if (error) {
        // Error handling, e.g. display error to user.
    }
}

#pragma mark - User Interaction

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.locationTextField resignFirstResponder];
    return YES;
}

#pragma mark - Image Handling

- (IBAction)choosePhoto:(id)sender {
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imgPicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
    [self.addPhotoButton setBackgroundImage:img forState:UIControlStateNormal];
    [self.addPhotoButton setTitle:nil forState:UIControlStateNormal];
    self.event.image = UIImagePNGRepresentation(img);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Date/Time Handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickStartTime"]) {
        DatePickerViewController *datePickerViewController = [segue destinationViewController];
        datePickerViewController.delegate = self;
        datePickerViewController.displayDate = self.event.startTime;
    } else if ([segue.identifier isEqualToString:@"PickEndTime"]) {
        DatePickerViewController *datePickerViewController = [segue destinationViewController];
        datePickerViewController.delegate = self;
        datePickerViewController.displayDate = self.event.endTime;
    }
}
- (IBAction)setStartTime:(id)sender {
    settingStartTime = YES;
    settingEndTime = NO;
}
- (IBAction)setEndTime:(id)sender {
    settingEndTime = YES;
    settingStartTime = NO;
}

- (void)datePicked:(NSDate*)date {
    NSString *buttonTitle = [self dateToString:date];
    if (settingStartTime) {
        self.event.startTime = date;
        [self.startTimeButton setTitle:buttonTitle forState:UIControlStateNormal];
    } else if (settingEndTime) {
        self.event.endTime = date;
        [self.endTimeButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
}

- (NSString*)dateToString:(NSDate*)date {
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    return dateString;
}

@end
