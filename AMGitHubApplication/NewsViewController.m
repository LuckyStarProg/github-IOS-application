//
//  NewsViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 04.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic)NewsViewControllerMod mod;
@property (nonatomic)NSMutableArray<Event *> * events;
@property (nonatomic)UIView * shadowView;
@property (nonatomic)NSString * notification;
@property (nonatomic)NSMutableArray * searchedEvents;
@property (nonatomic, weak)NSMutableArray<Event *> * showedEvents;
@end

@implementation NewsViewController

#pragma mark - TableView delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell"owner:self options:nil];
    EventCell * cell=[nib objectAtIndex:0];
    [self.showedEvents[indexPath.row] fillCell:cell];
    return [EventCell heightForText:cell.descriptionLabel.text] + 70;//70 - height of other cell elements
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showedEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifaer=@"Reusable sell default";
    EventCell * cell;
    
    if(!self.isAll && indexPath.row==self.events.count-3 && self.events==self.showedEvents)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
    }
    
    cell=(EventCell *)[tableView dequeueReusableCellWithIdentifier:identifaer];
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self.showedEvents[indexPath.row] fillCell:cell];
    return cell;
}

#pragma mark - SearchBar delegate methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchedEvents removeAllObjects];
    if(searchText.length==0)
    {
        [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:searchBar afterDelay:0];
        self.showedEvents=self.events;
        [self.tableView reloadData];
        return;
    }
    for(NSUInteger i=0;i<self.events.count;++i)
    {
        if([self.events[i].headerInfo rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound || [self.events[i].descriptionStr rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound )
        {
            [self.searchedEvents addObject:self.events[i]];
        }
    }
    self.showedEvents=self.searchedEvents;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - Life Cycle

-(void)addEvents:(NSArray<Event *> *)events
{
    NSMutableArray<NSIndexPath *> * array=[NSMutableArray array];
    for(NSUInteger i=self.events.count;i<self.events.count+events.count;++i)
    {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.events addObjectsFromArray:events];
    self.showedEvents=self.events;
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
    [self.noResultView removeFromSuperview];
    self.tableView.tableHeaderView=self.searchBar;
}

-(instancetype)initWithUpdateNotification:(NSString *)notification
{
    if(self=[super init])
    {
        self.notification=notification;
    }
    return self;
}

-(void)setIsAll:(BOOL)isAll
{
    _isAll=isAll;
    if(!self.events.count && _isAll==YES)
    {
        [self.refresh endRefreshing];
        self.tableView.backgroundColor=[UIColor SeparatorColor];
        [self.loadContentView removeFromSuperview];
        self.tableView.tableHeaderView=self.noResultView;
    }
}
-(UIImageView *)iconView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.mod==NewsViewControllerOwnedMod?@"event":@"news"]];
}

-(NSString *)description
{
    return self.title;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isRefresh=YES;
    [self.view addSubview:self.loadContentView];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
}

-(void)refreshDidTap
{
    [self.events removeAllObjects];
    self.isAll=NO;
    self.isRefresh=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.searchBar.delegate=self;
    if(self.navigationController.viewControllers.count<2)
    {
        UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
        menuItem.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=menuItem;
    }
    
    [self.refresh addTarget:self action:@selector(refreshDidTap) forControlEvents:UIControlEventValueChanged];
    self.refresh.tintColor=[UIColor GitHubColor];
    
    self.shadowView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    
    self.events=[NSMutableArray array];
    self.showedEvents=self.events;
    self.searchedEvents=[NSMutableArray array];
    
}

-(NSUInteger)eventsCount
{
    return self.events.count;
}
-(void)menuDidTap
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
    [sider side];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
