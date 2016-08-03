//
//  menuViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "defaultUserMenuViewController.h"
#import "searchBarCell.h"
#import "AMSideBarViewController.h"
#import "InternetConnectionController.h"
#import "repoListViewController.h"
#import "GitHubRepository.h"
#import "UIColor+GitHubColor.h"

@interface defaultUserMenuViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic)UISearchBar * reposSearchBar;
@end

@implementation defaultUserMenuViewController

#pragma mark Table delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifaer=@"Reusable sell default";
    static NSString * searchIdentifire=@"Reusable sell search";
    
    UITableViewCell * cell;
    if(indexPath.row==0)
    {
        searchBarCell * tempCell=(searchBarCell *)[tableView dequeueReusableCellWithIdentifier:searchIdentifire];
        if(!tempCell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"searchBarCell"owner:self options:nil];
            tempCell = [nib objectAtIndex:0];
        }
        tempCell.search.delegate=self;
        cell=tempCell;
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:identifaer];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifaer];
        }
    }
    cell.backgroundColor=[UIColor GitHubColor];
   if(indexPath.row)
    {
        cell.textLabel.text=@"allah";
        cell.textLabel.textColor=[UIColor whiteColor];
        NSLog(@"%f",cell.frame.origin.y);
    }
    else
    {
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    }
    return cell;
}

#pragma mark Search Bar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    repoListViewController * repoController=[[repoListViewController alloc] init];
    [[InternetConnectionController sharedController] performRequestWithReference:@"https://api.github.com/search/repositories" andMethod:@"GET" andParameters:[NSArray arrayWithObject:[NSString stringWithFormat:@"q=%@",searchBar.text]] andSuccess:^(NSData *data) {
        NSError * error=nil;
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(error)
        {
           [self showAllertWithMessage:error.description];
            return;
        }
        if(dict)
        {
            NSArray * repoDicts=dict[@"items"];
            for(NSDictionary * repo in repoDicts)
            {
                [repoController.repos addObject:[GitHubRepository repositoryFromDictionary:repo]];
            }
            [repoController reloadData];
            [repoController stopSearching];
        }
    } orFailure:^(NSString *message)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self showAllertWithMessage:message];
            [repoController stopSearching];
        });
    }];
    [sider setNewFrontViewController:[[UINavigationController alloc] initWithRootViewController:repoController]];
    searchBar.showsCancelButton=NO;
    searchBar.text=@"";
    //https://api.github.com
    [sider side];
}

-(void)showAllertWithMessage:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    [sider.frontViewController presentViewController:alert animated:YES completion:nil];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
    searchBar.text=@"";
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton=YES;
    return YES;
}

#pragma mark Life cycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.view.backgroundColor=[UIColor GitHubColor];
    self.table.backgroundColor=[UIColor GitHubColor];
    self.table.tableFooterView = [UIView new];
    
    [[UITextField appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
}
@end
