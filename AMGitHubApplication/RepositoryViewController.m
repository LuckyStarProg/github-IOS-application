//
//  RepositoryViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 01.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "RepositoryViewController.h"
#import "UIImage+ResizingImg.h"
#import "repoCollectionViewCell.h"
#import "UIColor+GitHubColor.h"

@interface RepositoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
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

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}
//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
////    UIEdgeInsets insets;
////    switch (indexPath.row)
////    {
////        case 0:
////            cell.backgroundColor=[UIColor whiteColor];
////            break;
////        case 1:
////            cell.backgroundColor=[UIColor whiteColor];
////            break;
////        case 2:
////            cell.backgroundColor=[UIColor whiteColor];
////            break;
////        case 4:
////            cell.backgroundColor=[UIColor whiteColor];
////            break;
////        case 5:
////            cell.backgroundColor=[UIColor whiteColor];
////            break;
////        case 6:
////            cell.backgroundColor=[UIColor whiteColor];
////            break;
////        case 7:
////            cell.backgroundColor=[UIColor whiteColor];
////            break;
////        case 8:
////            cell.backgroundColor=[UIColor whiteColor];
////            break;
////        case 9:
////            cell.backgroundColor=[UIColor whiteColor];
////            break;
////        case 10:
////            cell.backgroundColor=[UIColor whiteColor];
////            break;
////        default:
////            cell.backgroundColor=[UIColor grayColor];
////            break;
////    }
//    
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
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
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    repoCollectionViewCell * cell=(repoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"Cell%ld",indexPath.row] forIndexPath:indexPath];
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
        //[self.collectionView reloadInputViews];
        //[self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexpath]];
    [UIView animateWithDuration:duration animations:^
    {
           [self.collectionView reloadData];
    }];

}

-(void)viewDidLoad
{
    [super viewDidLoad];
//    self.collactionView=[[UICollectionView alloc] initWithFrame:self.view.bounds];
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"repoView" owner:self options:nil];
//    RepoAvatarView * headerView = [nib objectAtIndex:0];
//    headerView.imageView.image=[[UIImage imageWithContentsOfFile:self.repo.user.avatarPath] toSize:headerView.imageView.bounds.size];
//    headerView.nameLabel.text=self.repo.name;
//    headerView.descriptionLabel.text=self.repo.descriptionStr;
//    
//    [headerView setBounds:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height*0.3 + [RepoAvatarView heightForText:headerView.descriptionLabel.text])];
//    [headerView setFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height*0.3  + [RepoAvatarView heightForText:headerView.descriptionLabel.text])];
//    
//    self.collactionView=headerView.backgroundColor;
//    self.tableView.tableFooterView=[UIView new];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    UIView * upperView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    upperView.backgroundColor=[UIColor GitHubColor];
    
    NSLog(@"%@",self.collectionView.backgroundView);
    self.collectionView.backgroundView=upperView;
    
    UIView * footerView=[[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bounds.size.height/3.3, self.collectionView.bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    footerView.backgroundColor=[UIColor SeparatorColor];
    [upperView addSubview:footerView];
    //self.collectionView.backgroundColor=[UIColor SeparatorColor];
    //upperView.backgroundColor=[UIColor GitHubColor];
    //self.collectionView.layer;
    //self.collectionView.backgroundColor=[UIColor SeparatorColor];
    //self.collectionView.pagingEnabled=NO;
    //self.collectionView.enabled
    //[self.view addSubview:self.tableView];
}
@end
