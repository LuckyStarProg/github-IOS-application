//
//  GitHubApiController.h
//  AMGitHubApplication
//
//  Created by Амин on 03.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "InternetConnectionController.h"
#import "GitHubUser.h"

@interface GitHubApiController : InternetConnectionController

+(GitHubApiController *)sharedController;

-(void)searchReposByToken:(NSString *)token andPerPage:(NSUInteger)perPage andPage:(NSUInteger)page andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail;

-(void)loginUserWithCode:(NSString *)code andSuccess:(void (^)(void))Success orFailure:(void (^)(void))Fail;
-(NSString *)tokenFromCode:(NSString *)code;
-(NSString *)verificationURL;
-(GitHubUser *)userFromToken:(NSString *)token;
@end
