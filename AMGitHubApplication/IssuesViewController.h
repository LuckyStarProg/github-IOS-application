//
//  IssuesViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 11.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "BaseViewController.h"
#import "IssueTableViewCell.h"
#import "GitHubIssue.h"
#import "UIColor+GitHubColor.h"
#import "AMSideBarViewController.h"
#import "IssueViewController.h"
#import "GitHubApiController.h"

@interface IssuesViewController : BaseViewController

-(instancetype)initWithUpdateNotification:(NSString *)notification;

-(void)addIssues:(NSArray<GitHubIssue *> *)issues;
@property (nonatomic)BOOL isAll;
@property (nonatomic, readonly)NSUInteger issuesCount;
@property (nonatomic)NSString * state;
@property (nonatomic)GitHubRepository * repo;
@end
