//
//  RepositoryViewController.h
//  AMGitHubApplication
//
//  Created by Амин on 01.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GitHubRepository.h"
#import "RepoAvatarView.h"
#import "UIImage+ResizingImg.h"
#import "dataCollectionViewCell.h"
#import "UIColor+GitHubColor.h"
#import "GitHubApiController.h"
#import "UserProfileViewController.h"
#import "IssuesViewController.h"
#import "AlertController.h"

@interface RepositoryViewController : UIViewController

@property (nonatomic)GitHubRepository * repo;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
