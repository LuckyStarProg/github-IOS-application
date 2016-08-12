//
//  User.h
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitHubUser : NSObject

@property (nonatomic)NSString * name;
@property (nonatomic)NSString * apiRef;
@property (nonatomic)NSString * avatarPath;
@property (nonatomic)NSString * avatarRef;
@property (nonatomic)NSUInteger ID;
@property (nonatomic)NSString * reposRef;
@property (nonatomic)NSString * login;
@property (nonatomic)NSArray<GitHubUser *> * followers;
@property (nonatomic)NSArray<GitHubUser *> * following;
@property (nonatomic)NSUInteger followers_count;
@property (nonatomic)NSUInteger following_count;
@property (nonatomic)NSString * location;
@property (nonatomic)NSString * email;
@property (nonatomic)NSString * company;
@property (nonatomic)NSString * blog;
@property (nonatomic)NSString * bio;
+(GitHubUser *)userFromDictionary:(NSDictionary *)dictionary;
@end
