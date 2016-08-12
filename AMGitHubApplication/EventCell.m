//
//  EventCellTableViewCell.m
//  AMGitHubApplication
//
//  Created by Амин on 05.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarView.layer.cornerRadius=self.avatarView.bounds.size.width/2;
    // Initialization code
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
