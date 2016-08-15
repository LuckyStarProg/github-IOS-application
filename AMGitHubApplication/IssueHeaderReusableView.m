//
//  testView.m
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssueHeaderReusableView.h"

@implementation IssueHeaderReusableView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.avatarView.layer.cornerRadius=self.avatarView.bounds.size.height/2;
    self.avatarView.clipsToBounds=YES;
    self.avatarView.autoresizesSubviews=YES;
    self.avatarView.opaque=YES;
    self.avatarView.clearsContextBeforeDrawing=YES;
    self.avatarView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.avatarView.layer.borderWidth=3.0;
}
@end
