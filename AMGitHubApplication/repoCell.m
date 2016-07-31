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
    self.userAvatar.layer.cornerRadius=30;
//    self.userAvatar.frame=CGRectMake(8, 8, 108, 80);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)heightForText:(NSString *)text
{
    CGFloat offset = 1.0;
    UIFont* font = [UIFont systemFontOfSize:10.0];
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary* attributes =[NSDictionary dictionaryWithObjectsAndKeys:
     font , NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake( [UIScreen mainScreen].bounds.size.width*0.76, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}

@end
