//
//  repoListViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 28.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface repoListViewController : UIViewController

-(void)reloadData;

@property (nonatomic)UIActivityIndicatorView * activityIndicator;
@property (nonatomic)NSMutableArray * repos;
@end
