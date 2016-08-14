//
//  IssuTableViewCell.m
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssuTableViewCell.h"

@implementation IssuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isAddContent=NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
