//
//  bodyCollectionViewCell.m
//  AMGitHubApplication
//
//  Created by Амин on 12.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "bodyCollectionViewCell.h"

@implementation bodyCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.scrolView.delegate=self;
}

- (void)scrollViewDidScroll:(id)scrollView
{
    CGPoint origin = [scrollView contentOffset];
    [scrollView setContentOffset:CGPointMake(origin.x, 0.0)];
}

+(CGFloat)widthByString:(NSString *)string
{
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    UIFont* font = [UIFont systemFontOfSize:12.0];
    NSDictionary* attributes =[NSDictionary dictionaryWithObjectsAndKeys:
                               font , NSFontAttributeName,
                               paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake( CGFLOAT_MAX, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return CGRectGetWidth(rect);
}

+(CGFloat)heightByString:(NSString *)string
{
    CGFloat offset = 1.0;
    UIFont* font = [UIFont systemFontOfSize:12.0];
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary* attributes =[NSDictionary dictionaryWithObjectsAndKeys:
                               font , NSFontAttributeName,
                               paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake( [UIScreen mainScreen].bounds.size.width-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}
@end
