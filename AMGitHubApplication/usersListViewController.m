//
//  usersListViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "usersListViewController.h"

@interface usersListViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic)UIView * shadowView;
@property (nonatomic)AMDataManager * dataManager;
@property (nonatomic)NSString * notification;
@property (nonatomic)NSMutableArray<GitHubUser *> * users;
@property (nonatomic)NSMutableArray<GitHubUser *> * searchedUseers;
@property (nonatomic,weak)NSMutableArray<GitHubUser *> * showedUsers;
@end

@implementation usersListViewController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UserProfileViewController * profile=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profile"];
    [[GitHubApiController sharedController] userFromLogin:self.users[indexPath.row].login andComplation:^(GitHubUser * user)
     {
         user.avatarPath=self.users[indexPath.row].avatarPath;
         profile.user=user;
     }];
    [self.navigationController pushViewController:profile animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"reusebleCell"];
    
    if(!self.isAllUsers && indexPath.row==self.users.count-3 && self.users==self.showedUsers)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
    }
    
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusebleCell"];
        cell.imageView.clipsToBounds=YES;
        cell.imageView.autoresizesSubviews=YES;
        cell.imageView.opaque=YES;
        cell.imageView.clearsContextBeforeDrawing=YES;
    }
    cell.imageView.image=[UIImage imageNamed:@"avatar"];
    cell.textLabel.text=self.showedUsers[indexPath.row].login;
    if(self.showedUsers[indexPath.row].avatarPath)
    {
        cell.imageView.image=[UIImage imageWithContentsOfFile:self.users[indexPath.row].avatarPath];
        cell.imageView.layer.cornerRadius=cell.frame.size.height/2;
        [cell setNeedsLayout];
    }
    else
    {
        [self.dataManager loadDataWithURLString:self.users[indexPath.row].avatarRef andSuccess:^(NSString * path)
         {
             self.users[indexPath.row].avatarPath=path;
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                cell.imageView.image=[UIImage imageWithContentsOfFile:path];
                                cell.imageView.layer.cornerRadius=cell.frame.size.height/2;
                                [cell setNeedsLayout];
                            });
            } orFailure:^(NSString * message)
            {
                NSLog(@"%@",message);
            }];
    }
    return cell;
}

-(void)startLoading
{
    self.isRefresh=YES;
    [self.view addSubview:self.loadContentView];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showedUsers.count;
}

-(void)setIsAllUsers:(BOOL)isAllUsers
{
    _isAllUsers=isAllUsers;
    if(!self.users.count && _isAllUsers==YES)
    {
        [self.refresh endRefreshing];
        self.tableView.backgroundColor=[UIColor SeparatorColor];
        [self.loadContentView removeFromSuperview];
        self.tableView.tableHeaderView=self.noResultView;
    }
}

-(void)refreshDidSwipe
{
    [self.users removeAllObjects];
    self.isAllUsers=NO;
    self.isRefresh=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refresh addTarget:self action:@selector(refreshDidSwipe) forControlEvents:UIControlEventValueChanged];
    
    self.searchBar.delegate=self;
    self.users=[NSMutableArray array];
    self.showedUsers=self.users;
    self.searchedUseers=[NSMutableArray array];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.dataManager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    
    self.shadowView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    [self performSelector:@selector(refreshDidSwipe) withObject:nil afterDelay:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)usersCount
{
    return self.users.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchedUseers removeAllObjects];
    if(searchText.length==0)
    {
        [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:searchBar afterDelay:0];
        self.showedUsers=self.users;
        [self.tableView reloadData];
        return;
    }
    for(NSUInteger i=0;i<self.users.count;++i)
    {
        if([self.users[i].login rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound)
        {
            [self.searchedUseers addObject:self.users[i]];
        }
    }
    self.showedUsers=self.searchedUseers;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)addUsers:(NSMutableArray *)users
{
    NSMutableArray * indexPathes=[NSMutableArray array];
    for(NSUInteger i=self.users.count;i<self.users.count+users.count;++i)
    {
        [indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.users addObjectsFromArray:users];
    self.showedUsers=self.users;
    [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:self.searchBar afterDelay:0];
    if(self.isRefresh)
    {
        [self.tableView reloadData];
        self.isRefresh=NO;
        [self.refresh endRefreshing];
    }
    else
    {
        [self.tableView insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationFade];
        
    }
    [self.noResultView removeFromSuperview];
    [self.loadContentView removeFromSuperview];
    [self.tableView.tableHeaderView removeFromSuperview];
    self.tableView.tableHeaderView=nil;
}

-(instancetype)initWithUpdateNotification:(NSString *)notification
{
    if(self=[super init])
    {
        self.notification=notification;
        self.users=[NSMutableArray array];
    }
    return self;
}

-(instancetype)init
{
    if(self=[super init])
    {
        self.users=[NSMutableArray array];
    }
    return self;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
