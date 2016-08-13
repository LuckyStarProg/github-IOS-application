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
#import "detailsViewController.h"
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
//    [[InternetConnectionController sharedController] performRequestWithReference:@"https://api.github.com/user" andMethod:@"GET" andParameters:nil andSuccess:^(NSData *data)
//    {
//        
//    } orFailure:^(NSString *message) {
//        
//    }];
//    return YES;
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    application.statusBarStyle=UIStatusBarStyleLightContent;
    //defaultUserMenuViewController * menu=[storyboard instantiateViewControllerWithIdentifier:@"menu"];
    //NewsViewController * news=[[NewsViewController alloc] initWithUpdateNotification:@"addResivesNews"];//[storyboard instantiateViewControllerWithIdentifier:@"news"];
    //UINavigationController * navigationVC=[[UINavigationController alloc] initWithRootViewController:news];
    [AuthorizedUser readUser];
    //
    //[navigationVC addChildViewController:logInNavigation];
    
    //AMSideBarViewController * sider=[AMSideBarViewController sideBarWithFrontVC:navigationVC andBackVC:menu];
    

    LogInViewController * logIn=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
    self.window.rootViewController=[[UINavigationController alloc] initWithRootViewController:logIn];//[AMSideBarViewController sideBarWithFrontVC:navigation andBackVC:menu];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[AuthorizedUser sharedUser] saveUser];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    LogInViewController * logIn=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
//    UINavigationController * logInNavigation=[[UINavigationController alloc] initWithRootViewController:logIn];
//    AMSideBarViewController * sider=(AMSideBarViewController *)self.window.rootViewController;
//    [sider.frontViewController presentViewController:logInNavigation animated:NO completion:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
