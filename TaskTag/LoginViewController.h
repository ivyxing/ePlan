//
//  LoginViewController.h
//  TaskTag
//
//  Created by Min Xing on 10/17/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>

@property (copy, nonatomic) NSString *userFBProfilePictuteID;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userFirstName;

@end
