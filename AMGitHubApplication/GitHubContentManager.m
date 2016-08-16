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
#import "IssueTableViewController.h"
#import "usersListViewController.h"
#import "AlertController.h"
@implementation GitHubContentManager

static GitHubContentManager * gitControllerInstance;
+(GitHubContentManager *)sharedManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^
                  {
                      gitControllerInstance=[[GitHubContentManager alloc] init];
                  });
    return gitControllerInstance;
}

-(instancetype)init
{
    if(gitControllerInstance)
        return nil;
    return [super init];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFollowing:) name:@"Following" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFollowers:) name:@"Followers" object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
             [AlertController showAlertOnVC:repoList withMessage:error.description];
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
                            repoList.isAll=YES;
                            [AlertController showAlertOnVC:repoList withMessage:message];
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
             [AlertController showAlertOnVC:repoList withMessage:error.description];
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
                            repoList.isAll=YES;
                            [AlertController showAlertOnVC:repoList withMessage:message];
                        });
     }];
}

-(void)addOwnEvens:(NSNotification *)not
{
    NewsViewController * eventsViewController=[not object];
    [[GitHubApiController sharedController] eventsForUser:eventsViewController.owner withPer_page:40 andPage:eventsViewController.eventsCount/40+1 Success:^(NSMutableArray<Event *> *events)
    {
        [eventsViewController addEvents:events];
        if(events.count<40)
        {
            eventsViewController.isAll=YES;
        }
    } orFailure:^(NSString * message)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                        eventsViewController.isAll=YES;
                        [AlertController showAlertOnVC:eventsViewController withMessage:message];
                       });
    }];
}

-(void)addResivesNews:(NSNotification *)not
{
    NewsViewController * eventsViewController=[not object];
    [[GitHubApiController sharedController] newsWithPer_page:40 andPage:eventsViewController.eventsCount/40+1 andSuccess:^(NSArray<Event *> *events)
    {
        [eventsViewController addEvents:events];
        if(events.count<40)
        {
            eventsViewController.isAll=YES;
        }
    } orFailure:^(NSString *message)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           eventsViewController.isAll=YES;
                           [AlertController showAlertOnVC:eventsViewController withMessage:message];
                       });
    }];
}

-(void)addOwndIssues:(NSNotification *)not
{
    IssuesViewController * issuesController=[not object];
    [[GitHubApiController sharedController] issuesWithState:issuesController.state andPer_Page:40 andPage:issuesController.issuesCount/40+1 Success:^(NSMutableArray<GitHubIssue *> * issues)
     {
         [issuesController addIssues:issues];
         if(issues.count<40)
         {
             issuesController.isAll=YES;
         }
     } orFailure:^(NSString * message)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            issuesController.isAll=YES;
                            [AlertController showAlertOnVC:issuesController withMessage:message];
                        });
     }];
}

-(void)addReposIssues:(NSNotification *)not
{
    IssuesViewController * issuesController=[not object];
    [[GitHubApiController sharedController] issuesForRepo:issuesController.repo withState:issuesController.state andPer_Page:40 andPage:issuesController.issuesCount/40+1 Success:^(NSMutableArray<GitHubIssue *> * issues)
     {
         [issuesController addIssues:issues];
         if(issues.count<40)
         {
             issuesController.isAll=YES;
         }
     } orFailure:^(NSString * message)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            issuesController.isAll=YES;
                            [AlertController showAlertOnVC:issuesController withMessage:message];
                        });
     }];
}

-(void)addStarredRepos:(NSNotification *)not
{
    repoListViewController * repoList=[not object];
    [[GitHubApiController sharedController] starredReposWithPer_Page:40 andPage:repoList.repoCount/40+1 andSuccess:^(NSMutableArray<GitHubRepository *> * repos)
     {
         [repoList addRepos:repos];
         if(repos.count<40)
         {
             repoList.isAll=YES;
         }
         
         
     } orFailure:^(NSString *message)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            repoList.isAll=YES;
                            [AlertController showAlertOnVC:repoList withMessage:message];
                        });
     }];
}

-(void)addIssueComments:(NSNotification *)not
{
    IssueTableViewController * issueViewController=[not object];
    [[GitHubApiController sharedController] commentsOnIssue:issueViewController.issue withPer_Page:10 andPage:issueViewController.commentsCount/10+1 Success:^(NSMutableArray<GitHubIssueComment *> * comments)
     {
         [issueViewController addComments:comments];
         if(comments.count<10)
         {
             issueViewController.isAll=YES;
         }
     } orFailure:^(NSString * message)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            issueViewController.isAll=YES;
                            [AlertController showAlertOnVC:issueViewController withMessage:message];
                        });
     }];
}

-(void)addFollowers:(NSNotification *)not
{
    usersListViewController * usersList=[not object];
    [[GitHubApiController sharedController] followersForUser:usersList.parentUser andPerPage:40 andPage:usersList.usersCount/40+1 andSuccess:^(NSMutableArray<GitHubUser *> *users)
    {
        [usersList addUsers:users];
        if(users.count<40)
        {
            usersList.isAllUsers=YES;
        }
    } orFailure:^(NSString *message)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           usersList.isAllUsers=YES;
                           [AlertController showAlertOnVC:usersList withMessage:message];
                       });
    }];

}

-(void)addFollowing:(NSNotification *)not
{
    usersListViewController * usersList=[not object];
    [[GitHubApiController sharedController] followingForUser:usersList.parentUser andPerPage:40 andPage:usersList.usersCount/40+1 andSuccess:^(NSMutableArray<GitHubUser *> *users)
    {
        [usersList addUsers:users];
        if(users.count<20)
        {
            usersList.isAllUsers=YES;
        }
    } orFailure:^(NSString *message)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           usersList.isAllUsers=YES;
                           [AlertController showAlertOnVC:usersList withMessage:message];
                       });
    }];
}

@end
