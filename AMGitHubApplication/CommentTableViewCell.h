//
//  CommentTableViewCell.h
//  AMGitHubApplication
//
//  Created by Амин on 15.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView * avatarView;
@property (strong, nonatomic) IBOutlet UILabel * nameLabel;
@property (strong, nonatomic) IBOutlet UILabel * dateLabel;
@property (strong, nonatomic) IBOutlet UITextView * textView;

+(CGFloat)heightForText:(NSString *)text;
@end
