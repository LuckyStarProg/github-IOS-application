//
//  NewsViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 04.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInViewController.h"
#import "EventCell.h"
#import "Event.h"
#import "GitHubApiController.h"
#import "UIColor+GitHubColor.h"
#import "AMSideBarViewController.h"
#import "GitHubUser.h"
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, NewsViewControllerMod)
{
    NewsViewControllerOwnedMod=1,
    NewsViewControllerReceiveMod
};

@interface NewsViewController : BaseViewController

-(instancetype)initWithUpdateNotification:(NSString *)notification;

@property (nonatomic)GitHubUser * owner;
-(UIImageView *)iconView;

@property (nonatomic,readonly)NSUInteger eventsCount;
-(void)addEvents:(NSArray<Event *> *)events;
@property (nonatomic)BOOL isAll;
@end
