//
//  LoginViewController.m
//  TaskTag
//
//  Created by Min Xing on 10/17/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Facebook login.
    
    if (![FBSettings defaultAppID])
    {
        [FBSettings setDefaultAppID:@"1568271783394281"];
    }
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]];
    loginView.delegate = self;
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
}

@end
