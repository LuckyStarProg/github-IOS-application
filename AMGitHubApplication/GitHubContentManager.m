//
//  GitHubContentManager.m
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "GitHubContentManager.h"
#import "searchBarCell.h"
#import "AMSideBarViewController.h"
#import "GitHubApiController.h"
#import "repoListViewController.h"
#import "GitHubRepository.h"
#import "UIColor+GitHubColor.h"
#import "InternetConnectionController.h"
#import "UserProfileViewController.h"
#import "NewsViewController.h"
#import "UIImage+ResizingImg.h"
#import "AuthorizedUser.h"
#import "MenuTableViewCell.h"
#import "IssuesViewController.h"
#import "IssueViewController.h"
#import "IssueTableViewController.h"

@implementation GitHubContentManager

+(GitHubContentManager *)sharedManager
{
    static GitHubContentManager * gitControllerInstance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^
                  {
                      gitControllerInstance=[[GitHubContentManager alloc] init];
                  });
    return gitControllerInstance;
}

-(void)startManaging
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOwnRepos:) name:@"addOwnRepos" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSearchRepos:) name:@"addSearchRepos" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addResivesNews:) name:@"addResivesNews" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOwnEvens:) name:@"addOwnEvens" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOwndIssues:) name:@"addOwnIssues" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addReposIssues:) name:@"RepoIssues" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addStarredRepos:) name:@"addStarredRepos" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIssueComments:) name:@"addIssueComments" object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)showAllertWithMessage:(NSString *)message onViewController:(UIViewController *)controller
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

-(void)addOwnRepos:(NSNotification *)not
{
    repoListViewController * repoList=[not object];
    [[GitHubApiController sharedController] owndReposByUser:repoList.owner andPer_page:15 andPage:repoList.repoCount/15+1 andSuccess:^(NSData *data)
     {
         NSError * error=nil;
         NSArray * repoArray=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         if(error)
         {
             [self showAllertWithMessage:error.description onViewController:repoList];
             return;
         }
         if(repoArray)
         {
             NSMutableArray * repos=[NSMutableArray array];
             for(NSDictionary * repo in repoArray)
             {
                 [repos addObject:[GitHubRepository repositoryFromDictionary:repo]];
             }
             [repoList addRepos:repos];
         }
         
     } orFailure:^(NSString *message)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self showAllertWithMessage:message onViewController:repoList];
                        });
     }];
}

-(void)addSearchRepos:(NSNotification *)not
{
    repoListViewController * repoList=[not object];
    if(repoList.searchBar)
    {
        [repoList.searchBar removeFromSuperview];
        repoList.searchBar=nil;
    }
    
    [[GitHubApiController sharedController]searchReposByToken:repoList.searchItem andPerPage:15 andPage:repoList.repoCount/15+1 andSuccess:^(NSData *data)
     {
         NSError * error=nil;
         NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         if(error)
         {
             [self showAllertWithMessage:error.description onViewController:repoList];
             return;
         }
         
         NSArray * repoDicts=dict[@"items"];
         if(repoDicts.count==0)
         {
             repoList.isAll=YES;
             return;
         }
         NSMutableArray * repos=[NSMutableArray array];
         for(NSDictionary * repo in repoDicts)
         {
             [repos addObject:[GitHubRepository repositoryFromDictionary:repo]];
         }
         [repoList addRepos:repos];
         
     } orFailure:^(NSString *message)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self showAllertWithMessage:message onViewController:repoList];
                        });
     }];
}

-(void)addOwnEvens:(NSNotification *)not
{
    NewsViewController * eventsViewController=[not object];
    [[GitHubApiController sharedController] eventsForUser:eventsViewController.owner withPer_page:15 andPage:eventsViewController.eventsCount/15+1 andComplation:^(NSArray<Event *> * events)
     {
         [eventsViewController addEvents:events];
         if(events.count<15)
         {
             eventsViewController.isAll=YES;
         }
     }];
}

-(void)addResivesNews:(NSNotification *)not
{
    NewsViewController * eventsViewController=[not object];
    [[GitHubApiController sharedController] newsWithPer_page:15 andPage:eventsViewController.eventsCount/15+1 andComplation:^(NSArray<Event *> * events)
     {
         [eventsViewController addEvents:events];
         if(events.count<15)
         {
             eventsViewController.isAll=YES;
         }
     }];
}

-(void)addOwndIssues:(NSNotification *)not
{
    IssuesViewController * issuesController=[not object];
    [[GitHubApiController sharedController] issuesWithState:issuesController.state andPer_Page:20 andPage:issuesController.issuesCount/20+1 Success:^(NSMutableArray<GitHubIssue *> * issues)
     {
         [issuesController addIssues:issues];
         if(issues.count<20)
         {
             issuesController.isAll=YES;
         }
     } orFailure:^(NSString * message)
     {
         NSLog(@"%@",message);
     }];
}

-(void)addReposIssues:(NSNotification *)not
{
    IssuesViewController * issuesController=[not object];
    [[GitHubApiController sharedController] issuesForRepo:issuesController.repo withState:issuesController.state andPer_Page:20 andPage:issuesController.issuesCount/20+1 Success:^(NSMutableArray<GitHubIssue *> * issues)
     {
         [issuesController addIssues:issues];
         if(issues.count<20)
         {
             issuesController.isAll=YES;
         }
     } orFailure:^(NSString * message)
     {
         NSLog(@"%@",message);
     }];
}

-(void)addStarredRepos:(NSNotification *)not
{
    repoListViewController * repoListController=[not object];
    [[GitHubApiController sharedController] starredReposWithPer_Page:15 andPage:repoListController.repoCount/15+1 andSuccess:^(NSMutableArray<GitHubRepository *> * repos)
     {
         [repoListController addRepos:repos];
         if(repos.count<15)
         {
             repoListController.isAll=YES;
         }
         
         
     } orFailure:^(NSString *message)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self showAllertWithMessage:message onViewController:repoListController];
                        });
     }];
}

-(void)addIssueComments:(NSNotification *)not
{
    IssueTableViewController * issueViewController=[not object];
    [[GitHubApiController sharedController] commentsOnIssue:issueViewController.issue withPer_Page:10 andPage:issueViewController.commentsCount/10+1 Success:^(NSMutableArray<GitHubIssueComment *> * comments)
     {
         [issueViewController addComments:comments];
         if(comments.count<15)
         {
             issueViewController.isAll=YES;
         }
     } orFailure:^(NSString * message)
     {
         NSLog(@"%@",message);
     }];
}

@end
