//
//  BaseViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property NSLayoutConstraint *trailing;
@property NSLayoutConstraint *leading;
@property NSLayoutConstraint *bottom;
@property NSLayoutConstraint *top;
@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha=1.0;
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor GitHubColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)setSearchBar:(UISearchBar *)searchBar
{
    
    if(!searchBar)
    {
        self.tableView.tableHeaderView=nil;
    }
    _searchBar=searchBar;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:self.tableView];
    
    self.view.clipsToBounds=YES;
    self.view.autoresizesSubviews=YES;
    self.view.opaque=YES;
    self.view.clearsContextBeforeDrawing=YES;
    
    self.searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.searchBar.backgroundColor=[UIColor GitHubColor];
    self.searchBar.barStyle=UIBarStyleBlackTranslucent;
    self.tableView.tableHeaderView=self.searchBar;
    
    self.loadContentView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.loadContentView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    
    UIView * searchView=[[UIView alloc] initWithFrame:CGRectMake(self.loadContentView.bounds.size.width/2-65.0, self.loadContentView.bounds.size.height/3, 130.0, 80.0)];
    searchView.backgroundColor=[UIColor SeparatorColor];
    searchView.layer.cornerRadius=8.0;
    
    UILabel * searchLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 130.0, 30.0)];
    searchLabel.text=@"Loading...";
    searchLabel.adjustsFontSizeToFitWidth=YES;
    searchLabel.textAlignment=NSTextAlignmentCenter;
    searchLabel.textColor=[UIColor GitHubColor];
    
    UIActivityIndicatorView * activityInd=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40.0, 10.0, 50.0, 50.0)];
    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityInd.color=[UIColor GitHubColor];
    activityInd.hidesWhenStopped=YES;
    [activityInd startAnimating];
    
    [searchView addSubview:searchLabel];
    [searchView addSubview:activityInd];
    [self.loadContentView addSubview:searchView];
    
    self.noResultView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.noResultView.backgroundColor=[UIColor SeparatorColor];
    
    UILabel * info=[[UILabel alloc] initWithFrame:CGRectMake(self.noResultView.bounds.size.width/2-100, self.noResultView.bounds.size.height/2+30, 200.0, 80.0)];
    info.text=@"No results";
    info.textAlignment=NSTextAlignmentCenter;
    info.numberOfLines=1;
    
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.noResultView.bounds.size.width/2-105, self.noResultView.bounds.size.height/2-160, 210.0, 180.0)];
    imageView.image=[UIImage imageNamed:@"github-cat"];
    
    [self.noResultView addSubview:imageView];
    [self.noResultView addSubview:info];
    
    self.refresh=[[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-15, 0, 40, 40)];
    [self.tableView addSubview:self.refresh];
    [self setConstraints];
    // Do any additional setup after loading the view.
}

-(void)setConstraints
{
    self.trailing =[NSLayoutConstraint
                                   constraintWithItem:self.tableView
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f];
    
    self.leading = [NSLayoutConstraint
                                   constraintWithItem:self.tableView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    
    self.bottom =[NSLayoutConstraint
                                 constraintWithItem:self.tableView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                 constant:0.f];
    
    self.top =[NSLayoutConstraint
                              constraintWithItem:self.tableView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0f
                              constant:0.f];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:self.trailing];
    [self.view addConstraint:self.leading];
    [self.view addConstraint:self.bottom];
    [self.view addConstraint:self.top];
}

@end
