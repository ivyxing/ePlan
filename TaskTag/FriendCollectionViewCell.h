//
//  FriendCollectionViewCell.h
//  TaskTag
//
//  Created by Min Xing on 10/22/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface FriendCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Person *userFriend;

@end
