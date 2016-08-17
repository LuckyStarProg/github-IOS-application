//
//  LogInViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 27.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()<UIWebViewDelegate>
@property (nonatomic) UIImageView *avatarView;
@property (nonatomic) UIActivityIndicatorView *loadIndicatorView;
@end

@implementation LogInViewController

#pragma mark - WebView delegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *path = [request.URL absoluteString];
    NSLog(@"%@",path);
    if([path containsString:@"https://www.zzz.com.ua/"])
    {
        AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
        [[GitHubApiController sharedController] loginUserWithCode:path andSuccess:^
        {
            self.webView.alpha=0.0;
            [self.webView removeFromSuperview];
            [self.view addSubview:self.avatarView];
            [self.view addSubview:self.loadIndicatorView];

            [manager loadDataWithURLString:[AuthorizedUser sharedUser].avatarRef andSuccess:^(NSString * path)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   self.avatarView.image=[UIImage imageWithContentsOfFile:path];
                                   [AuthorizedUser sharedUser].avatarPath=path;
                               });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                               {
                                   defaultUserMenuViewController * menu=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"menu"];
                                   NewsViewController * news=[[NewsViewController alloc] initWithUpdateNotification:@"addResivesNews"];
                                   news.title=@"News";
                                   UINavigationController * navigationVC=[[UINavigationController alloc] initWithRootViewController:news];
                                   
                                   AMSideBarViewController * sider=[AMSideBarViewController sideBarWithFrontVC:navigationVC andBackVC:menu];
                                   [self presentViewController:sider animated:YES completion:^
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^
                                        {
                                            [self.avatarView removeFromSuperview];
                                            [self.loadIndicatorView removeFromSuperview];
                                        });
                                    }];
                               });
            } orFailure:^(NSString * message)
            {
                NSLog(@"%@",message);
            }];
        } orFailure:^
        {
            NSLog(@"Error access!!!");
        }];
        return NO;
    }
    return YES;
}

#pragma mark - Life Cycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * refreshItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(validate)];
    self.navigationItem.rightBarButtonItem=refreshItem;
    
    self.navigationController.navigationBar.alpha=1.0;
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor GitHubColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:@"logout" object:nil];

    [self showLoadingPage];
    [self validate];
    
}

-(void)userDidLogout
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [self.avatarView removeFromSuperview];
    [self.loadIndicatorView removeFromSuperview];
    NSLog(@"%@",self.view.subviews);
    [self.view addSubview:self.webView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
//    {
//           [self refresh];
//    });
}

- (void)refresh
{
    self.webView.alpha=1.0;
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:[[GitHubApiController sharedController] verificationURL]]];
    [self.webView loadRequest:request];
}

-(void)showAlert
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"No internet! try again and tap refresh!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showLoadingPage
{
    self.loadIndicatorView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, [UIScreen mainScreen].bounds.size.height/2+30, 50.0, 50.0)];
    [self.loadIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadIndicatorView.color=[UIColor blackColor];
    self.loadIndicatorView.hidesWhenStopped=YES;
    
    self.avatarView=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, [UIScreen mainScreen].bounds.size.height/2-135, 150.0, 150.0)];
    self.avatarView.layer.cornerRadius=self.avatarView.bounds.size.width/2;
    self.avatarView.clipsToBounds=YES;
    self.avatarView.autoresizesSubviews=YES;
    self.avatarView.opaque=YES;
    self.avatarView.clearsContextBeforeDrawing=YES;
    self.avatarView.image=[UIImage imageNamed:@"login_user_unknown"];
    self.avatarView.layer.cornerRadius=self.avatarView.bounds.size.width/2;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        self.loadIndicatorView.frame=CGRectMake([UIScreen mainScreen].bounds.size.height/2-25, [UIScreen mainScreen].bounds.size.width/2+30, 50.0, 50.0);
        self.avatarView.frame=CGRectMake([UIScreen mainScreen].bounds.size.height/2-75, [UIScreen mainScreen].bounds.size.width/2-135, 150.0, 150.0);
    }
    else
    {
        self.loadIndicatorView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, [UIScreen mainScreen].bounds.size.height/2+30, 50.0, 50.0);
        self.avatarView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, [UIScreen mainScreen].bounds.size.height/2-135, 150.0, 150.0);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.loadIndicatorView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, [UIScreen mainScreen].bounds.size.height/2+30, 50.0, 50.0);
    self.avatarView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, [UIScreen mainScreen].bounds.size.height/2-135, 150.0, 150.0);
}
-(void)validate
{
    [self.loadIndicatorView startAnimating];
    NSString * str=[NSString stringWithFormat:@"https://api.github.com/user?access_token=%@",[AuthorizedUser isExist]?[AuthorizedUser sharedUser].accessToken:@"invalidToken"];
    NSURL *url = [NSURL URLWithString: str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^
      (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          NSLog(@"%@",response);
          if(data==nil)
          {
              NSLog(@"%@",error.localizedDescription);
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
              {
                  [self.loadIndicatorView stopAnimating];
                  [self.loadIndicatorView setHidden:YES];
              });
              return;
          }
          NSError * jsonerror;
          NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonerror];
          NSLog(@"%@",dict);
          if([dict[@"message"] isEqualToString:@"Bad credentials"])
          {
              NSLog(@"%@",self.webView);
              dispatch_async(dispatch_get_main_queue(), ^
              {
                  [self.loadIndicatorView removeFromSuperview];
                  [self.avatarView removeFromSuperview];
                  self.webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
                  self.webView.delegate=self;
                  [self.view addSubview:self.webView];
                  [self refresh];
              });
          }
          else
          {
              dispatch_async(dispatch_get_main_queue(), ^
              {
                  [self.view addSubview:self.avatarView];
                  [self.view addSubview:self.loadIndicatorView];
              });

              [AuthorizedUser setUser:[GitHubUser userFromDictionary:dict]];
              AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
              [manager loadDataWithURLString:[AuthorizedUser sharedUser].avatarRef andSuccess:^(NSString * path)
              {
                  dispatch_async(dispatch_get_main_queue(), ^
                  {
                      self.avatarView.image=[UIImage imageWithContentsOfFile:path];
                      [AuthorizedUser sharedUser].avatarPath=path;
                  });
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                  {
                      defaultUserMenuViewController * menu=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"menu"];
                      NewsViewController * news=[[NewsViewController alloc] initWithUpdateNotification:@"addResivesNews"];
                      news.title=@"News";
                      UINavigationController * navigationVC=[[UINavigationController alloc] initWithRootViewController:news];
                      
                      AMSideBarViewController * sider=[AMSideBarViewController sideBarWithFrontVC:navigationVC andBackVC:menu];
                      [self presentViewController:sider animated:YES completion:nil];
                  });
                  
              } orFailure:^(NSString * message)
              {
                  NSLog(@"%@",message);
              }];
          }
          NSLog(@"%@",dict);
      }] resume];
}
@end
