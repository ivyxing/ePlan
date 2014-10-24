//
//  FriendTableViewCell.h
//  TaskTag
//
//  Created by Min Xing on 10/21/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Person;

@interface FriendTableViewCell : UITableViewCell

#pragma message "friend is a C++ keyword, ideally rename this property ;)"
@property (strong, nonatomic) Person *friend;

@end
