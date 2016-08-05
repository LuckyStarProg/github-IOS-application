//
//  repoListViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 28.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "repoListViewController.h"
#import "AMSideBarViewController.h"
#import "repoCell.h"
#import "GitHubRepository.h"
#import "InternetConnectionController.h"
#import "AMDataManager.h"
#import "UIImage+ResizingImg.h"
#import "RepositoryViewController.h"
#import "UIColor+GitHubColor.h"
#import "GitHubApiController.h"

@interface repoListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic)UITableView * tableView;
@property (nonatomic)AMDataManager * dataManager;
@property (nonatomic)UIView * shadowView;
@property (nonatomic)UIAlertController* alert;
@property (nonatomic)NSString * token;
@property (nonatomic)NSMutableArray * repos;
@property (nonatomic)NSUInteger currentPage;
@property (nonatomic)BOOL isAllData;
@property (nonatomic)BOOL direction;//YES - up , NO-down
@property (nonatomic)CGPoint lastContentOffset;
@end

@implementation repoListViewController

#pragma mark Table delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GitHubRepository * repo=self.repos[indexPath.row];
    RepositoryViewController * repoViewController=(RepositoryViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"repoInfo"];
    repoViewController.repo=repo;
    //UINavigationController * navigation=[[UINavigationController alloc] initWithRootViewController:repoViewController];
    
    [self.navigationController pushViewController:repoViewController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GitHubRepository * repo=self.repos[indexPath.row];
    return [repoCell heightForText:repo.descriptionStr] + 65;//65 - height of other cell elements
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifaer=@"Reusable sell default";
    repoCell * cell;
    GitHubRepository * repo;
    repo=self.repos[indexPath.row];
    
    if(indexPath.row==self.repos.count-5)
    {
        self.currentPage++;
//        NSThread * thread=[[NSThread alloc] initWithTarget:self selector:@selector(search) object:nil];
//        thread.threadPriority=0.5;
//        [thread start];
        [self search];
    }
    
//    if(self.direction && indexPath.row-2==0)
//    {
//        self.currentPage--;
//        [self search];
//    }
    
    cell=(repoCell *)[tableView dequeueReusableCellWithIdentifier:identifaer];
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"repoCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.repoName.text= repo.name;
    cell.repoDescription.text=repo.descriptionStr;
    cell.repoStarsLabel.text=repo.stars;
    cell.tag=indexPath.row;
    if(repo.user)
    {
        
        if(repo.user.avatarPath)
        {
            cell.userAvatar.image=[[UIImage imageWithContentsOfFile:repo.user.avatarPath] toSize:cell.userAvatar.frame.size];
            [cell setNeedsLayout];
        }
        else
        {
            [self.dataManager loadDataWithURLString:repo.user.avatarRef andSuccess:^(NSString * pathToData)
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                {
                    repo.user.avatarPath=pathToData;
                    cell.userAvatar.image=[[UIImage imageWithContentsOfFile:pathToData] toSize:cell.userAvatar.frame.size];
                    [cell setNeedsLayout];
                });
             }
            orFailure:^(NSString * message)
             {
                NSLog(@"%@",message);
             }];
        }
    }
    return cell;
}


