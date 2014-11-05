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

@property (weak, nonatomic) IBOutlet UILabel *friendNameLabelInTask;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabelInEvent;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *friendProfilePictureViewInTask;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *friendProfilePictureViewInEvent;

@end

@implementation FriendCollectionViewCell

- (void)setUserFriend:(Person *)someFriend {
    _userFriend = someFriend;
    
    // Set name label.
    _userFriend.name = [someFriend.name copy];
    self.friendNameLabelInTask.text = self.userFriend.firstName;
    self.friendNameLabelInEvent.text = self.userFriend.firstName;
    [self.friendNameLabelInTask setBackgroundColor:[UIColor blackColor]];
    [self.friendNameLabelInEvent setBackgroundColor:[UIColor blackColor]];
    
    // Set Facebook profile picture.
    _userFriend.fbProfilePictureID = [someFriend.fbProfilePictureID copy];
    self.friendProfilePictureViewInTask.profileID = _userFriend.fbProfilePictureID;
    self.friendProfilePictureViewInEvent.profileID = _userFriend.fbProfilePictureID;
}

@end
