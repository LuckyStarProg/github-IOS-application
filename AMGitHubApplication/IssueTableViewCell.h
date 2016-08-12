//
//  IssueTableViewCell.h
//  AMGitHubApplication
//
//  Created by Амин on 11.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *issueNumber;
@property (strong, nonatomic) IBOutlet UILabel *issueTitle;
@property (strong, nonatomic) IBOutlet UILabel *issueState;
@property (strong, nonatomic) IBOutlet UILabel *issueCreateDate;

@end
