//
//  ViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "ViewController.h"
#import "menuViewController.h"
#import "detailsViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic)UIView * all;
@property (nonatomic)detailsViewController * detailController;
@property (nonatomic)UIPanGestureRecognizer * pan;
@property (nonatomic)UISwipeGestureRecognizer * swipe;
@property (nonatomic)CGPoint tapPoint;
@property (nonatomic)CGPoint startPoint;
@property (nonatomic)NSTimer * timer;
@property (nonatomic)double time;
@end

@implementation ViewController

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    self.tapPoint=[gestureRecognizer locationInView:self.view];
    self.startPoint=self.detailController.view.frame.origin;
    [self.timer invalidate];
    return YES;
}

-(void)timerTick
{
    self.time+=0.1;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    self.detailController=[self.storyboard instantiateViewControllerWithIdentifier:@"amin"];
    menuViewController * menuController=[self.storyboard instantiateViewControllerWithIdentifier:@"allah"];
    //menuController.view.frame=[UIScreen mainScreen].bounds;
    
    //detailController.view.frame=[UIScreen mainScreen].bounds;
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
    self.swipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureSwipe)];
    //[self.swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    self.startPoint=CGPointMake(0, 0);
    [self addChildViewController:menuController];
    [self.view addSubview:menuController.view];
    [self addChildViewController:self.detailController];
    [self.detailController.view addGestureRecognizer:self.swipe];
    [self.detailController.view addGestureRecognizer:self.pan];

    //[self.detailController.view gesture]
    
    [self.view addSubview:self.detailController.view];
    NSLog(@"Ок, сделаем это!)");
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(UIView *)copyView:(UIView *)view
//{
//    UIView * result=[[UIView alloc] initWithFrame:view.frame];
//    
//}

-(void)gesturePan
{
    CGPoint location=[self.pan locationInView:self.view];
    
    NSLog(@"%f",self.navigationController.navigationBar.bounds.origin.x);
    if(self.startPoint.x+(location.x-self.tapPoint.x)>=0)
    {
    self.navigationController.navigationBar.frame=
    CGRectMake(self.startPoint.x+(location.x-self.tapPoint.x),
               self.navigationController.navigationBar.frame.origin.y,
               self.navigationController.navigationBar.frame.size.width,
               self.navigationController.navigationBar.frame.size.height);
    
    self.detailController.view.frame=
    CGRectMake(self.startPoint.x+(location.x-self.tapPoint.x),
               self.detailController.view.frame.origin.y,
               self.detailController.view.frame.size.width,
               self.detailController.view.frame.size.height);
        
        if(self.pan.state==UIGestureRecognizerStateEnded)
        {
            if(self.detailController.view.frame.origin.x<[UIScreen mainScreen].bounds.size.width*0.8/2)
            {
                if(self.time<0.5)
                {
                    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
                    self.time=0.0;
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
                     {
                         self.navigationController.navigationBar.frame=
                         CGRectMake([UIScreen mainScreen].bounds.size.width*0.8,
                                    self.navigationController.navigationBar.frame.origin.y,
                                    self.navigationController.navigationBar.frame.size.width,
                                    self.navigationController.navigationBar.frame.size.height);
                         
                         self.detailController.view.frame=
                         CGRectMake([UIScreen mainScreen].bounds.size.width*0.8,
                                    self.detailController.view.frame.origin.y,
                                    self.detailController.view.frame.size.width,
                                    self.detailController.view.frame.size.height);
                     } completion:nil];
                }
                else
                {
                    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
                    self.time=0.0;
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
                {
                    self.navigationController.navigationBar.frame=
                    CGRectMake(0,
                               self.navigationController.navigationBar.frame.origin.y,
                               self.navigationController.navigationBar.frame.size.width,
                               self.navigationController.navigationBar.frame.size.height);
                    
                    self.detailController.view.frame=
                    CGRectMake(0,
                               self.detailController.view.frame.origin.y,
                               self.detailController.view.frame.size.width,
                               self.detailController.view.frame.size.height);
                } completion:nil];
                }
                [self.swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
            }
            else
            {
                if(self.time<0.5)
                {
                    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
                    self.time=0.0;
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
                     {
                         self.navigationController.navigationBar.frame=
                         CGRectMake(0,
                                    self.navigationController.navigationBar.frame.origin.y,
                                    self.navigationController.navigationBar.frame.size.width,
                                    self.navigationController.navigationBar.frame.size.height);
                         
                         self.detailController.view.frame=
                         CGRectMake(0,
                                    self.detailController.view.frame.origin.y,
                                    self.detailController.view.frame.size.width,
                                    self.detailController.view.frame.size.height);
                     } completion:nil];
                }
                else
                {
                    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
                    self.time=0.0;
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
                     {
                         self.navigationController.navigationBar.frame=
                         CGRectMake([UIScreen mainScreen].bounds.size.width*0.8,
                                    self.navigationController.navigationBar.frame.origin.y,
                                    self.navigationController.navigationBar.frame.size.width,
                                    self.navigationController.navigationBar.frame.size.height);
                         
                         self.detailController.view.frame=
                         CGRectMake([UIScreen mainScreen].bounds.size.width*0.8,
                                    self.detailController.view.frame.origin.y,
                                    self.detailController.view.frame.size.width,
                                    self.detailController.view.frame.size.height);
                     } completion:nil];
                    [self.swipe setDirection:UISwipeGestureRecognizerDirectionRight];
                }

            }
            
        }
    }
    
}

