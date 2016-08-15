//
//  AppDelegate.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "AppDelegate.h"
#import "AMSideBarViewController.h"
#import "defaultUserMenuViewController.h"
#import "LogInViewController.h"
#import "repoListViewController.h"
#import "NewsViewController.h"
#import "InternetConnectionController.h"
#import "AuthorizedUser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    application.statusBarStyle=UIStatusBarStyleLightContent;
    [AuthorizedUser readUser];

    LogInViewController * logIn=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
    self.window.rootViewController=[[UINavigationController alloc] initWithRootViewController:logIn];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[AuthorizedUser sharedUser] saveUser];
}

@end
