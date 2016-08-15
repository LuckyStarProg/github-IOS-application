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
-(NSURL *)tokenURLFromCode:(NSString *)code;
-(NSURL *)userUrl:(NSString *)token;
-(NSString *)verificationURL;
-(GitHubUser *)userFromToken:(NSString *)token;
-(NSString *)tokenFromCode:(NSString *)code;
-(void)loginUserWithCode:(NSString *)code andSuccess:(void (^)(void))Success orFailure:(void (^)(void))Fail;

-(void)userFromLogin:(NSString *)login andComplation:(void (^)(GitHubUser *))complation;
-(void)followersForUser:(GitHubUser *)user andPerPage:(NSUInteger)per_page andPage:(NSUInteger)page andSuccess:(void(^)(NSMutableArray<GitHubUser *> *data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)followingForUser:(GitHubUser *)user andPerPage:(NSUInteger)per_page andPage:(NSUInteger)page andSuccess:(void(^)(NSMutableArray<GitHubUser *> *data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)deletAuthUserWithSuccess:(void(^)(void))Success orFailure:(void(^)(NSString *message))Fail;
-(void)updateUserWithFailure:(void (^)(NSString *))Fail;

-(void)refreshRepo:(GitHubRepository *)repo andSuccess:(void(^)(GitHubRepository * repo))Success orFailure:(void(^)(NSString *message))Fail;
-(void)searchReposByToken:(NSString *)token andPerPage:(NSUInteger)perPage andPage:(NSUInteger)page andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)owndReposByUser:(GitHubUser *)user andPer_page:(NSUInteger)perPage andPage:(NSUInteger)page andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail;

-(void)listWatchesForRepo:(GitHubRepository *)repo andSuccess:(void(^)(NSArray *))Success orFailure:(void(^)(NSString *message))Fail;
-(void)watchRepo:(GitHubRepository *)repo watchComplation:(void (^)(void))watch unWatchComplation:(void (^)(void))unwatch andFailure:(void(^)(NSString *message))Fail;

-(void)repo:(GitHubRepository *)repo isStarred:(void(^)(BOOL isStarred))isStarred;;
-(void)starRepo:(GitHubRepository *)repo andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)unStarRepo:(GitHubRepository *)repo andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)starredReposWithPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page andSuccess:(void (^)(NSMutableArray<GitHubRepository *> *))Sucess orFailure:(void (^)(NSString *))Fail;
-(void)starRepo:(GitHubRepository *)repo starComplation:(void (^)(void))star unStarComplation:(void (^)(void))unstar andFailure:(void(^)(NSString *message))Fail;

-(void)newsWithPer_page:(NSUInteger)per_page andPage:(NSUInteger)page andSuccess:(void(^)(NSArray<Event *> * data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)eventsForUser:(GitHubUser *)user withPer_page:(NSUInteger)per_page andPage:(NSUInteger)page Success:(void (^)(NSMutableArray<Event *> *))Success orFailure:(void (^)(NSString *))Fail;

-(void)sendCommentToIssue:(GitHubIssue *)issue withBody:(NSString *)body andSuccess:(void(^)(GitHubIssueComment *data))Success orFailure:(void(^)(NSString *message))Fail;
-(void)commentsOnIssue:(GitHubIssue *)issue withPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page Success:(void (^)(NSMutableArray<GitHubIssueComment *> *))Sucess orFailure:(void (^)(NSString *))Fail;
-(void)issuesWithState:(NSString *)state andPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page Success:(void (^)(NSMutableArray<GitHubIssue *> *))Sucess orFailure:(void (^)(NSString *))Fail;
-(void)issuesForRepo:(GitHubRepository *)repo withState:(NSString *)state andPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page Success:(void (^)(NSMutableArray<GitHubIssue *> *))Sucess orFailure:(void (^)(NSString *))Fail;
@end
