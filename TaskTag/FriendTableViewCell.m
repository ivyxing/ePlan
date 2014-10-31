//
//  FriendTableViewCell.m
//  TaskTag
//
//  Created by Min Xing on 10/21/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "FriendTableViewCell.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Person.h"

@interface FriendTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;

@end

@implementation FriendTableViewCell

- (void)setUserFriend:(Person *)someFriend {
    _userFriend = someFriend;
    // Set name label.
    _userFriend.name = [someFriend.name copy];
    #pragma message "You should prefer accessing properties with dot-syntax instead of using the underlying iVar"
    _name.text = _userFriend.name;
    // Set Facebook profile picture.
    _userFriend.fbProfilePictureID = [someFriend.fbProfilePictureID copy];
    self.profilePictureView.profileID = _userFriend.fbProfilePictureID;
}

@end
