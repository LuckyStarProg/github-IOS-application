//
//  usersListViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "usersListViewController.h"
#import "AMDataManager.h"
#import "UIColor+GitHubColor.h"

@interface usersListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic)UIView * shadowView;
@property (nonatomic)AMDataManager * dataManager;
@property (nonatomic)NSString * notification;
@property (nonatomic)NSMutableArray<GitHubUser *> * users;
@end

@implementation usersListViewController

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"reusebleCell"];
    
    if(!self.isAllUsers && indexPath.row==self.users.count-3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:nil];
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
    cell.textLabel.text=self.users[indexPath.row].login;
    if(self.users[indexPath.row].avatarPath)
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
//    UIView * searchView=[[UIView alloc] initWithFrame:CGRectMake(self.shadowView.bounds.size.width/2-65.0, self.shadowView.bounds.size.height/3, 130.0, 80.0)];
//    searchView.backgroundColor=[UIColor SeparatorColor];
//    searchView.layer.cornerRadius=8.0;
//    
//    UILabel * searchLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 130.0, 30.0)];
//    searchLabel.text=@"Loading...";
//    searchLabel.adjustsFontSizeToFitWidth=YES;
//    searchLabel.textAlignment=NSTextAlignmentCenter;
//    searchLabel.textColor=[UIColor GitHubColor];
//    
//    UIActivityIndicatorView * activityInd=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40.0, 10.0, 50.0, 50.0)];
//    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
//    activityInd.color=[UIColor GitHubColor];
//    activityInd.hidesWhenStopped=YES;
//    
//    [searchView addSubview:searchLabel];
//    [searchView addSubview:activityInd];
//    
//    [self.shadowView addSubview:searchView];
    [self.view addSubview:self.loadContentView];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

-(void)setIsAllUsers:(BOOL)isAllUsers
{
    _isAllUsers=isAllUsers;
    if(!self.users.count)
    {
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.noResultView];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    if(self.navigationController.viewControllers.count<2)
//    {
//        UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
//        menuItem.tintColor=[UIColor whiteColor];
//        self.navigationItem.leftBarButtonItem=menuItem;
//    }
    self.users=[NSMutableArray array];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.dataManager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    
    self.shadowView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    
    [self startLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)usersCount
{
    return self.users.count;
}
-(void)addUsers:(NSMutableArray *)users
{
    NSMutableArray * indexPathes=[NSMutableArray array];
    for(NSUInteger i=self.users.count;i<self.users.count+users.count;++i)
    {
        [indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.users addObjectsFromArray:users];
    [self.tableView insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationFade];
    [self.loadContentView removeFromSuperview];
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
