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
#import "IssueViewController.h"
#import "IssueTableViewController.h"
#import "GitHubContentManager.h"

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
    
//    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
//    if(tableView.indexPathForSelectedRow==indexPath)
//    {
//        [sider side];
//        return;
//    }
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
        cell=tempCell;
    }
    else
    {
        
        MenuTableViewCell * tableCell=(MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"menuCell%ld",indexPath.row] forIndexPath:indexPath];
        NSLog(@"%@",tableCell);

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

-(void)pushSearch
{
    repoListViewController * searchRepos=[[repoListViewController alloc] initWithUpdateNotification:@"addSearchRepos"];
    searchRepos.searchItem=self.searchItem;
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

-(void)pushLogin
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    [[AuthorizedUser sharedUser] logOut];
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.table.delegate=self;
    self.table.dataSource=self;
    self.view.backgroundColor=[UIColor GitHubColor];
    self.table.backgroundColor=[UIColor GitHubColor];
    self.table.tableFooterView = [UIView new];
    [[GitHubContentManager sharedManager] startManaging];

    [[NSNotificationCenter defaultCenter] addObserver:self.table selector:@selector(reloadData) name:@"Authorized user loaded" object:nil];

    self.methods=[NSArray arrayWithObjects:@"pushSearch",@"pushProfile",@"pushOwndRepos",@"pushEvents",@"pushNews",@"pushIssues",@"pushStaredRepos",@"pushLogin", nil];
    
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
