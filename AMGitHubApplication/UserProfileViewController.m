//
//  UserProfileViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 07.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController()<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
@property (nonatomic)NSArray * methods;
@property (nonatomic)UIView * footerView;
@property (nonatomic)usersListViewController * usersList;
@property (nonatomic)EditViewController * editController;
@property (nonatomic)UIActivityIndicatorView * indicator;
@property (nonatomic)UIRefreshControl * refresh;
@end

@implementation UserProfileViewController
#pragma mark - CollectionView delegate methods
#define ROW_COUNT 11

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RepoAvatarView * headerView;
    if(kind==UICollectionElementKindSectionHeader)
    {
        headerView=(RepoAvatarView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            headerView.imageView.image=[UIImage imageWithContentsOfFile:self.user.avatarPath];
            headerView.nameLabel.text=self.user.login;
            headerView.descriptionLabel.text=self.user.name;
            headerView.imageView.layer.borderWidth=2.0;
            headerView.imageView.layer.borderColor=[UIColor whiteColor].CGColor;
    }
    return headerView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    SEL selector = NSSelectorFromString(self.methods[indexPath.row]);
    ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    if(self.preferredInterfaceOrientationForPresentation==UIInterfaceOrientationPortrait || self.preferredInterfaceOrientationForPresentation==UIInterfaceOrientationPortraitUpsideDown)
    {
        size=CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height*0.3 + [RepoAvatarView heightForText:self.user.name]);
    }
    else
    {
        size=CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height*0.5 + [RepoAvatarView heightForText:self.user.name]);
    }
    
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout*)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;

    if(indexPath.row==2 || indexPath.row==5)
    {
        size.height=20.0;
        size.width=collectionView.bounds.size.width;
    }
    else if(indexPath.row>2&&indexPath.row<5)
    {
        size.height=45.0;
        size.width=collectionView.bounds.size.width;
    }
    else if(indexPath.row==10)
    {
        size.width=collectionView.bounds.size.width;
        size.height=[RepoAvatarView heightForText:self.user.bio]+20;
    }
    else
    {
        size.height=45.0;
        size.width=collectionView.bounds.size.width/2;
    }
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ROW_COUNT;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    dataCollectionViewCell * cell=(dataCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"Cell%ld",(long)indexPath.row] forIndexPath:indexPath];
    UIView * rightSeparatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0, cell.bounds.size.height)];
    rightSeparatorView.backgroundColor=[UIColor SeparatorColor];
    UIView * bottomSeparatorView=[[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-1, cell.bounds.size.width, 1.0)];
    bottomSeparatorView.backgroundColor=[UIColor SeparatorColor];
    switch (indexPath.row)
    {
        case 0:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=[NSString stringWithFormat:@"%ld",self.user.followers_count];
            break;
        case 1:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=[NSString stringWithFormat:@"%ld",self.user.following_count];
            break;
        case 3:
            cell.backgroundColor=[UIColor whiteColor];
            break;
        case 4:
            cell.backgroundColor=[UIColor whiteColor];
            break;
        case 6:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.user.location;
            break;
        case 7:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.user.email;
            break;
        case 8:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.user.company;
            break;
        case 9:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.user.blog;
            break;
        case 10:
            cell.backgroundColor=[UIColor whiteColor];
            cell.data.text=self.user.bio;
            break;
        default:
            cell.backgroundColor=[UIColor SeparatorColor];
            break;
    }
    
    return cell;
}

#pragma mark - Life Cycle
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.footerView.frame=CGRectMake(self.footerView.frame.origin.x, -self.collectionView.contentOffset.y, self.footerView.frame.size.width, self.footerView.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
    [UIView animateWithDuration:duration animations:^
     {
         [self.collectionView reloadData];
     }];
    
}

-(void)followersDidTap
{
    self.usersList=[[usersListViewController alloc] initWithUpdateNotification:@"Followers"];
    self.usersList.title=@"Followers";
    self.usersList.parentUser=self.user;
    [self.navigationController pushViewController:self.usersList animated:YES];
}

