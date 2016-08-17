//
//  UserProfileViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 07.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepositoryViewController.h"
#import "GitHubApiController.h"
#import "AuthorizedUser.h"
#import "dataCollectionViewCell.h"
#import "UIColor+GitHubColor.h"
#import "AuthorizedUser.h"
#import "NewsViewController.h"
#import "repoListViewController.h"
#import "AMSideBarViewController.h"
#import "usersListViewController.h"
#import "EditViewController.h"

@interface UserProfileViewController : UIViewController

@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic)GitHubUser * user;
-(void)setUser:(GitHubUser *)user;
@end
