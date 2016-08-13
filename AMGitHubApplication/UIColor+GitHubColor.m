//
//  UIColor+GitHubColor.m
//  AMGitHubApplication
//
//  Created by Амин on 01.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "UIColor+GitHubColor.h"

@implementation UIColor (GitHubColor)
+(UIColor *)GitHubColor
{
    return [UIColor colorWithRed:46.0/255.0 green:46.0/255.0 blue:46.0/255.0 alpha:1.0];
}
+(UIColor *)SeparatorColor
{
    return [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:245.0/255.0 alpha:1.0];
}
+(UIColor *)SelectedCellColor
{
    return [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
}
+(UIColor *)scrollCollor
{
    return [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
}
@end