-(void)gestureSwipe
{
    if(self.swipe.direction==UISwipeGestureRecognizerDirectionRight)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         self.navigationController.navigationBar.frame=
         CGRectMake([UIScreen mainScreen].bounds.size.width*0.8,
                    self.navigationController.navigationBar.frame.origin.y,
                    self.navigationController.navigationBar.frame.size.width,
                    self.navigationController.navigationBar.frame.size.height);
         
         self.detailController.view.frame=
         CGRectMake([UIScreen mainScreen].bounds.size.width*0.8,
                    self.detailController.view.frame.origin.y,
                    self.detailController.view.frame.size.width,
                    self.detailController.view.frame.size.height);
     } completion:nil];
        [self.swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             self.navigationController.navigationBar.frame=
             CGRectMake(0,
                        self.navigationController.navigationBar.frame.origin.y,
                        self.navigationController.navigationBar.frame.size.width,
                        self.navigationController.navigationBar.frame.size.height);
             
             self.detailController.view.frame=
             CGRectMake(0,
                        self.detailController.view.frame.origin.y,
                        self.detailController.view.frame.size.width,
                        self.detailController.view.frame.size.height);
         } completion:nil];
                [self.swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    }
}
- (IBAction)swipe:(UIBarButtonItem *)sender
{

    //UIView * back=self.view;//[[UIView alloc] initWithFrame:CGRectMake(-menuController.view.bounds.size.width, 0, menuController.view.bounds.size.width, menuController.view.bounds.size.height)];
    //back.backgroundColor=[UIColor redColor];
//
    //UIView * front=[[UIView alloc] initWithFrame:self.view.frame];
    //front.backgroundColor=[UIColor whiteColor];
//    [front addSubview:menuController.view];
//    [front addSubview:[self.storyboard instantiateViewControllerWithIdentifier:@"amin"].view];
    //front.backgroundColor=self.view.backgroundColor;
//    for(int i=0; i<array.count; ++i)
//    {
//        [front addSubview:array[i]];
//        front.subviews[i].frame=CGRectMake(front.bounds.size.width*0.8, 0, front.subviews[i].bounds.size.width, front.subviews[i].bounds.size.height);
//    }
//    [self.all addSubview:back];
//    [self.all addSubview:self.view];
    
//    [front addSubview:menuController.view];
//    [menuController loadViewIfNeeded];
//    [front addSubview:detailController.view];
//    [detailController loadViewIfNeeded];
//    [detailController.view reloadInputViews];
    //[self.view addSubview:menuController.view];
    //[self.view addSubview:detailController.view];

    //[self.view insertSubview:menuController.view atIndex:0];

    //NSLog(@"%@",array[0]);
    NSLog(@"%ld",self.view.subviews.count);
    NSLog(@"%f",self.view.bounds.size.width);
    NSLog(@"%f",self.view.bounds.size.height);
   
    //front.subviews[1].frame=CGRectMake(front.subviews[1].bounds.size.width*0.8, front.subviews[1].bounds.origin.y, front.subviews[1].bounds.size.width, front.subviews[1].bounds.size.height);
    NSLog(@"%f",self.view.bounds.origin.x);
    NSLog(@"%f",self.view.bounds.origin.y);
    //[self.view sub];
    //[self.navigationController pushViewController:menuController animated:NO];
}
@end