#pragma mark Lyfe Cycle

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentOffset = scrollView.contentOffset;
    if (currentOffset.y > self.lastContentOffset.y)
    {
       NSLog(@"Down");
        self.direction=NO;
    }
    else
    {
        NSLog(@"Up");
        self.direction=YES;
    }
    self.lastContentOffset = currentOffset;
}
-(void)showAllertWithMessage:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)search
{
    [[GitHubApiController sharedController]searchReposByToken:self.token andPerPage:15 andPage:self.currentPage andSuccess:^(NSData *data) {
        NSError * error=nil;
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(error)
        {
            [self showAllertWithMessage:error.description];
            return;
        }
        if(dict)
        {
            NSArray * repoDicts=dict[@"items"];
            //repoCell * visibleCell;
//            if(!self.direction)
//            {
//                if(self.repos.count)
//                {
////                visibleCell=self.tableView.visibleCells[0];
////                if(visibleCell.tag+1-3>0)
////                {
////                    for(NSUInteger i=0;i<5;++i)
////                    {
////                        [self.repos removeObjectAtIndex:0];
////                    }
//                    //}
//                }
            NSMutableArray<NSIndexPath *> * array=[NSMutableArray array];
            
//            NSUInteger arr[15] = {0};
//            int count=0;
                for(NSDictionary * repo in repoDicts)
                {
                    [array addObject:[NSIndexPath indexPathForRow:self.repos.count inSection:0]];
                    [self.repos addObject:[GitHubRepository repositoryFromDictionary:repo]];
                }
                //NSLog(@"%ld",self.repos.count);
//            }
//            else
//            {
//                NSUInteger i=0;
//                for(NSDictionary * repo in repoDicts)
//                {
//                    [self.repos insertObject:[GitHubRepository repositoryFromDictionary:repo] atIndex:i];
//                    i++;
//                }
//                
////                repoCell * visibleCell=self.tableView.visibleCells.lastObject;
////                if(visibleCell.tag+4<self.repos.count)
////                {
////                    for(NSUInteger i=0;i<5;++i)
////                    {
////                        [self.repos removeLastObject];
////                    }
//                //}
//
//            }
            [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            [self stopSearching];
        }
    } orFailure:^(NSString *message)
     {
         dispatch_async(dispatch_get_main_queue(), ^
        {
            self.isAllData=YES;
            [self showAllertWithMessage:message];
            [self stopSearching];
        });
     }];
}
-(void)startSearching
{
    [self search];
    UIView * searchView=[[UIView alloc] initWithFrame:CGRectMake(self.shadowView.bounds.size.width/2-65.0, self.shadowView.bounds.size.height/3, 130.0, 80.0)];
    searchView.backgroundColor=[UIColor SeparatorColor];
    searchView.layer.cornerRadius=8.0;
    
    UILabel * searchLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 130.0, 30.0)];
    searchLabel.text=@"Searching...";
    searchLabel.adjustsFontSizeToFitWidth=YES;
    searchLabel.textAlignment=NSTextAlignmentCenter;
    searchLabel.textColor=[UIColor GitHubColor];
    
    UIActivityIndicatorView * activityInd=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40.0, 10.0, 50.0, 50.0)];
    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityInd.color=[UIColor GitHubColor];
    activityInd.hidesWhenStopped=YES;
    
    [searchView addSubview:searchLabel];
    [searchView addSubview:activityInd];
    
    [self.shadowView addSubview:searchView];
    [self.view addSubview:self.shadowView];
    [activityInd startAnimating];
}

-(void)stopSearching
{
    [self.shadowView removeFromSuperview];
}

-(void)reloadData
{
    [self.tableView reloadData];
    if(!self.repos.count)
    {
        [self.tableView removeFromSuperview];
        UIView * noResultView=[[UIView alloc] initWithFrame:self.view.bounds];
        noResultView.backgroundColor=[UIColor SeparatorColor];
        UILabel * info=[[UILabel alloc] initWithFrame:CGRectMake(noResultView.bounds.size.width/2-100, noResultView.bounds.size.height/2+30, 200.0, 80.0)];
        info.text=@"The search hasn't give any results";
        info.textAlignment=NSTextAlignmentCenter;
        info.numberOfLines=2;
        
        UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(noResultView.bounds.size.width/2-105, noResultView.bounds.size.height/2-160, 210.0, 180.0)];
        imageView.image=[UIImage imageNamed:@"github-cat"];
        
        [noResultView addSubview:imageView];
        [noResultView addSubview:info];
        
        [self.view addSubview:noResultView];
    }
}

-(void)dealloc
{
    [self.dataManager cancel];
    [self.dataManager clearData];
}

-(instancetype)initWithToken:(NSString *)token
{
    if(self=[super init])
    {
        self.token=token;
        self.currentPage=1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    //[self.tableView addConstraints:[NSArray arrayWithObjects:NSLayoutAttributeTop,, nil]];
    self.title=@"Repositories";
    UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
    menuItem.tintColor=[UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem=menuItem;
    self.navigationController.navigationBar.alpha=1.0;
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor GitHubColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.repos=[NSMutableArray array];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.dataManager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    
    self.shadowView=[[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    self.currentPage=1;
    
    [self startSearching];
}

-(void)menuDidTap
{
    AMSideBarViewController * sider=[self.navigationController.parentViewController isKindOfClass:[AMSideBarViewController class]]?(AMSideBarViewController *)self.navigationController.parentViewController:nil;
    [sider side];
}

@end
