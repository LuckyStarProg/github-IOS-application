//
//  repoListViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 28.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "repoListViewController.h"
#import "AMSideBarViewController.h"
#import "repoCell.h"
#import "GitHubRepository.h"
#import "InternetConnectionController.h"
#import "AMDataManager.h"
#import "UIImage+ResizingImg.h"
#import "RepositoryViewController.h"
#import "UIColor+GitHubColor.h"

@interface repoListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic)UITableView * tableView;
@property (nonatomic)AMDataManager * dataManager;
@property (nonatomic)UIView * shadowView;
@property (nonatomic)UIAlertController* alert;
@end

@implementation repoListViewController

#pragma mark Table delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GitHubRepository * repo=self.repos[indexPath.row];
    RepositoryViewController * repoViewController=(RepositoryViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"repoInfo"];
    repoViewController.repo=repo;
    //UINavigationController * navigation=[[UINavigationController alloc] initWithRootViewController:repoViewController];
    
    [self.navigationController pushViewController:repoViewController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GitHubRepository * repo=self.repos[indexPath.row];
    return [repoCell heightForText:repo.descriptionStr] + 65;//65 - height of other cell elements
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifaer=@"Reusable sell default";
    repoCell * cell;
    GitHubRepository * repo;
    repo=self.repos[indexPath.row];
    
    cell=(repoCell *)[tableView dequeueReusableCellWithIdentifier:identifaer];
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"repoCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.repoName.text= repo.name;
    cell.repoDescription.text=repo.descriptionStr;
    cell.repoStarsLabel.text=repo.stars;
    
    if(repo.user)
    {
        
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
    }
    return cell;
}


#pragma mark Lyfe Cycle

-(void)startSearching
{
    UIView * searchView=[[UIView alloc] initWithFrame:CGRectMake(self.shadowView.bounds.size.width/2-65.0, self.shadowView.bounds.size.height/3, 130.0, 80.0)];
    searchView.backgroundColor=[UIColor SeparatorColor];
    searchView.layer.cornerRadius=8.0;
    
    UILabel * searchLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 130.0, 30.0)];
    searchLabel.text=@"Searching...";
    searchLabel.adjustsFontSizeToFitWidth=YES;
    searchLabel.textAlignment=NSTextAlignmentCenter;
    searchLabel.textColor=[UIColor GitHubColor];
    
    UIActivityIndicatorView * activityInd=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40.0, 10.0, 50.0, 50.0)];
    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityInd.color=[UIColor GitHubColor];
    activityInd.hidesWhenStopped=YES;
    
    [searchView addSubview:searchLabel];
    [searchView addSubview:activityInd];
    
    [self.shadowView addSubview:searchView];
    [self.view addSubview:self.shadowView];
    [activityInd startAnimating];
}

-(void)stopSearching
{
    [self.shadowView removeFromSuperview];
}
-(void)reloadData
{
    [self.tableView reloadData];
    if(!self.repos.count)
    {
        [self.tableView removeFromSuperview];
        UIView * noResultView=[[UIView alloc] initWithFrame:self.view.bounds];
        noResultView.backgroundColor=[UIColor SeparatorColor];
        UILabel * info=[[UILabel alloc] initWithFrame:CGRectMake(noResultView.bounds.size.width/2-100, noResultView.bounds.size.height/2-40, 200.0, 80.0)];
        info.text=@"The search hasn't give any results";
        info.textAlignment=NSTextAlignmentCenter;
        info.numberOfLines=0;
        
        [noResultView addSubview:info];
        [self.view addSubview:noResultView];
    }
}

-(void)dealloc
{
    [self.dataManager cancel];
    [self.dataManager clearData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.title=@"Repositories";
    UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithTitle:@"Enter" style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
    menuItem.tintColor=[UIColor whiteColor];
    menuItem.image=[UIImage imageNamed:@"menu_icon"];
    
    self.navigationItem.leftBarButtonItem=menuItem;
    self.navigationController.navigationBar.alpha=1.0;
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor GitHubColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    //self.tableView.tableHeaderView=self.activityIndicator;
    
    self.repos=[NSMutableArray array];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.dataManager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    
//    self.alert=[UIAlertController alertControllerWithTitle:@"Allah"
//                                                   message:@"Searching..."
//                                            preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//    [self.alert addAction:defaultAction];
//    self.activityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.alert.view.bounds.size.width/2-13, 30, 26, 26)];
//    self.activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
//    self.activityIndicator.hidesWhenStopped=YES;
//    
//    [self.activityIndicator startAnimating];
    
    self.shadowView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    [self startSearching];
    //[self.alert.view addSubview:self.activityIndicator];
    //[self presentViewController:self.alert animated:YES completion:nil];
}

-(void)menuDidTap
{
    AMSideBarViewController * sider=[self.navigationController.parentViewController isKindOfClass:[AMSideBarViewController class]]?(AMSideBarViewController *)self.navigationController.parentViewController:nil;
    [sider side];
}

@end
