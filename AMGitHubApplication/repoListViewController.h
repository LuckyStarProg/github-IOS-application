//
//  repoListViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 28.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSideBarViewController.h"
#import "repoCell.h"
#import "GitHubRepository.h"
#import "InternetConnectionController.h"
#import "AMDataManager.h"
#import "UIImage+ResizingImg.h"
#import "RepositoryViewController.h"
#import "UIColor+GitHubColor.h"
#import "GitHubApiController.h"
#import "AuthorizedUser.h"
#import "BaseViewController.h"

@interface repoListViewController : BaseViewController

-(instancetype)initWithUpdateNotification:(NSString *)notification;

-(UIImageView *)iconView;
@property (nonatomic)GitHubUser * owner;
@property (nonatomic, readonly)NSUInteger repoCount;
@property (nonatomic)BOOL isAll;
@property (nonatomic)NSString * searchItem;
-(void)addRepos:(NSArray *)repos;
@end
