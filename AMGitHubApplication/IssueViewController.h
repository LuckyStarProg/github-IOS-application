//
//  IssueViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 12.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepoAvatarView.h"
#import "GitHubIssue.h"
#import "dataCollectionViewCell.h"
#import "UIColor+GitHubColor.h"
#import "AMGitHubCommentParser.h"

@interface IssueViewController : UIViewController
@property (nonatomic)GitHubIssue * issue;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
//@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
//@property (strong, nonatomic) IBOutlet UILabel *descriptioLabel;
//@property (strong, nonatomic) IBOutlet UITableView *tableableView;
@end
