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

@interface repoListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation repoListViewController

#pragma mark Table delegate methods


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (self.activityIndicator.isAnimating)
//        return 50.0f;
//    return 0.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (self.activityIndicator.isAnimating)
//        return self.activityIndicator;
//    return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 141.0;
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
    //cell.imageView.image=[UIImage imageWith
    return cell;
}


#pragma mark Lyfe Cycle

-(void)reloadData
{
    [self.tableView beginUpdates];
    //[self.tableView reloadData];
    [self.tableView endUpdates];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    self.title=@"Repositories";
    UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithTitle:@"Enter" style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
    menuItem.tintColor=[UIColor whiteColor];
    menuItem.image=[UIImage imageNamed:@"menu_icon"];
    
    self.navigationItem.leftBarButtonItem=menuItem;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.10 green:0.30 blue:0.37 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //UIView * activityView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.activityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    self.activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    
    //[activityView addSubview:self.activityIndicator];
    self.tableView.tableHeaderView=self.activityIndicator;
    
    self.repos=[NSMutableArray array];
    
    [self.activityIndicator startAnimating];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
}

-(void)menuDidTap
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
    [sider side];
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
