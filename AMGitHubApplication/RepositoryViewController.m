//
//  RepositoryViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 01.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "RepositoryViewController.h"
#import "UIImage+ResizingImg.h"
#import "dataCollectionViewCell.h"
#import "UIColor+GitHubColor.h"
#import "GitHubApiController.h"
#import "UserProfileViewController.h"
#import "IssuesViewController.h"

@interface RepositoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic)UIView * noResultView;
@property (nonatomic)UIImageView * imageView;
@property (nonatomic)NSArray * methods;
@property (nonatomic)UIView * footerView;
@property (nonatomic)UIRefreshControl * refresh;
@end
@implementation RepositoryViewController


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RepoAvatarView * headerView;
    if(kind==UICollectionElementKindSectionHeader)
    {
        headerView=(RepoAvatarView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if([headerView.nameLabel.text isEqualToString:@"Label"])
        {
            headerView.imageView.image=[UIImage imageWithContentsOfFile:self.repo.user.avatarPath];
            headerView.nameLabel.text=self.repo.name;
            headerView.descriptionLabel.text=self.repo.descriptionStr;
            headerView.imageView.layer.borderWidth=2.0;
            headerView.imageView.layer.borderColor=[UIColor whiteColor].CGColor;
        }
    }
    return headerView;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    SEL selector = NSSelectorFromString(self.methods[indexPath.row]);
    ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    if(self.preferredInterfaceOrientationForPresentation==UIInterfaceOrientationPortrait || self.preferredInterfaceOrientationForPresentation==UIInterfaceOrientationPortraitUpsideDown)
    {
        size=CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height*0.3 + [RepoAvatarView heightForText:self.repo.descriptionStr]);
    }
    else
    {
        size=CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height*0.5 + [RepoAvatarView heightForText:self.repo.descriptionStr]);
    }
    
    return size;
}
-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout*)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(indexPath.row>=0&&indexPath.row<3)
    {
        size.height=44.0;
        size.width=collectionView.bounds.size.width/3-0.05;
    }
    else if(indexPath.row==3 || indexPath.row==9)
    {
        size.height=20.0;
        size.width=collectionView.bounds.size.width;
    }
    else if(indexPath.row>3&&indexPath.row<8)
    {
        size.height=44.0;
        size.width=collectionView.bounds.size.width/2;
    }
    else
    {
        size.height=44.0;
        size.width=collectionView.bounds.size.width;
    }
    return size;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    dataCollectionViewCell * cell=(dataCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"Cell%ld",indexPath.row] forIndexPath:indexPath];
    UIView * rightSeparatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0, cell.bounds.size.height)];
    rightSeparatorView.backgroundColor=[UIColor SeparatorColor];
    UIView * bottomSeparatorView=[[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-1, cell.bounds.size.width, 1.0)];
    bottomSeparatorView.backgroundColor=[UIColor SeparatorColor];
    switch (indexPath.row)
    {
        case 0:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.repo.stars;
            break;
        case 1:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.repo.watchers;
            [cell addSubview:rightSeparatorView];
            break;
        case 2:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.repo.forks;
            [cell addSubview:rightSeparatorView];
            break;
        case 4:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.repo.isPrivate?@"Public":@"Private";
            [cell addSubview:bottomSeparatorView];
            break;
        case 5:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.repo.language;
            [cell addSubview:rightSeparatorView];
            [cell addSubview:bottomSeparatorView];
            break;
        case 6:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=[NSString stringWithFormat:@"%@ Issues",self.repo.issues];
            [cell addSubview:bottomSeparatorView];
            break;
        case 7:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.repo.date;
            [cell addSubview:rightSeparatorView];
            [cell addSubview:bottomSeparatorView];
            break;
        case 8:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.repo.user.login;
            break;
        case 10:
            cell.backgroundColor=[UIColor whiteColor];
            [cell addSubview:bottomSeparatorView];
            break;
        case 11:
            cell.backgroundColor=[UIColor whiteColor];
            break;
        default:
            cell.backgroundColor=[UIColor SeparatorColor];
            break;
    }
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];
    [super viewWillAppear:animated];
}

-(void)setRepo:(GitHubRepository *)repo
{
    _repo=repo;
    [[GitHubApiController sharedController] listWatchesForRepo:repo withComplation:^(NSArray *watchers)
    {
        repo.watchers=[NSString stringWithFormat:@"%ld",watchers.count];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]]];
            [self.refresh endRefreshing];
        });
    }];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
        //[self.collectionView reloadInputViews];
        //[self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexpath]];
    [UIView animateWithDuration:duration animations:^
    {
           [self.collectionView reloadData];
    }];

}
-(void)emptyMethod
{
}
-(void)starDidPress
{
    [[GitHubApiController sharedController] repo:self.repo isStarred:^(BOOL isStarred)
     {
         if(!isStarred)
         {
             [[GitHubApiController sharedController] starRepo:self.repo andSuccess:^(NSData *data)
              {
                  dispatch_async(dispatch_get_main_queue(), ^
                                 {
                                     self.imageView.image=[UIImage imageNamed:@"star"];
                                     [UIView animateWithDuration:0.5 animations:^
                                      {
                                          self.imageView.alpha=1.0;
                                          self.imageView.alpha=0.0;
                                      }];
                                     self.repo.stars=[NSString stringWithFormat:@"%ld",self.repo.stars.integerValue+1];
                                     [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]];
                                 });
                  
                  //for(int i=0;i<100000000;++i);
                  //[self.noResultView removeFromSuperview];
              } orFailure:^(NSString *message)
              {
                  
              }];
         }
         else
         {
             
             [[GitHubApiController sharedController] unStarRepo:self.repo andSuccess:^(NSData *data)
              {
                  dispatch_async(dispatch_get_main_queue(), ^
                                 {
                                     self.imageView.image=[UIImage imageNamed:@"unstar"];
                                     [UIView animateWithDuration:0.5 animations:^
                                      {
                                          self.imageView.alpha=1.0;
                                          self.imageView.alpha=0.0;
                                      }];
                                     self.repo.stars=[NSString stringWithFormat:@"%ld",self.repo.stars.integerValue-1];
                                     [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]];
                                 });
                  //for(int i=0;i<100000000;++i);
                  //[self.noResultView removeFromSuperview];
              } orFailure:^(NSString *message)
              {
                  
              }];
         }
         
     }];
}

