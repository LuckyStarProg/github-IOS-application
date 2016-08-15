//
//  CommentTableViewCell.m
//  AMGitHubApplication
//
//  Created by Амин on 15.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.avatarView.layer.cornerRadius=self.avatarView.bounds.size.height/2;
    self.avatarView.clipsToBounds=YES;
    self.avatarView.autoresizesSubviews=YES;
    self.avatarView.opaque=YES;
    self.avatarView.clearsContextBeforeDrawing=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

+(CGFloat)heightForText:(NSString *)text
{
    CGFloat offset = 5.0;
    UIFont* font = [UIFont systemFontOfSize:12.0];
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary* attributes =[NSDictionary dictionaryWithObjectsAndKeys:
                               font , NSFontAttributeName,
                               paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake( [UIScreen mainScreen].bounds.size.width*0.5, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}
@end
