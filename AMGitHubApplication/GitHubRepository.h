//
//  Repository.h
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubUser.h"

@interface GitHubRepository : NSObject

@property (nonatomic)NSUInteger ID;
@property (nonatomic)NSString * name;
@property (nonatomic)NSString * fullName;
@property (nonatomic)NSString * repoReference;
@property (nonatomic)NSString * descriptionStr;
@property (nonatomic)NSString * stars;
@property (nonatomic)NSString * forks;//forks_count
@property (nonatomic)NSString * watchers;//watchers
@property (nonatomic)NSString * issues;//open_issues_count
@property (nonatomic)BOOL isPrivate;//private
@property (nonatomic)NSString * date;//updated_at
@property (nonatomic)NSString * language;//language
@property (nonatomic)GitHubUser * user;

+(GitHubRepository *)repositoryFromDictionary:(NSDictionary *)dictionary;
@end
