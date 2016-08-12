//
//  BaseViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic)UITableView * tableView;
@property (nonatomic)UISearchBar * searchBar;
@property (nonatomic)UIView * loadContentView;
@property (nonatomic)UIView * noResultView;

@property NSLayoutConstraint *trailing;
@property NSLayoutConstraint *leading;
@property NSLayoutConstraint *bottom;
@property NSLayoutConstraint *top;
@end
