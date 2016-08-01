//
//  UIImage+ResizingImg.m
//  AMGitHubApplication
//
//  Created by Амин on 01.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "UIImage+ResizingImg.h"

@implementation UIImage (ResizingImg)
- (UIImage *)toSize:(CGSize)newSize
{
    double ratio;
    double delta;
    ratio = newSize.width / self.size.width;
    delta = (ratio*self.size.height-ratio*self.size.width);
    
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[self CGImage]
                        scale:(self.scale / ratio)
                  orientation:(self.imageOrientation)];
    
    CGRect clipRect = CGRectMake(0, 0,
                                 scaledImage.size.width,
                                 scaledImage.size.height);
    CGSize sz = CGSizeMake(newSize.width, scaledImage.size.height);
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else
    {
        UIGraphicsBeginImageContext(sz);
    }
    
    UIRectClip(clipRect);
    [self drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
