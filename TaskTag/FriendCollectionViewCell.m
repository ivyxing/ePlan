//
//  FriendCollectionViewCell.m
//  TaskTag
//
//  Created by Min Xing on 10/22/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "FriendCollectionViewCell.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Person.h"

@interface FriendCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;

@end

@implementation FriendCollectionViewCell

- (void)setUserFriend:(Person *)someFriend {
    _userFriend = someFriend;
    // Set name label.
    _userFriend.name = [someFriend.name copy];
    _name.text = _userFriend.name;
    // Set Facebook profile picture.
    _userFriend.fbProfilePictureID = [someFriend.fbProfilePictureID copy];
    self.profilePictureView.profileID = _userFriend.fbProfilePictureID;
}

@end
