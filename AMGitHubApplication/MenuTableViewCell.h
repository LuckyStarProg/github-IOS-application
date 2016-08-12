//
//  MenuTableViewCell.h
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+GitHubColor.h"

@interface MenuTableViewCell : UITableViewCell
@property (nonatomic) IBOutlet UIImageView * menuIconView;
@property (nonatomic) IBOutlet UILabel * menuName;

@end