-(void)watchDidPress
{
    [[GitHubApiController sharedController] watchRepo:self.repo watchComplation:^
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            self.imageView.image=[UIImage imageNamed:@"watch"];
                            [UIView animateWithDuration:1 animations:^
                             {
                                 self.imageView.alpha=1.0;
                                 self.imageView.alpha=0.0;
                             }];
                            self.repo.watchers=[NSString stringWithFormat:@"%ld",self.repo.watchers.integerValue+1];
                            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]]];
                        });
     } unWatchComplation:^
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            self.imageView.image=[UIImage imageNamed:@"unwatch"];
                            [UIView animateWithDuration:1 animations:^
                             {
                                 self.imageView.alpha=1.0;
                                 self.imageView.alpha=0.0;
                             }];
                            self.repo.watchers=[NSString stringWithFormat:@"%ld",self.repo.watchers.integerValue-1];
                            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]]];
                        });
     }];
}
-(void)ownerDidTap
{
    UserProfileViewController * profile=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profile"];
    [[GitHubApiController sharedController] userFromLogin:self.repo.user.login andComplation:^(GitHubUser * user)
     {
         user.avatarPath=self.repo.user.avatarPath;
         profile.user=user;
         [self.refresh endRefreshing];
     }];
    [self.navigationController pushViewController:profile animated:YES];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.footerView.frame=CGRectMake(self.footerView.frame.origin.x, -self.collectionView.contentOffset.y, self.footerView.frame.size.width, self.footerView.frame.size.height);
}

-(void)issuesDidTap
{
    IssuesViewController * issuesController=[[IssuesViewController alloc] initWithUpdateNotification:@"RepoIssues"];
    issuesController.repo=self.repo;
    //UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:issuesController];
    [self.navigationController pushViewController:issuesController animated:YES];
}

-(void)sorceDidTap
{
    UIWebView * webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    UIViewController * webController=[[UIViewController alloc] init];
    [webController.view addSubview:webView];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.repo.repoReference] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [webView loadRequest:request];
    
    [self.navigationController pushViewController:webController animated:YES];
}

-(void)refrashData
{
    [[GitHubApiController sharedController] refreshRepo:self.repo andSuccess:^(GitHubRepository *repo)
     {
         self.repo=repo;
    } orFailure:^(NSString *message)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self showAllertWithMessage:message];
        });
    }];
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

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    
    self.refresh=[[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-15, 0, 40, 40)];
    //self.refresh.attributedTitle=[[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    self.refresh.tintColor=[UIColor whiteColor];
    [self.refresh addTarget:self action:@selector(refrashData) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refresh];
    
    
    UIView * upperView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    upperView.backgroundColor=[UIColor GitHubColor];
    
    NSLog(@"%@",self.collectionView.backgroundView);
    self.collectionView.backgroundView=upperView;
    
    self.footerView=[[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bounds.size.height/3.3, self.collectionView.bounds.size.width, [UIScreen mainScreen].bounds.size.height*2)];
    self.footerView.backgroundColor=[UIColor SeparatorColor];
    [upperView addSubview:self.footerView];
    
    self.noResultView=[[UIView alloc] initWithFrame:self.view.bounds];
    
    self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.noResultView.bounds.size.width/2-75, self.noResultView.bounds.size.height/2-75, 150, 150)];
    
    self.methods=[NSArray arrayWithObjects:@"starDidPress",@"watchDidPress",@"emptyMethod",@"emptyMethod",@"emptyMethod",@"emptyMethod",@"emptyMethod",@"emptyMethod",@"ownerDidTap",@"emptyMethod",@"issuesDidTap",@"sorceDidTap", nil];
    
    //[self.noResultView addSubview:self.imageView];
    //self.noResultView.backgroundColor=[UIColor blackColor];
    //self.noResultView.alpha=0.0;
    
    [self.view addSubview:self.imageView];
    //self.collectionView.backgroundColor=[UIColor SeparatorColor];
    //upperView.backgroundColor=[UIColor GitHubColor];
    //self.collectionView.layer;
    //self.collectionView.backgroundColor=[UIColor SeparatorColor];
    //self.collectionView.pagingEnabled=NO;
    //self.collectionView.enabled
    //[self.view addSubview:self.tableView];
}
@end
