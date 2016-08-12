//
//  EventCellTableViewCell.h
//  AMGitHubApplication
//
//  Created by Амин on 05.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *eventHeader;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic)NSString * avatarPath;
+(CGFloat)heightForText:(NSString *)text;
@end
