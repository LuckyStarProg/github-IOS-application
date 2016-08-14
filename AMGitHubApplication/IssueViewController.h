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
#import "defaultCollectionViewCell.h"
#import "AMDataManager.h"
#import "bodyCollectionViewCell.h"
#import "GitHubIssueComment.h"
//#import "commentCollectionViewCell.h"
#import "UICollectionViewCell+subviewsHeight.h"
#import "MyCollectionReusableView.h"

@interface IssueViewController : UIViewController
-(instancetype)initWithUpdateNotification:(NSString *)notification;

@property (nonatomic)GitHubIssue * issue;
@property (nonatomic)NSMutableArray<GitHubIssueComment *> * comments;
@property (nonatomic)NSUInteger commentsCount;
@property (nonatomic)BOOL isAll;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic)NSString * notification;
@property (nonatomic)UITableView * tableView;
-(void)addComments:(NSArray<GitHubIssueComment *> *)comments;
//@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
//@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
//@property (strong, nonatomic) IBOutlet UILabel *descriptioLabel;
//@property (strong, nonatomic) IBOutlet UITableView *tableableView;
@end
