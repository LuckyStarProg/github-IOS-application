//
//  LogInViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 27.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "LogInViewController.h"
#import "GitHubApiController.h"
#import "UIColor+GitHubColor.h"
#import "UIImage+ResizingImg.h"
#import "NewsViewController.h"
#import "defaultUserMenuViewController.h"

@interface LogInViewController ()<UIWebViewDelegate>
@property (nonatomic)UIActivityIndicatorView * indicatior;
@property (nonatomic)UIImageView * avatarView;
@end

@implementation LogInViewController

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *path = [request.URL absoluteString];
    NSLog(@"%@",path);
    AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    if([path containsString:@"https://www.zzz.com.ua/"])
    {
        [[GitHubApiController sharedController] loginUserWithCode:path andSuccess:^
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self.webView removeFromSuperview];
                [self.view addSubview:self.avatarView];
                [self.view addSubview:self.indicatior];
            });
            [manager loadDataWithURLString:[AuthorizedUser sharedUser].apiRef andSuccess:^(NSString * path)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   self.avatarView.image=[UIImage imageWithContentsOfFile:path];
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"Authorized user loaded" object:nil];
                                   
                               });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                               {
                                   defaultUserMenuViewController * menu=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"menu"];
                                   NewsViewController * news=[[NewsViewController alloc] initWithUpdateNotification:@"addResivesNews"];
                                   UINavigationController * navigationVC=[[UINavigationController alloc] initWithRootViewController:news];
                                   
                                   AMSideBarViewController * sider=[AMSideBarViewController sideBarWithFrontVC:navigationVC andBackVC:menu];
                                   [self presentViewController:sider animated:YES completion:nil];
                                   [self.avatarView removeFromSuperview];
                                   [self.indicatior removeFromSuperview];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
//    [[GitHubApiController sharedController] deleAuthUserWithCpmplation:^
//    {
//        dispatch_async(dispatch_get_main_queue(), ^
//        {
//            self.webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
//            self.webView.delegate=self;
//            [self.view addSubview:self.webView];
//            [self refresh];
//        });
//    }];
    [self showLoadingPage];
    [self validate];
    
}

-(void)userDidLogout
{
    [self.view addSubview:self.webView];
    [self refresh];
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
    self.indicatior=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-25, self.view.bounds.size.height/2+30, 50.0, 50.0)];
    [self.indicatior setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatior.color=[UIColor blackColor];
    self.indicatior.hidesWhenStopped=YES;
    
    self.avatarView=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-75, self.view.bounds.size.height/2-135, 150.0, 150.0)];
    self.avatarView.layer.cornerRadius=self.avatarView.bounds.size.width/2;
    self.avatarView.clipsToBounds=YES;
    self.avatarView.autoresizesSubviews=YES;
    self.avatarView.opaque=YES;
    self.avatarView.clearsContextBeforeDrawing=YES;
    self.avatarView.image=[UIImage imageNamed:@"login_user_unknown"];
//    if([AuthorizedUser isExist])
//    {
//        [[GitHubApiController sharedController] userFromLogin:[AuthorizedUser sharedUser].login andComplation:^(GitHubUser * user)
//        {
//            [AuthorizedUser setUser:user];
//            AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
//            [manager loadDataWithURLString:[[AuthorizedUser sharedUser] avatarRef] andSuccess:^(NSString * path)
//             {
//                 dispatch_async(dispatch_get_main_queue(), ^
//                {
//                        [AuthorizedUser sharedUser].avatarPath=path;
//                        self.avatarView.image=[UIImage imageWithContentsOfFile:path];
//                });
//             } orFailure:^(NSString * message)
//             {
//                 NSLog(@"%@",message);
//             }];
//        }];
//    }
    
    [self.view addSubview:self.avatarView];
    [self.view addSubview:self.indicatior];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)validate
{
    [self.indicatior startAnimating];
//    NSError * Error=nil;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"AuthorizedUser.dat"];
//    [[NSFileManager defaultManager] removeItemAtPath:path error:&Error];
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
                  [self.indicatior stopAnimating];
                  [self.indicatior setHidden:YES];
              });

              //[self.indicatior removeFromSuperview];
              //[self.avatarView removeFromSuperview];
              //[self showAlert];
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
                  [self.indicatior removeFromSuperview];
                  [self.avatarView removeFromSuperview];
                  self.webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
                  self.webView.delegate=self;
                  [self.view addSubview:self.webView];
                  [self refresh];
              });
          }
          else
          {
              [AuthorizedUser setUser:[GitHubUser userFromDictionary:dict]];
              AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
              [manager loadDataWithURLString:[AuthorizedUser sharedUser].avatarRef andSuccess:^(NSString * path)
              {
                  [AuthorizedUser sharedUser].avatarPath=path;
                  dispatch_async(dispatch_get_main_queue(), ^
                  {
                      self.avatarView.image=[UIImage imageWithContentsOfFile:path];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"Authorized user loaded" object:nil];
                  });
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                  {
                      defaultUserMenuViewController * menu=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"menu"];
                      NewsViewController * news=[[NewsViewController alloc] initWithUpdateNotification:@"addResivesNews"];
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
