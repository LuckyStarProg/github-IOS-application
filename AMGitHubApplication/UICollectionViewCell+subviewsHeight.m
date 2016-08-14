//
//  UITableViewCell+subviewsHeight.m
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "UICollectionViewCell+subviewsHeight.h"

@implementation UICollectionViewCell (subviewsHeight)
-(CGFloat)summarySubviewsHeight
{
    CGFloat height;
    for(UIView * view in self.contentView.subviews)
    {
        height+=view.bounds.size.height+8;
    }
    return height;
}
@end
