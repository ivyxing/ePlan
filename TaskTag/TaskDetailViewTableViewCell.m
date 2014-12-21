//
//  TaskDetailViewTableViewCell.m
//  TaskTag
//
//  Created by Min Xing on 12/21/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "TaskDetailViewTableViewCell.h"
@interface TaskDetailViewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *taskCheckBox;
@property (weak, nonatomic) IBOutlet UIImageView *taskStar;

@end
@implementation TaskDetailViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
