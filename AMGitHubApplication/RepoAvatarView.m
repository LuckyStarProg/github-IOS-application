//
//  RepoAvatarView.m
//  AMGitHubApplication
//
//  Created by Амин on 01.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "RepoAvatarView.h"

@implementation RepoAvatarView

//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    self.imageView.layer.cornerRadius=37;
//}

-(UIImageView *)imageView
{
    _imageView.layer.cornerRadius=40;
    return _imageView;
}
+(CGFloat)heightForText:(NSString *)text
{
    CGFloat offset = 1.0;
    UIFont* font = [UIFont systemFontOfSize:13.0];
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary* attributes =[NSDictionary dictionaryWithObjectsAndKeys:
                               font , NSFontAttributeName,
                               paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake( [UIScreen mainScreen].bounds.size.width*0.8, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}
@end
