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

-(void)reloadData
{
    [self.tableView reloadData];
}

-(void)dealloc
{
    [self.dataManager cancel];
    [self.dataManager clearData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    self.title=@"Repositories";
    UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithTitle:@"Enter" style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
    menuItem.tintColor=[UIColor whiteColor];
    menuItem.image=[UIImage imageNamed:@"menu_icon"];
    
    self.navigationItem.leftBarButtonItem=menuItem;
    self.navigationController.navigationBar.alpha=1.0;
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor GitHubColor];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.activityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    self.activityIndicator.hidesWhenStopped=YES;

    self.tableView.tableHeaderView=self.activityIndicator;
    
    self.repos=[NSMutableArray array];
    
    [self.activityIndicator startAnimating];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    self.dataManager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
}

-(void)menuDidTap
{
    AMSideBarViewController * sider=[self.navigationController.parentViewController isKindOfClass:[AMSideBarViewController class]]?(AMSideBarViewController *)self.navigationController.parentViewController:nil;
    [sider side];
}

@end
