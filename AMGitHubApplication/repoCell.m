//
//  repoCell.m
//  AMGitHubApplication
//
//  Created by Амин on 28.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "repoCell.h"

@implementation repoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userAvatar.layer.cornerRadius=8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
