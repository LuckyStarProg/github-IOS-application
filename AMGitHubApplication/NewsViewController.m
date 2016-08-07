//
//  NewsViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 04.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "NewsViewController.h"
#import "LogInViewController.h"
#import "EventCell.h"
#import "Event.h"
#import "GitHubApiController.h"
#import "UIColor+GitHubColor.h"
#import "AMSideBarViewController.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic)UITableView * tableView;
@property (nonatomic)NSMutableArray<Event *> * events;
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
    return [EventCell heightForText:cell.descriptionLabel.text] + 70;//65 - height of other cell elements
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

-(void)load
{
    [[GitHubApiController sharedController] newsWithPer_page:15 andPage:self.events.count/15+1 andComplation:^(NSArray<Event *> * events)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
        NSMutableArray<NSIndexPath *> * array=[NSMutableArray array];
        for(NSUInteger i=0; i<events.count; ++i)
        {
            [array addObject:[NSIndexPath indexPathForRow:self.events.count inSection:0]];
            [self.events addObject:events[i]];
        }
            
            [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        });
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifaer=@"Reusable sell default";
    EventCell * cell;
    
    if(indexPath.row==self.events.count-3)
    {
        [self load];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.title=@"News";
    UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
    menuItem.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=menuItem;
    
    self.navigationController.navigationBar.alpha=1.0;
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor GitHubColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    LogInViewController * controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];

    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:^
     {
         self.events=[NSMutableArray array];
        [self load];
     }];
}

-(void)menuDidTap
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    [sider side];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
