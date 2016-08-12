//
//  menuViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "defaultUserMenuViewController.h"
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

@interface defaultUserMenuViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic)UISearchBar * reposSearchBar;
//@property (nonatomic)NSArray * menuItems;
@property (nonatomic)NSString * searchItem;
@property (nonatomic)repoListViewController * searchReposViewController;
@property (nonatomic)NSArray * methods;
@end

@implementation defaultUserMenuViewController

#pragma mark Table delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    if(tableView.indexPathForSelectedRow==indexPath)
    {
        [sider side];
        return;
    }
    SEL selector = NSSelectorFromString(self.methods[indexPath.row]);
    ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
 //   UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:self.menuItems[indexPath.row-1]];
//    navi.navigationBar.alpha=1.0;
//    navi.navigationBar.translucent=NO;
//    navi.navigationBar.barTintColor=[UIColor GitHubColor];
//    navi.navigationBar.tintColor=[UIColor whiteColor];
//    [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [sider setNewFrontViewController:navi];
//    [sider side];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.methods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell;
    if(indexPath.row==0)
    {
        searchBarCell * tempCell=(searchBarCell *)[tableView dequeueReusableCellWithIdentifier:@"searchCell"];
//        if(!tempCell)
//        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"searchBarCell"owner:self options:nil];
//            tempCell = [nib objectAtIndex:0];
//        }
        tempCell.search.delegate=self;
        //tempCell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        cell=tempCell;
        //cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    }
    else
    {
        
        MenuTableViewCell * tableCell=(MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"menuCell%ld",indexPath.row] forIndexPath:indexPath];
        NSLog(@"%@",tableCell);
        
//        if(!cell)
//        {
//            cell=[[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:];
////            [cell setGitHubImageView:[[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 30, 30)]];
////            [cell setGitHubNameLabel:[[UILabel alloc] initWithFrame:CGRectMake(50, 0, cell.bounds.size.width-50, cell.bounds.size.height)]];
////            [cell addSubview:cell.GitHubImageView];
////            [cell addSubview:cell.GitHubNameLabel];
//            
//        }
//        tableCell.menuIconView.clipsToBounds=YES;
//        tableCell.menuIconView.autoresizesSubviews=YES;
//        tableCell.menuIconView.opaque=YES;
//        tableCell.menuIconView.clearsContextBeforeDrawing=YES;
//        tableCell.menuIconView.image=[self.menuItems[indexPath.row-1] iconView].image;
//        cell.GitHubImageView.clipsToBounds=YES;
//        cell.GitHubImageView.autoresizesSubviews=YES;
//        cell.GitHubImageView.opaque=YES;
//        cell.GitHubImageView.clearsContextBeforeDrawing=YES;
//        cell.GitHubImageView.image=[self.menuItems[indexPath.row-1] iconView].image;
//        
//        tableCell.menuName.text=[NSString stringWithFormat:@"%@",self.menuItems[indexPath.row-1]];
//        tableCell.menuName.textColor=[UIColor whiteColor];
        if(indexPath.row==1)
        {
            tableCell.menuIconView.clipsToBounds=YES;
            tableCell.menuIconView.autoresizesSubviews=YES;
            tableCell.menuIconView.opaque=YES;
            tableCell.menuIconView.clearsContextBeforeDrawing=YES;
            tableCell.menuIconView.image=[UIImage imageWithContentsOfFile:[AuthorizedUser sharedUser].avatarPath];
            
            tableCell.menuName.text=[AuthorizedUser sharedUser].login;
            tableCell.menuName.textColor=[UIColor whiteColor];
            tableCell.menuIconView.layer.cornerRadius=tableCell.menuIconView.frame.size.width/2;
        }
        cell=tableCell;
    }
    return cell;
}

#pragma mark Search Bar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.searchItem=searchBar.text;
    
    [self pushSearch];
    searchBar.showsCancelButton=NO;
    searchBar.text=@"";
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
    searchBar.clearsContextBeforeDrawing=YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton=YES;
    return YES;
}

