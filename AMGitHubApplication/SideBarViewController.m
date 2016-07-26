//
//  ViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "SideBarViewController.h"
#import "menuViewController.h"
#import "detailsViewController.h"

@interface SideBarViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic)UIPanGestureRecognizer * pan;
@property (nonatomic)UISwipeGestureRecognizer * swipe;
@property (nonatomic)CGPoint tapPoint;
@property (nonatomic)CGPoint startPoint;
@property (nonatomic)NSTimer * timer;
@property (nonatomic)double time;


@end

@implementation SideBarViewController

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    self.tapPoint=[gestureRecognizer locationInView:self.view];
    self.startPoint=self.frontViewController.view.frame.origin;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    self.time=0.0;
    [self.timer fire];
    return YES;
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if([otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])
//    {
//        return NO;
//    }
//    return NO;
//}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if([otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])
//    {
//        //[self gestureSwipe];
//        self.pan.enabled=NO;
//        //self.pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan)];
//        //self.pan.delegate=self;
//        //[self.pan setState:UIGestureRecognizerStateCancelled];
//        //[gestureRecognizer setState:UIGestureRecognizerStateCancelled];
//        return YES;
//    }
//    return NO;
//}
-(void)timerTick
{
    self.time+=0.01;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

+(SideBarViewController *)sideBarWithFrontVC:(UIViewController *)frontVC andBackVC:(UIViewController *)backVC
{
    SideBarViewController * sideBar=[[SideBarViewController alloc] init];
    if(sideBar)
    {
        sideBar.backViewController=backVC;
        sideBar.frontViewController=frontVC;
    }
    return sideBar;
}

//UIDswipeGestureRecigniser не работает вместе с пан либо наоборот !
- (void)viewDidLoad {
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
    
    self.swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureSwipe)];
    
    self.startPoint=CGPointMake(0, 0);
    [self addChildViewController:self.backViewController];
    [self.view addSubview:self.backViewController.view];
    
    self.frontViewController.view.layer.masksToBounds = NO;
    self.frontViewController.view.clipsToBounds = NO;
    
    CGRect pathRect=self.frontViewController.view.bounds;
    pathRect.size=self.frontViewController.view.frame.size;
    
    self.frontViewController.view.layer.shadowColor=[UIColor blackColor].CGColor;
    self.frontViewController.view.layer.shadowPath=[UIBezierPath bezierPathWithRect:pathRect].CGPath;
    self.frontViewController.view.layer.shadowRadius=10.0;
    self.frontViewController.view.layer.shadowOpacity = 1.0f;
    self.frontViewController.view.layer.rasterizationScale=[UIScreen mainScreen].scale;
    
    [self addChildViewController:self.frontViewController];
    [self.frontViewController.view addGestureRecognizer:self.pan];
    //[self.frontViewController.view addGestureRecognizer:self.swipe];
    [self.view addSubview:self.frontViewController.view];
    
    NSLog(@"Ок, сделаем это!)");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)moovFrontViewOnPosition:(double)xPos
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
    if(self.swipe.direction==UISwipeGestureRecognizerDirectionRight)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             [self moovFrontViewOnPosition:[UIScreen mainScreen].bounds.size.width*0.8];
         } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             [self moovFrontViewOnPosition:0.0];
         } completion:nil];
    }
}
-(void)gesturePan
{
    CGPoint location=[self.pan locationInView:self.view];
    
    
    if(self.startPoint.x+(location.x-self.tapPoint.x)>=0)
    {
        [self moovFrontViewOnPosition:self.startPoint.x+(location.x-self.tapPoint.x)];
    }
    if(self.pan.state==UIGestureRecognizerStateEnded)
    {
            
            if(location.x>self.tapPoint.x)
            {
                self.swipe.direction=UISwipeGestureRecognizerDirectionRight;
            }
            else
            {
                self.swipe.direction=UISwipeGestureRecognizerDirectionLeft;
            }
        
        if(self.time>=0.2)
        {
            if(self.startPoint.x+(location.x-self.tapPoint.x)<self.backViewController.view.bounds.size.width/2 )
            {
                self.swipe.direction=UISwipeGestureRecognizerDirectionLeft;
            }
            else
            {
                self.swipe.direction=UISwipeGestureRecognizerDirectionRight;
            }
        }
        
        [self.timer invalidate];
        [self gestureSwipe];
    }
    
}

-(void)side
{
    if(self.swipe.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        self.swipe.direction=UISwipeGestureRecognizerDirectionRight;
    }
    else
    {
        self.swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    }
    [self gestureSwipe];
}
@end
