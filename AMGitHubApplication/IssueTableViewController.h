//
//  IssueTableViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "BaseViewController.h"
#import "GitHubIssue.h"
#import "GitHubIssueComment.h"
#import "AuthorizedUser.h"
#import "IssueHeaderReusableView.h"
#import "UIColor+GitHubColor.h"
#import "AMGitHubCommentParser.h"
#import "bodyCollectionViewCell.h"
#import "AMDataManager.h"
#import "IssuTableViewCell.h"
#import "CommentTableViewCell.h"
#import "AddCommentViewController.h"
#import "UserProfileViewController.h"

@interface IssueTableViewController : BaseViewController

@property (nonatomic)GitHubIssue * issue;
@property (nonatomic)NSMutableArray<GitHubIssueComment *> * comments;
@property (nonatomic)NSUInteger commentsCount;
@property (nonatomic)BOOL isAll;
@property (nonatomic)NSString * notification;

-(void)addComments:(NSArray<GitHubIssueComment *> *)comments;

@end
