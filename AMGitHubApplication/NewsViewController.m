//
//  NewsViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 04.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic)UITableView * tableView;
@property (nonatomic)NewsViewControllerMod mod;
@property (nonatomic)NSMutableArray<Event *> * events;
@property (nonatomic)UIView * shadowView;
@property (nonatomic)NSString * notification;
@end

@implementation NewsViewController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell"owner:self options:nil];
    EventCell * cell=[nib objectAtIndex:0];
    [self.events[indexPath.row] fillCell:cell];
    return [EventCell heightForText:cell.descriptionLabel.text] + 70;//70 - height of other cell elements
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

-(void)addEvents:(NSArray<Event *> *)events
{
    NSMutableArray<NSIndexPath *> * array=[NSMutableArray array];
    for(NSUInteger i=self.events.count;i<self.events.count+events.count;++i)
    {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.events addObjectsFromArray:events];
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [self.loadContentView removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifaer=@"Reusable sell default";
    EventCell * cell;
    
    if(!self.isAll && indexPath.row==self.events.count-3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
    }
    
    cell=(EventCell *)[tableView dequeueReusableCellWithIdentifier:identifaer];
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self.events[indexPath.row] fillCell:cell];
    return cell;
}

-(instancetype)initWithUpdateNotification:(NSString *)notification
{
    if(self=[super init])
    {
        self.notification=notification;
    }
    return self;
}

-(void)setIsAll:(BOOL)isAll
{
    _isAll=isAll;
    if(!self.events.count)
    {
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.noResultView];
    }
}
-(UIImageView *)iconView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.mod==NewsViewControllerOwnedMod?@"event":@"news"]];
}

-(NSString *)description
{
    return self.title;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UIView * searchView=[[UIView alloc] initWithFrame:CGRectMake(self.shadowView.bounds.size.width/2-65.0, self.shadowView.bounds.size.height/3, 130.0, 80.0)];
//    searchView.backgroundColor=[UIColor SeparatorColor];
//    searchView.layer.cornerRadius=8.0;
//    
//    UILabel * searchLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 130.0, 30.0)];
//    searchLabel.text=@"Loading...";
//    searchLabel.adjustsFontSizeToFitWidth=YES;
//    searchLabel.textAlignment=NSTextAlignmentCenter;
//    searchLabel.textColor=[UIColor GitHubColor];
//    
//    UIActivityIndicatorView * activityInd=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40.0, 10.0, 50.0, 50.0)];
//    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
//    activityInd.color=[UIColor GitHubColor];
//    activityInd.hidesWhenStopped=YES;
//    
//    [searchView addSubview:searchLabel];
//    [searchView addSubview:activityInd];
//    
//    [self.shadowView addSubview:searchView];
    [self.view addSubview:self.loadContentView];
    //[activityInd startAnimating];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    //[self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    if(self.navigationController.viewControllers.count<2)
    {
        UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
        menuItem.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=menuItem;
    }
    
//    self.navigationController.navigationBar.alpha=1.0;
//    self.navigationController.navigationBar.translucent=NO;
//    self.navigationController.navigationBar.barTintColor=[UIColor GitHubColor];
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.shadowView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    
//    NSLayoutConstraint *trailing =[NSLayoutConstraint
//                                   constraintWithItem:self.tableView
//                                   attribute:NSLayoutAttributeTrailing
//                                   relatedBy:NSLayoutRelationEqual
//                                   toItem:self.view
//                                   attribute:NSLayoutAttributeTrailing
//                                   multiplier:1.0f
//                                   constant:0.f];
//    
//    NSLayoutConstraint *leading = [NSLayoutConstraint
//                                   constraintWithItem:self.tableView
//                                   attribute:NSLayoutAttributeLeading
//                                   relatedBy:NSLayoutRelationEqual
//                                   toItem:self.view
//                                   attribute:NSLayoutAttributeLeading
//                                   multiplier:1.0f
//                                   constant:0.f];
//    
//    NSLayoutConstraint *bottom =[NSLayoutConstraint
//                                 constraintWithItem:self.tableView
//                                 attribute:NSLayoutAttributeBottom
//                                 relatedBy:NSLayoutRelationEqual
//                                 toItem:self.view
//                                 attribute:NSLayoutAttributeBottom
//                                 multiplier:1.0f
//                                 constant:0.f];
//    
//    NSLayoutConstraint *top =[NSLayoutConstraint
//                              constraintWithItem:self.tableView
//                              attribute:NSLayoutAttributeTop
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeTop
//                              multiplier:1.0f
//                              constant:0.f];
//    
//    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
//    [self.view addConstraint:trailing];
//    [self.view addConstraint:leading];
//    [self.view addConstraint:bottom];
//    [self.view addConstraint:top];
    
    self.events=[NSMutableArray array];
}

-(NSUInteger)eventsCount
{
    return self.events.count;
}
-(void)menuDidTap
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
    [sider side];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
