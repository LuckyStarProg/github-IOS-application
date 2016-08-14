//
//  IssuesViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 11.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssuesViewController.h"
#import "IssueTableViewController.h"

@interface IssuesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic)NSMutableArray<GitHubIssue *> * issues;
@property (nonatomic)NSString * notification;
@property (nonatomic)UISegmentedControl * segmentControl;
@property (nonatomic)UIBarButtonItem * tabBarSegment;
@end

@implementation IssuesViewController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    IssueTableViewController * table=[[IssueTableViewController alloc] init];
    table.issue=self.issues[indexPath.row];
//    IssueViewController * issueDisc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"issuesViewController"];
//    issueDisc.notification=@"addIssueComments";
//    issueDisc.issue=self.issues[indexPath.row];
    [self.navigationController pushViewController:table animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.issues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IssueTableViewCell * cell=(IssueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"issueCell"];
    
    if(indexPath.row==self.issues.count-3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
    }
    
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IssueTableViewCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.issueState.text=self.issues[indexPath.row].state;
    cell.issueTitle.text=self.issues[indexPath.row].title;
    cell.issueNumber.text=self.issues[indexPath.row].issueNumber;
    cell.issueCreateDate.text=self.issues[indexPath.row].createDate;
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
-(void)addIssues:(NSArray<GitHubIssue *> *)issues
{
    NSMutableArray * array=[NSMutableArray array];
    for(NSUInteger i=self.issues.count;i<self.issues.count+issues.count;++i)
    {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.issues addObjectsFromArray:issues];
    if(self.isRefresh)
    {
        [self.tableView reloadData];
        self.isRefresh=NO;
        [self.refresh endRefreshing];
    }
    else
    {
        [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        [self.loadContentView removeFromSuperview];
    }
}

-(NSUInteger)issuesCount
{
    return self.issues.count;
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
    self.state=self.segmentControl.selectedSegmentIndex==0?@"open":@"closed";
    [self.issues removeAllObjects];
    [self.tableView reloadData];
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
    
    self.issues=[NSMutableArray array];
    self.navigationController.toolbar.clipsToBounds=YES;
    self.navigationController.toolbar.autoresizesSubviews=YES;
    
    self.refresh.tintColor=[UIColor GitHubColor];
    [self.refresh addTarget:self action:@selector(refreshDidTap) forControlEvents:UIControlEventValueChanged];
    
    self.segmentControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Open",@"Closed", nil]];
    //self.segmentControl.frame=CGRectMake(0, 8, self.view.bounds.size.width-30, self.navigationController.toolbar.bounds.size.height-16);
    self.segmentControl.tintColor=[UIColor GitHubColor];
    [self.segmentControl addTarget:self action:@selector(segmentDidTap) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl setSelectedSegmentIndex:0];
    self.segmentControl.autoresizingMask=(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin);
    self.tabBarSegment=[[UIBarButtonItem alloc] initWithCustomView:self.segmentControl];
    self.navigationController.toolbarHidden=NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
