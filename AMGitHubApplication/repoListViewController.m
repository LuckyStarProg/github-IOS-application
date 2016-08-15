//
//  repoListViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 28.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "repoListViewController.h"

@interface repoListViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic)AMDataManager * dataManager;
@property (nonatomic)UIView * shadowView;
@property (nonatomic)UIAlertController* alert;
@property (nonatomic)NSString * item;
@property (nonatomic)NSMutableArray<GitHubRepository *> * repos;
@property (nonatomic)NSUInteger currentPage;
@property (nonatomic)BOOL direction;
@property (nonatomic)CGPoint lastContentOffset;
@property (nonatomic)NSString * notification;
@property (nonatomic)NSMutableArray * searchedRepos;
@property (nonatomic, weak)NSMutableArray<GitHubRepository *> * showedRepos;
@end

@implementation repoListViewController

#pragma mark Table delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GitHubRepository * repo=self.repos[indexPath.row];
    repo.user.avatarPath=self.repos[indexPath.row].user.avatarPath;
    RepositoryViewController * repoViewController=(RepositoryViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"repoInfo"];
    
    repoViewController.repo=repo;
    [self.navigationController pushViewController:repoViewController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GitHubRepository * repo=self.repos[indexPath.row];
    return [repoCell heightForText:repo.descriptionStr] + 65;//65 - height of other cell elements
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showedRepos.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchedRepos removeAllObjects];
    if(searchText.length==0)
    {
        [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:searchBar afterDelay:0];
        self.showedRepos=self.repos;
        [self.tableView reloadData];
        return;
    }
    for(NSUInteger i=0;i<self.repos.count;++i)
    {
        if([self.repos[i].name rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound || [self.repos[i].descriptionStr rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound )
        {
            [self.searchedRepos addObject:self.repos[i]];
        }
    }
    self.showedRepos=self.searchedRepos;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifaer=@"Reusable sell default";
    repoCell * cell;
    GitHubRepository * repo;
    repo=self.showedRepos[indexPath.row];
    
    if(!self.isAll && indexPath.row==self.repos.count-5 && self.repos==self.showedRepos)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
    }
    
    cell=(repoCell *)[tableView dequeueReusableCellWithIdentifier:identifaer];
    self.showedRepos=self.repos;
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"repoCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.repoName.text= repo.name;
    cell.repoDescription.text=repo.descriptionStr;
    cell.repoStarsLabel.text=repo.stars;
    cell.tag=indexPath.row;
        if(repo.user.avatarPath)
        {
            cell.userAvatar.image=[[UIImage imageWithContentsOfFile:repo.user.avatarPath] toSize:cell.userAvatar.frame.size];
            [cell setNeedsLayout];
        }
        else
        {
            [self.dataManager loadDataWithURLString:repo.user.avatarRef andSuccess:^(NSString * pathToData)
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                {
                    repo.user.avatarPath=pathToData;
                    cell.userAvatar.image=[[UIImage imageWithContentsOfFile:pathToData] toSize:cell.userAvatar.frame.size];
                    [cell setNeedsLayout];
                });
             }
            orFailure:^(NSString * message)
             {
                NSLog(@"%@",message);
             }];
        }
    return cell;
}


#pragma mark Lyfe Cycle

-(void)setIsAll:(BOOL)isAll
{
    _isAll=isAll;
    if(!self.repos.count && _isAll==YES)
    {
        [self.refresh endRefreshing];
        self.tableView.backgroundColor=[UIColor SeparatorColor];
        [self.loadContentView removeFromSuperview];
        self.tableView.tableHeaderView=self.noResultView;
    }
}

-(void)startLoading
{
    self.isRefresh=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];

    [self.view addSubview:self.loadContentView];
}

-(void)stopLoading
{
    [self.loadContentView removeFromSuperview];
}

-(void)reloadData
{
    [self.tableView reloadData];
    if(!self.repos.count)
    {
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.noResultView];
    }
    self.showedRepos=self.searchedRepos;
}

-(void)addRepos:(NSArray *)repos
{
    NSMutableArray<NSIndexPath *> * array=[NSMutableArray array];
    for(NSUInteger i=self.repos.count;i<self.repos.count+repos.count;++i)
    {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.repos addObjectsFromArray:repos];
    if(self.isRefresh)
    {
        [self.tableView reloadData];
        self.isRefresh=NO;
        [self.refresh endRefreshing];
    }
    else
    {
        [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    }
    [self stopLoading];
}

-(void)dealloc
{
    [self.dataManager cancel];
}

-(instancetype)initWithUpdateNotification:(NSString *)notification
{
    if(self=[super init])
    {
        self.notification=notification;
    }
    return self;
}

-(void)refreshDidTap
{
    [self.repos removeAllObjects];
    self.isAll=NO;
    self.isRefresh=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    //self.tableView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;;
    self.title=@"Repositories";
    if(self.navigationController.viewControllers.count<2)
    {
        UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
        menuItem.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=menuItem;
    }
    self.searchBar.delegate=self;
    self.repos=[NSMutableArray array];
    self.showedRepos=self.repos;
    self.searchedRepos=[NSMutableArray array];
    [self.refresh addTarget:self action:@selector(refreshDidTap) forControlEvents:UIControlEventValueChanged];
    self.refresh.tintColor=[UIColor GitHubColor];

    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.dataManager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    
    self.shadowView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    [self startLoading];

}

-(NSUInteger)repoCount
{
    return self.repos.count;
}
-(void)menuDidTap
{
    AMSideBarViewController * sider=[self.navigationController.parentViewController isKindOfClass:[AMSideBarViewController class]]?(AMSideBarViewController *)self.navigationController.parentViewController:nil;
    [sider side];
}

-(UIImageView *)iconView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"repo"]];
}

-(NSString *)description
{
    return @"Owned";
}
@end
