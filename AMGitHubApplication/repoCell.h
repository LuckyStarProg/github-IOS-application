//
//  repoCell.h
//  AMGitHubApplication
//
//  Created by Амин on 28.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface repoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *repoName;
@property (strong, nonatomic) IBOutlet UILabel *repoDescription;
@property (strong, nonatomic) IBOutlet UILabel *repoStarsLabel;

+(CGFloat)heightForText:(NSString *)text;
-(void)awakeFromNib;
@end
