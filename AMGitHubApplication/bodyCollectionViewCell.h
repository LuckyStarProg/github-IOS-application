//
//  bodyCollectionViewCell.h
//  AMGitHubApplication
//
//  Created by Амин on 12.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bodyCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolView;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic)CGFloat height;
+(CGFloat)widthByString:(NSString *)string;
+(CGFloat)heightByString:(NSString *)string;
@end
