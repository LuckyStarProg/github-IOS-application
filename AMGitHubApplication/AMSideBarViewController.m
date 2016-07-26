//
//  ViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "AMSideBarViewController.h"
#import "menuViewController.h"
#import "detailsViewController.h"

@interface AMSideBarViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic)UIPanGestureRecognizer * pan;

@property (nonatomic)CGPoint tapPoint;
@property (nonatomic)CGPoint startPoint;
@property (nonatomic)NSTimer * timer;
@property (nonatomic)double time;

@property (nonatomic)SideDirection direction;
@end

@implementation AMSideBarViewController

#pragma mark - Gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    self.tapPoint=[gestureRecognizer locationInView:self.view];
    self.startPoint=self.frontViewController.view.frame.origin;
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.01
                                                target:self
                                              selector:@selector(timerTick)
                                              userInfo:nil
                                               repeats:YES];
    self.time=0.0;
    [self.timer fire];
    
    return YES;
}

#pragma mark - Life Cycle

+(AMSideBarViewController *)sideBarWithFrontVC:(UIViewController *)frontVC andBackVC:(UIViewController *)backVC
{
    AMSideBarViewController * sideBar=[[AMSideBarViewController alloc] init];
    sideBar.backViewController=backVC;
    sideBar.frontViewController=frontVC;
    return sideBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray * array=[NSMutableArray array];
    for(int i=0;i<self.view.subviews.count;++i)
    {
        [array addObject:self.view.subviews[i]];
    }
    
    for(int i=0;i<self.view.subviews.count;++i)
    {
        [array[i] removeFromSuperview];
    }
    
    self.pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan)];
    self.pan.delegate=self;
    
    //self.frontViewController.view.layer.masksToBounds = NO;
    //self.frontViewController.view.clipsToBounds = YES;
    CGRect pathRect=self.frontViewController.view.bounds;
    pathRect.size=self.frontViewController.view.frame.size;
    self.frontViewController.view.layer.shadowColor=[UIColor blackColor].CGColor;
    self.frontViewController.view.layer.shadowPath=[UIBezierPath bezierPathWithRect:pathRect].CGPath;
    self.frontViewController.view.layer.shadowRadius=10.0;
    self.frontViewController.view.layer.shadowOpacity = 1.0f;
    self.frontViewController.view.layer.rasterizationScale=[UIScreen mainScreen].scale;
    
    self.startPoint=CGPointMake(0, 0);
    
    [self addChildViewController:self.backViewController];
    [self.view addSubview:self.backViewController.view];
    [self addChildViewController:self.frontViewController];
    [self.view addSubview:self.frontViewController.view];
    
    [self.frontViewController.view addGestureRecognizer:self.pan];
    NSLog(@"Ок, сделаем это!)");
}

-(void)timerTick
{
    self.time+=0.01;
}

-(void)moveFrontViewOnPosition:(double)xPos
{
    self.navigationController.navigationBar.frame=
               CGRectMake(xPos,
               self.navigationController.navigationBar.frame.origin.y,
               self.navigationController.navigationBar.frame.size.width,
               self.navigationController.navigationBar.frame.size.height);
    
    self.frontViewController.view.frame=
               CGRectMake(xPos,
               self.frontViewController.view.frame.origin.y,
               self.frontViewController.view.frame.size.width,
               self.frontViewController.view.frame.size.height);
}

-(void)gestureSwipe
{
    if(self.direction==SideDirectionRight)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             [self moveFrontViewOnPosition:[UIScreen mainScreen].bounds.size.width*0.8];
         } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             [self moveFrontViewOnPosition:0.0];
         } completion:nil];
    }
}

-(void)gesturePan
{
    CGPoint location=[self.pan locationInView:self.view];
    
    
    if(self.startPoint.x+(location.x-self.tapPoint.x)>=0)
    {
        [self moveFrontViewOnPosition:self.startPoint.x+(location.x-self.tapPoint.x)];
    }
    
    if(self.pan.state==UIGestureRecognizerStateEnded)
    {
            
        if(location.x>self.tapPoint.x)
        {
            self.direction=SideDirectionRight;
        }
        else
        {
            self.direction=SideDirectionLeft;
        }
        
        if(self.time>=0.2)
        {
            if(self.startPoint.x+(location.x-self.tapPoint.x)<self.backViewController.view.bounds.size.width/2 )
            {
                self.direction=SideDirectionLeft;
            }
            else
            {
                self.direction=SideDirectionRight;
            }
        }
        
        [self.timer invalidate];
        [self gestureSwipe];
    }
    
}

-(void)side
{
    if(self.direction==SideDirectionLeft)
    {
        self.direction=SideDirectionRight;
    }
    else
    {
        self.direction=SideDirectionLeft;
    }
    [self gestureSwipe];
}
@end