-(void)followingDidTap
{
    self.usersList=[[usersListViewController alloc] initWithUpdateNotification:@"Following"];
    self.usersList.title=@"Following";
    self.usersList.parentUser=self.user;
    [self.navigationController pushViewController:self.usersList animated:YES];
}

-(void)emptyMethod
{
}

-(void)eventsDidTap
{
    NewsViewController * eventsViewController=[[NewsViewController alloc] initWithUpdateNotification:@"addOwnEvens"];
    eventsViewController.owner=self.user;
    [self.navigationController pushViewController:eventsViewController animated:YES];
}

-(void)reposDidTap
{
    repoListViewController * repos=[[repoListViewController alloc] initWithUpdateNotification:@"addOwnRepos"];
    repos.owner=self.user;
    [self.navigationController pushViewController:repos animated:YES];
}

-(void)locationDidTap
{
    self.editController=[[EditViewController alloc] initWithString:@"location"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.editController] animated:YES completion:^
    {
    }];
}

-(void)emailDidTap
{
    self.editController=[[EditViewController alloc] initWithString:@"email"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.editController] animated:YES completion:^
     {
     }];
}
-(void)companyDidTap
{
    self.editController=[[EditViewController alloc] initWithString:@"company"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.editController] animated:YES completion:^
     {
     }];
}
-(void)blogDidTap
{
    self.editController=[[EditViewController alloc] initWithString:@"blog"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.editController] animated:YES completion:^
     {
     }];
}

-(void)bioDidTap
{
    self.editController=[[EditViewController alloc] initWithString:@"bio"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.editController] animated:YES completion:^
     {
     }];
}
-(void)setUser:(GitHubUser *)user
{
    _user=user;
    [self.collectionView reloadData];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    self.navigationController.navigationBar.alpha=1.0;
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor GitHubColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if(self.navigationController.viewControllers.count<2)
    {
        UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
        menuItem.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=menuItem;
    }
    
    self.refresh=[[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-15, 0, 40, 40)];

    self.refresh.tintColor=[UIColor whiteColor];
    [self.refresh addTarget:self action:@selector(refrashData) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refresh];

    UIView * upperView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

    upperView.backgroundColor=[UIColor GitHubColor];
    
    self.collectionView.backgroundView=upperView;
    
    self.footerView=[[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bounds.size.height/3.3, self.collectionView.bounds.size.width, [UIScreen mainScreen].bounds.size.height*2)];
    self.footerView.backgroundColor=[UIColor SeparatorColor];
    [upperView addSubview:self.footerView];
    
    if([[AuthorizedUser sharedUser].login isEqualToString:self.user.login])
    {
        self.methods=[NSArray arrayWithObjects:@"followersDidTap",@"followingDidTap",@"emptyMethod",@"eventsDidTap",@"reposDidTap",@"emptyMethod",@"locationDidTap",@"emailDidTap",@"companyDidTap",@"blogDidTap",@"bioDidTap", nil];
    }
    else
    {
        self.methods=[NSArray arrayWithObjects:@"followersDidTap",@"followingDidTap",@"emptyMethod",@"eventsDidTap",@"reposDidTap",@"emptyMethod",@"emptyMethod",@"emptyMethod",@"emptyMethod",@"emptyMethod",@"emptyMethod", nil];
    }
    

    self.editController=[[EditViewController alloc] init];
}

-(void)refrashData
{
    [[GitHubApiController sharedController] userFromLogin:self.user.login andComplation:^(GitHubUser * user)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            user.avatarPath=self.user.avatarPath;
            self.user=user;
            [self.collectionView reloadData];
            [self.refresh endRefreshing];
        });
    }];
}

-(void)menuDidTap
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
    [sider side];
}

-(UIImageView *)iconView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[AuthorizedUser sharedUser].avatarPath]];
}

-(NSString *)description
{
    return [AuthorizedUser sharedUser].login?[AuthorizedUser sharedUser].login:@"User";
}

@end
