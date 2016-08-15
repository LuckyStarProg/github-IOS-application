//
//  usersListViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 10.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "BaseViewController.h"
#import "GitHubUser.h"
#import "AMDataManager.h"
#import "UIColor+GitHubColor.h"
#import "UserProfileViewController.h"

@interface usersListViewController : BaseViewController

-(instancetype)init;
-(instancetype)initWithUpdateNotification:(NSString *)notification;
-(void)addUsers:(NSMutableArray *)users;
@property (nonatomic, readonly)NSUInteger usersCount;
@property (nonatomic)BOOL isAllUsers;
@property (nonatomic)GitHubUser * parentUser;
@end
