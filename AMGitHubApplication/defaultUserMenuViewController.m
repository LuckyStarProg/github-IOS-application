//
//  menuViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "defaultUserMenuViewController.h"

@interface defaultUserMenuViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic)UISearchBar * reposSearchBar;
@property (nonatomic)NSString * searchItem;
@property (nonatomic)repoListViewController * searchReposViewController;
@property (nonatomic)NSArray * methods;
@end

@implementation defaultUserMenuViewController

#pragma mark Table delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEL selector = NSSelectorFromString(self.methods[indexPath.row]);
    ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
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
        tempCell.search.delegate=self;
        cell=tempCell;
    }
    else
    {
        
        MenuTableViewCell * tableCell=(MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"menuCell%ld",indexPath.row] forIndexPath:indexPath];

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
    self.reposSearchBar=searchBar;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    [[AuthorizedUser sharedUser] logOut];
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)menuWillHide
{
    [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:self.reposSearchBar afterDelay:0];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillHide) name:@"FrontViewControllerWillApeared" object:nil];
    
    self.methods=[NSArray arrayWithObjects:@"pushSearch",@"pushProfile",@"pushOwndRepos",@"pushEvents",@"pushNews",@"pushIssues",@"pushStaredRepos",@"pushLogin", nil];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
}


@end
