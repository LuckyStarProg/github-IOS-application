//
//  menuViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchBarCell.h"
#import "AMSideBarViewController.h"
#import "repoListViewController.h"
#import "GitHubRepository.h"
#import "UIColor+GitHubColor.h"
#import "InternetConnectionController.h"
#import "UserProfileViewController.h"
#import "NewsViewController.h"
#import "UIImage+ResizingImg.h"
#import "AuthorizedUser.h"
#import "MenuTableViewCell.h"
#import "IssuesViewController.h"
#import "IssueTableViewController.h"
#import "GitHubContentManager.h"

@interface defaultUserMenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *table;

@end
