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

- (void)setFriend:(Person *)friend {
    // Set name label.
    _friend.name = [friend.name copy];
    _name.text = _friend.name;
    // Set Facebook profile picture.
    _friend.fbProfilePictureID = [friend.fbProfilePictureID copy];
    self.profilePictureView.profileID = _friend.fbProfilePictureID;
}

@end
