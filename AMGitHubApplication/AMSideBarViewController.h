//
//  ViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, SideDirection) {
    SideDirectionRight=0,
    SideDirectionLeft
};
@interface AMSideBarViewController : UIViewController


+(AMSideBarViewController *)sideBarWithFrontVC:(UIViewController *)frontVC andBackVC:(UIViewController *)backVC;

@property (nonatomic)UIViewController * backViewController;
@property (nonatomic)UIViewController * frontViewController;

-(void)side;
@end

