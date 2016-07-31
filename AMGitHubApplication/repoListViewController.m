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

@interface repoListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic)UITableView * tableView;
@end

@implementation repoListViewController

#pragma mark Table delegate methods


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (self.activityIndicator.isAnimating)
//        return 50.0f;
//    return 0.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (self.activityIndicator.isAnimating)
//        return self.activityIndicator;
//    return nil;
//}

- (UIImage *)ScaleImgPropoWidth:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    //проверка на то если новый размер картинки больше или равен старому то вернуть ту же картинку
//    if(newSize.width>=image.size.width){
//        return image;
//    }//если данная проверка вам ненужна вы можете её убрать, напрмиер если хотите в любом случае кропить размер или же при увеличении размеров заменить условие на if(newSize.width<=image.size.width)
    ratio = newSize.width / image.size.width;
    delta = (ratio*image.size.height-ratio*image.size.width);
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[image CGImage]
                        scale:(image.scale / ratio)
                  orientation:(image.imageOrientation)];
    CGRect clipRect = CGRectMake(0, 0,
                                 scaledImage.size.width,
                                 scaledImage.size.height);
    CGSize sz = CGSizeMake(newSize.width, scaledImage.size.height);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    
    cell=(repoCell *)[tableView dequeueReusableCellWithIdentifier:identifaer];
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"repoCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.repoName.text= repo.name;
    cell.repoDescription.text=repo.descriptionStr;
    cell.repoStarsLabel.text=repo.stars;
    //cell.userAvatar.frame=CGRectMake(8, 8, 108, 80);
//    if(repo.user.avatarPath.length>0)
//    {
//        cell.userAvatar.image=[self ScaleImgPropoWidth:[UIImage imageWithContentsOfFile:repo.user.avatarPath] scaledToSize:cell.userAvatar.frame.size];
//        [cell setNeedsLayout];
//    }
//    else
    if(1)
    {
        [[InternetConnectionController sharedController] performRequestWithReference:repo.user.avatarRef andMethod:nil andParameters:nil andSuccess:^(NSData *data)
         {
             //repo.user.avatarPath=path;
             NSLog(@"%@",cell.userAvatar);
             cell.userAvatar.image=[self ScaleImgPropoWidth:[UIImage imageWithData:data] scaledToSize:cell.userAvatar.frame.size];
             [cell setNeedsLayout];
        
         } orFailure:^(NSString *message)
         {
             NSLog(@"Error: %@",message);
         }];
    }
    return cell;
}


#pragma mark Lyfe Cycle

-(void)reloadData
{
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    self.title=@"Repositories";
    UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithTitle:@"Enter" style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
    menuItem.tintColor=[UIColor whiteColor];
    menuItem.image=[UIImage imageNamed:@"menu_icon"];
    
    self.navigationItem.leftBarButtonItem=menuItem;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.10 green:0.30 blue:0.37 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.activityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    self.activityIndicator.hidesWhenStopped=YES;

    self.tableView.tableHeaderView=self.activityIndicator;
    
    self.repos=[NSMutableArray array];
    
    [self.activityIndicator startAnimating];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
}

-(void)menuDidTap
{
    AMSideBarViewController * sider=[self.navigationController.parentViewController isKindOfClass:[AMSideBarViewController class]]?(AMSideBarViewController *)self.navigationController.parentViewController:nil;
    [sider side];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
