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
    cell.backgroundColor=[UIColor colorWithRed:0.10 green:0.30 blue:0.37 alpha:1.0];
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
    [[InternetConnectionController sharedController] performRequestWithReference:@"https://api.github.com/search/repositories" andMethod:@"GET" andParameters:[NSArray arrayWithObject:[NSString stringWithFormat:@"q=%@",searchBar.text]] andSuccess:^(NSData *data) {
        NSError * error=[[NSError alloc] init];
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"%@",dict);
    } orFailure:^(NSString *message) {
        NSLog(@"%@",message);
    }];
    
    //https://api.github.com
    [sider side];
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
    self.view.backgroundColor=[UIColor colorWithRed:0.10 green:0.30 blue:0.37 alpha:1.0];
    self.table.backgroundColor=[UIColor colorWithRed:0.10 green:0.30 blue:0.37 alpha:1.0];
    self.table.tableFooterView = [UIView new];
}
@end
