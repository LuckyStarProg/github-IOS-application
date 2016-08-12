//
//  MenuTableViewCell.m
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "MenuTableViewCell.h"
@interface MenuTableViewCell()
@property (nonatomic)UIView *selectedCellView;
@end
@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedCellView=[[UIView alloc] init];
    self.selectedCellView.backgroundColor = [UIColor SelectedCellColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setSelectedBackgroundView:self.selectedCellView];
}

@end
