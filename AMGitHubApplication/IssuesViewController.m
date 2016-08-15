//
//  IssuesViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 11.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssuesViewController.h"

@interface IssuesViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic)NSMutableArray<GitHubIssue *> * issues;
@property (nonatomic)NSString * notification;
@property (nonatomic)UISegmentedControl * segmentControl;
@property (nonatomic)UIBarButtonItem * tabBarSegment;
@property (nonatomic)NSMutableArray<GitHubIssue *> * searchedIssues;
@property (nonatomic, weak)NSMutableArray<GitHubIssue *> * showedIssues;
@end

@implementation IssuesViewController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    IssueTableViewController * table=[[IssueTableViewController alloc] init];
    table.issue=self.showedIssues[indexPath.row];
    table.issue.repo=self.repo;

    [self.navigationController pushViewController:table animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showedIssues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IssueTableViewCell * cell=(IssueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"issueCell"];
    
    if(!self.isAll && indexPath.row==self.issues.count-3 && self.issues==self.showedIssues)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
    }
    
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IssueTableViewCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.issueState.text=self.showedIssues[indexPath.row].state;
    cell.issueTitle.text=self.showedIssues[indexPath.row].title;
    cell.issueNumber.text=self.showedIssues[indexPath.row].issueNumber;
    cell.issueCreateDate.text=self.showedIssues[indexPath.row].createDate;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

-(void)setIsAll:(BOOL)isAll
{
    _isAll=isAll;
    if(!self.issues.count && _isAll==YES)
    {
        [self.refresh endRefreshing];
        self.tableView.backgroundColor=[UIColor SeparatorColor];
        [self.loadContentView removeFromSuperview];
        self.tableView.tableHeaderView=self.noResultView;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchedIssues removeAllObjects];
    if(searchText.length==0)
    {
        [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:searchBar afterDelay:0];
        self.showedIssues=self.issues;
        [self.tableView reloadData];
        return;
    }
    for(NSUInteger i=0;i<self.issues.count;++i)
    {
        if([self.issues[i].title rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound || [self.issues[i].issueNumber rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound || [self.issues[i].body rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound)
        {
            [self.searchedIssues addObject:self.issues[i]];
        }
    }
    self.showedIssues=self.searchedIssues;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)addIssues:(NSArray<GitHubIssue *> *)issues
{
    NSMutableArray * array=[NSMutableArray array];
    for(NSUInteger i=self.issues.count;i<self.issues.count+issues.count;++i)
    {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.issues addObjectsFromArray:issues];
    self.showedIssues=self.issues;
    [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:self.searchBar afterDelay:0];
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
    [self.loadContentView removeFromSuperview];
}

-(NSUInteger)issuesCount
{
    return self.showedIssues.count;
}

-(instancetype)initWithUpdateNotification:(NSString *)notification
{
    if(self=[super init])
    {
        self.notification=notification;
    }
    return self;
}

-(void)segmentDidTap
{
    self.isRefresh=YES;
    self.state=self.segmentControl.selectedSegmentIndex==0?@"open":@"closed";
    [self.view addSubview:self.loadContentView];
    [self.issues removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
}

-(void)dealloc
{
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^
    {
        self.tabBarSegment.width=[UIScreen mainScreen].bounds.size.height-35;
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden=YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden=NO;
    self.tabBarSegment.width=[UIScreen mainScreen].bounds.size.width-35;
}

-(void)refreshDidTap
{
    [self.issues removeAllObjects];
    self.isAll=NO;
    self.isRefresh=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.title=@"Issues";
    
    if(self.navigationController.viewControllers.count<2)
    {
        UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
        menuItem.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=menuItem;
    }
    self.searchBar.delegate=self;
    self.issues=[NSMutableArray array];
    self.showedIssues=self.issues;
    self.searchedIssues=[NSMutableArray array];
    
    self.navigationController.toolbar.clipsToBounds=YES;
    self.navigationController.toolbar.autoresizesSubviews=YES;
    
    self.refresh.tintColor=[UIColor GitHubColor];
    [self.refresh addTarget:self action:@selector(refreshDidTap) forControlEvents:UIControlEventValueChanged];
    
    self.segmentControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Open",@"Closed", nil]];

    self.segmentControl.tintColor=[UIColor GitHubColor];
    [self.segmentControl addTarget:self action:@selector(segmentDidTap) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl setSelectedSegmentIndex:0];
    self.segmentControl.autoresizingMask=(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin);
    self.tabBarSegment=[[UIBarButtonItem alloc] initWithCustomView:self.segmentControl];

    self.tabBarSegment.width=self.tableView.frame.size.width-35;
    self.toolbarItems=[NSArray arrayWithObject:self.tabBarSegment];
    [self.segmentControl sendActionsForControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.loadContentView];
}

-(void)menuDidTap
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
    [sider side];
}

@end
