//
//  LogInViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 27.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "LogInViewController.h"
#import "LogInTableViewCell.h"
#import "AMSideBarViewController.h"
#import "UIColor+GitHubColor.h"
#import "GitHubApiController.h"
#import "AuthorizedUser.h"
#import "InternetConnectionController.h"

@interface LogInViewController ()<UIWebViewDelegate>
@property (nonatomic)UITextField * loginField;
@property (nonatomic)UITextField * passwordField;
@property (nonatomic)UIView * loadView;
@property (nonatomic)UIActivityIndicatorView * indicatior;
@property (nonatomic)UIImageView * avatarView;
@end

@implementation LogInViewController

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *path = [request.URL absoluteString];
    NSLog(@"%@",path);
    if([path containsString:@"https://www.zzz.com.ua/"])
    {
        [[GitHubApiController sharedController] loginUserWithCode:path andSuccess:^
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self.webView removeFromSuperview];
        } orFailure:^
        {
            NSLog(@"Error access!!!");
        }];
        return NO;
    }
    return YES;
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 2;
//}
//
//// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
//// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString * identifaer=@"Reusable sell default";
//    LogInTableViewCell * cell;
//    cell=(LogInTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifaer];
//    if(cell==nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LogInTableViewCell"owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//    NSLog(@"%@",cell.contentView);
//    NSLog(@"%@",[cell.contentView class]);
//    switch (indexPath.row)
//    {
//        case 0:
//            cell.textField.placeholder=@"Email";
//            self.loginField=cell.textField;
//            return cell;
//        case 1:
//            cell.textField.placeholder=@"Password";
//            self.passwordField=cell.textField;
//            return cell;
//        default:
//            return nil;
//    }
//    
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [super viewWillDisappear:animated];
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
//}

-(void)textChanged
{
    if(self.loginField.text.length>0 && self.passwordField.text.length>0)
    {
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
//    self.loginTable=[[UITableView alloc] initWithFrame:self.view.bounds];
//    self.title=@"GitHub";
    UIBarButtonItem * refreshItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(validate)];
    //enterItem.tintColor=[UIColor whiteColor];
//    UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithTitle:@"Enter" style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
//    menuItem.tintColor=[UIColor whiteColor];
//    menuItem.image=[UIImage imageNamed:@"menu_icon"];
    
    self.navigationItem.rightBarButtonItem=refreshItem;
//    self.navigationItem.leftBarButtonItem=menuItem;
//    NSLog(@"%@",self.loginTable.separatorColor);
//    self.loginTable.backgroundColor=[UIColor SeparatorColor];
//    self.navigationController.navigationBar.barTintColor=[UIColor GitHubColor];
//    self.navigationController.navigationBar.alpha=1.0;
//    self.navigationController.navigationBar.translucent=NO;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.navigationItem.rightBarButtonItem.enabled=NO;
//    self.loginTable.delegate=self;
//    self.loginTable.dataSource=self;
//    self.loginTable.tableFooterView=[UIView new];
    //[self.view addSubview:self.loginTable];
    self.webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate=self;
    
    [AuthorizedUser readUser];
    self.loadView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.loadView.backgroundColor=[UIColor SeparatorColor];
    self.indicatior=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.loadView.bounds.size.width/2-25, self.loadView.bounds.size.height/2+80, 50.0, 50.0)];
    [self.indicatior setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatior.color=[UIColor blackColor];
    
    self.avatarView=[[UIImageView alloc] initWithFrame:CGRectMake(self.loadView.bounds.size.width/2-75, self.loadView.bounds.size.height/2-100, 150.0, 150.0)];
    self.avatarView.layer.cornerRadius=30.0;
    self.avatarView.image=[UIImage imageNamed:@"login_user_unknown"];
    
    [self.loadView addSubview:self.avatarView];
    [self.loadView addSubview:self.indicatior];
    [self.view addSubview:self.loadView];
    [self validate];
    
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
-(void)validate
{
    if([AuthorizedUser isExist])
    {
        AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
        [manager loadDataWithURLString:[[AuthorizedUser sharedUser] avatarRef] andSuccess:^(NSString * path)
         {
             [AuthorizedUser sharedUser].avatarPath=path;
             self.avatarView.image=[UIImage imageWithContentsOfFile:path];
         } orFailure:^(NSString * message)
         {
             
         }];
    }
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.github.com/user?access_token=%@",[AuthorizedUser isExist]?[AuthorizedUser sharedUser].accessToken:@"<null>"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [self.indicatior startAnimating];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^
      (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          //username=luckystar.od@gmail.com&password=Allah2911&&note=admin script
          NSLog(@"%@",response);
          if(data==nil)
          {
              NSLog(@"%@",error.localizedDescription);
              [self showAlert];
              return;
          }
          NSError * jsonerror;
          NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonerror];
          NSLog(@"%@",dict);
          if([dict[@"message"] isEqualToString:@"Bad credentials"])
          {
              [self refresh];
              [self.view addSubview:self.webView];
              [self.loadView removeFromSuperview];
          }
          else
          {
              [self.navigationController dismissViewControllerAnimated:YES completion:nil];
          }
          NSLog(@"%@",dict);
      }] resume];
}
//- (void)menuDidTap
//{
//    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
//    [sider side];
//}
@end
