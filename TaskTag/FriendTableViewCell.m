//
//  FriendTableViewCell.m
//  TaskTag
//
//  Created by Min Xing on 10/21/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "FriendTableViewCell.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FriendTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;

@end

@implementation FriendTableViewCell

#pragma mark - View Life Cycle

- (void)viewDidLoad {

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setUserName:(NSString *)userName {
    _userName = [userName copy];
    _name.text = _userName;
}

- (void)setUserObjectID:(NSString *)userObjectID {
    _userObjectID = [userObjectID copy];
    self.profilePictureView.profileID = _userObjectID;
}

@end
