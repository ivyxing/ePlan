//
//  FriendCollectionViewCell.m
//  TaskTag
//
//  Created by Min Xing on 10/22/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "FriendCollectionViewCell.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FriendCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;

@end

@implementation FriendCollectionViewCell

- (void)setUserName:(NSString *)userName {
    _userName = [userName copy];
    _name.text = _userName;
}

- (void)setUserObjectID:(NSString *)userObjectID {
    _userObjectID = [userObjectID copy];
    self.profilePictureView.profileID = _userObjectID;
}

@end
