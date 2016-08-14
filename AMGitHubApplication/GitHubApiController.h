//
//  GitHubApiController.h
//  AMGitHubApplication
//
//  Created by Амин on 03.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "InternetConnectionController.h"
#import "GitHubUser.h"
#import "EventController.h"
#import "AuthorizedUser.h"
#import "GitHubRepository.h"
#import "GitHubIssue.h"
#import "GitHubIssueComment.h"

@interface GitHubApiController : InternetConnectionController

+(GitHubApiController *)sharedController;

-(void)repo:(GitHubRepository *)repo isStarred:(void(^)(BOOL isStarred))isStarred;
-(void)userFromLogin:(NSString *)login andComplation:(void (^)(GitHubUser *))complation;
-(void)followingForUser:(GitHubUser *)user andPerPage:(NSUInteger)per_page andPage:(NSUInteger)page andComplation:(void (^)(NSMutableArray<GitHubUser *> *))completion;
-(void)followersForUser:(GitHubUser *)user andPerPage:(NSUInteger)per_page andPage:(NSUInteger)page andComplation:(void (^)(NSMutableArray<GitHubUser *> *))completion;
-(void)issuesWithState:(NSString *)state andPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page Success:(void (^)(NSMutableArray<GitHubIssue *> *))Sucess orFailure:(void (^)(NSString *))Fail;
-(void)issuesForRepo:(GitHubRepository *)repo withState:(NSString *)state andPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page Success:(void (^)(NSMutableArray<GitHubIssue *> *))Sucess orFailure:(void (^)(NSString *))Fail;
-(void)starredReposWithPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page andSuccess:(void (^)(NSMutableArray<GitHubRepository *> *))Sucess orFailure:(void (^)(NSString *))Fail;
-(void)commentsOnIssue:(GitHubIssue *)issue withPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page Success:(void (^)(NSMutableArray<GitHubIssueComment *> *))Sucess orFailure:(void (^)(NSString *))Fail;
-(void)listWatchesForRepo:(GitHubRepository *)repo withComplation:(void(^)(NSArray * stars))complation;
-(void)watchRepo:(GitHubRepository *)repo watchComplation:(void (^)(void))watch unWatchComplation:(void (^)(void))unwatch;
-(void)unStarRepo:(GitHubRepository *)repo andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)searchReposByToken:(NSString *)token andPerPage:(NSUInteger)perPage andPage:(NSUInteger)page andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)starRepo:(GitHubRepository *)repo andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)owndReposByUser:(GitHubUser *)user andPer_page:(NSUInteger)perPage andPage:(NSUInteger)page andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)deleAuthUserWithCpmplation:(void (^)(void))completion;
-(void)eventsForUser:(GitHubUser *)user withPer_page:(NSUInteger)per_page andPage:(NSUInteger)page andComplation:(void (^)(NSArray<Event *> *))completion;
-(void)newsWithPer_page:(NSUInteger)per_page andPage:(NSUInteger)page andComplation:(void (^)(NSArray<Event *> *))completion;
-(void)loginUserWithCode:(NSString *)code andSuccess:(void (^)(void))Success orFailure:(void (^)(void))Fail;
-(void)updateUserWithComplation:(void (^)(void))complation;
-(NSString *)tokenFromCode:(NSString *)code;
-(void)refreshRepo:(GitHubRepository *)repo andSuccess:(void(^)(GitHubRepository * repo))Success orFailure:(void(^)(NSString *message))Fail;
-(NSString *)verificationURL;
-(GitHubUser *)userFromToken:(NSString *)token;
@end