#pragma mark Life cycle
//-(void)viewWillAppear:(BOOL)animated
//{
//    [self.menuItems[0] setUser:[AuthorizedUser sharedUser]];
////    [[GitHubApiController sharedController] userFromLogin:[AuthorizedUser sharedUser].login andComplation:^(GitHubUser * user)
////     {
////         user.avatarPath=[AuthorizedUser sharedUser].avatarPath;
////         [self.menuItems[0] setUser:user];
////     }];
//    [self.menuItems[1] setOwner:[AuthorizedUser sharedUser]];
//    [self.menuItems[2] setOwner:[AuthorizedUser sharedUser]];
//    [super viewWillAppear:animated];
//}

-(void)showAllertWithMessage:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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
             [self showAllertWithMessage:error.description];
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
                            [self showAllertWithMessage:message];
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
    
    [[GitHubApiController sharedController]searchReposByToken:self.searchItem andPerPage:15 andPage:repoList.repoCount/15+1 andSuccess:^(NSData *data)
     {
         NSError * error=nil;
         NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         if(error)
         {
             [self showAllertWithMessage:error.description];
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
                            [self showAllertWithMessage:message];
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
                           [self showAllertWithMessage:message];
                       });
    }];
}

-(void)pushSearch
{
    repoListViewController * searchRepos=[[repoListViewController alloc] initWithUpdateNotification:@"addSearchRepos"];
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:searchRepos];
    
    [sider setNewFrontViewController:navi];
    [sider side];
}

-(void)pushProfile
{
    UserProfileViewController * profile=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profile"];
    [profile setUser:[AuthorizedUser sharedUser]];
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:profile];
    [sider setNewFrontViewController:navi];
    [sider side];
}

-(void)pushOwndRepos
{
    repoListViewController * repos=[[repoListViewController alloc] initWithUpdateNotification:@"addOwnRepos"];
    repos.owner=[AuthorizedUser sharedUser];
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:repos];
    [sider setNewFrontViewController:navi];
    [sider side];
}

-(void)pushEvents
{
    NewsViewController * events=[[NewsViewController alloc] initWithUpdateNotification:@"addOwnEvens"];
    events.title=@"Events";
    events.owner=[AuthorizedUser sharedUser];
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:events];
    [sider setNewFrontViewController:navi];
    [sider side];
}

-(void)pushNews
{
    NewsViewController * news=[[NewsViewController alloc] initWithUpdateNotification:@"addResivesNews"];
    news.title=@"News";
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:news];
    [sider setNewFrontViewController:navi];
    [sider side];
}

-(void)pushIssues
{
    IssuesViewController * issuesController=[[IssuesViewController alloc] initWithUpdateNotification:@"addOwnIssues"];
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:issuesController];
    [sider setNewFrontViewController:navi];
    [sider side];
}

-(void)pushStaredRepos
{
    repoListViewController * repoList=[[repoListViewController alloc] initWithUpdateNotification:@"addStarredRepos"];
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:repoList];
    [sider setNewFrontViewController:navi];
    [sider side];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.table.delegate=self;
    self.table.dataSource=self;
    self.view.backgroundColor=[UIColor GitHubColor];
    self.table.backgroundColor=[UIColor GitHubColor];
    self.table.tableFooterView = [UIView new];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self.table selector:@selector(reloadData) name:@"SideRight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.table selector:@selector(reloadData) name:@"Authorized user loaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOwnRepos:) name:@"addOwnRepos" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSearchRepos:) name:@"addSearchRepos" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addResivesNews:) name:@"addResivesNews" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOwnEvens:) name:@"addOwnEvens" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOwndIssues:) name:@"addOwnIssues" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addReposIssues:) name:@"RepoIssues" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addStarredRepos:) name:@"addStarredRepos" object:nil];
    
    self.methods=[NSArray arrayWithObjects:@"pushSearch",@"pushProfile",@"pushOwndRepos",@"pushEvents",@"pushNews",@"pushIssues",@"pushStaredRepos", nil];
    
//    UserProfileViewController * profile=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profile"];
//    
//    self.menuItems=[NSArray arrayWithObjects:
//                    profile,
//                    [[repoListViewController alloc] initWithUpdateNotification:@"addOwnRepos"],
//                    [[NewsViewController alloc] initWithMod:NewsViewControllerOwnedMod],
//                    [[NewsViewController alloc] initWithMod:NewsViewControllerReceiveMod], nil];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
}


@end
