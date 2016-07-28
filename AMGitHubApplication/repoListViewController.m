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
@property (nonatomic)UITableView * reposTable;
@property (nonatomic)NSArray * repos;
@end

@implementation repoListViewController

#pragma mark Table delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifaer=@"Reusable sell default";
    repoCell * cell;
    GitHubRepository * repo=self.repos[indexPath.row];
    cell=[tableView dequeueReusableCellWithIdentifier:identifaer];
    if(cell==nil)
    {
        cell=[[repoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifaer];
    }
    //cell.userAvatar=re;po;
    
    return cell;
}


#pragma mark Lyfe Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reposTable=[[UITableView alloc] initWithFrame:self.view.bounds];
    self.title=@"Repositories";
    UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithTitle:@"Enter" style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
    menuItem.tintColor=[UIColor whiteColor];
    menuItem.image=[UIImage imageNamed:@"menu_icon"];
    
    self.navigationItem.leftBarButtonItem=menuItem;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.10 green:0.30 blue:0.37 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.reposTable.delegate=self;
    self.reposTable.dataSource=self;
    [self.view addSubview:self.reposTable];
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
