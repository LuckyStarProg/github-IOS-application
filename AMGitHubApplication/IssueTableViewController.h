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

@interface IssueTableViewController : BaseViewController

@property (nonatomic)GitHubIssue * issue;
@property (nonatomic)NSMutableArray<GitHubIssueComment *> * comments;
@property (nonatomic)NSUInteger commentsCount;
@property (nonatomic)BOOL isAll;
@property (nonatomic)NSString * notification;
//@property (nonatomic)UITableView * tableView;
-(void)addComments:(NSArray<GitHubIssueComment *> *)comments;

@end
