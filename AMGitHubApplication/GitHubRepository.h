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
@property (nonatomic)NSString * descriptionStr;
@property (nonatomic)GitHubUser * user;
@end
