//
//  AuthorizedUser.h
//  AMGitHubApplication
//
//  Created by Амин on 04.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubUser.h"
#import "GitHubApiController.h"
#import "AMDataManager.h"

@interface AuthorizedUser : GitHubUser
+(AuthorizedUser *)sharedUser;

@property (nonatomic)NSString * accessToken;
+(void)loginWithCode:(NSString *)code andCompletion:(void (^)(void))comlation;
+(BOOL)isExist;
+(void)readUser;
-(void)saveUser;
+(void)setUser:(GitHubUser *)user;
-(void)update;
-(void)logOut;
@end
