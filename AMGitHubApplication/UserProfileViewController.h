//
//  UserProfileViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 07.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepositoryViewController.h"
#import "GitHubApiController.h"
@interface UserProfileViewController : UIViewController

@property (nonatomic) IBOutlet UICollectionView *collectionView;
-(UIImageView *)iconView;
@property (nonatomic)GitHubUser * user;
-(void)setUser:(GitHubUser *)user;
@end
