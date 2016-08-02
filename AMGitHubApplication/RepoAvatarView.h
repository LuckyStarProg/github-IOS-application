//
//  RepoAvatarView.h
//  AMGitHubApplication
//
//  Created by Амин on 01.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoAvatarView : UICollectionReusableView
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

+(CGFloat)heightForText:(NSString *)text;
@end
