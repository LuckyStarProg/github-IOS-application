//
//  BaseViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+GitHubColor.h"

@interface BaseViewController : UIViewController
@property (nonatomic)UITableView * tableView;
@property (nonatomic)UISearchBar * searchBar;
@property (nonatomic)UIView * loadContentView;
@property (nonatomic)UIView * noResultView;
@property (nonatomic)UIRefreshControl * refresh;

@property (nonatomic)BOOL isRefresh;
@end
