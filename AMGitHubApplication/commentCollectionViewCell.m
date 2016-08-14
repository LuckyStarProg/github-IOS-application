//
//  commentCollectionViewCell.m
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "commentCollectionViewCell.h"

@implementation commentCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.avatarView.layer.cornerRadius=self.avatarView.bounds.size.height/2;
    self.avatarView.opaque=YES;
    self.avatarView.clearsContextBeforeDrawing=YES;
    self.avatarView.clipsToBounds=YES;
    self.avatarView.autoresizesSubviews=YES;
    
}
@end
