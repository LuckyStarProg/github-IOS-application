//
//  commentCollectionViewCell.h
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (strong, nonatomic) IBOutlet UIView *contentViewCustom;
@property (nonatomic)NSArray<UIView *> * customInputViews;
@end
