//
//  GitHubApiController.m
//  AMGitHubApplication
//
//  Created by Амин on 03.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "GitHubApiController.h"

@interface GitHubApiController ()
@property (nonatomic)NSString * apiRef;
@property (nonatomic, readonly)NSString * clientID;
@property (nonatomic, readonly)NSString * clientSecret;
@end

@implementation GitHubApiController

#define CLIENT_ID @"8318492ac2d21b463e69"
#define CLIENT_SECRET @"6dcac3f941bf6cc14dfb754efa4ee764bd3078f9"

+(GitHubApiController *)sharedController
{
    static GitHubApiController * gitControllerInstance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^
                  {
                      gitControllerInstance=[[GitHubApiController alloc] init];
                      gitControllerInstance.apiRef=@"https://api.github.com";
                  });
    return gitControllerInstance;
}

-(NSURL *)tokenURLFromCode:(NSString *)code
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/login/oauth/access_token?code=%@&client_id=%@&client_secret=%@",code,CLIENT_ID,CLIENT_SECRET]];
}

-(NSURL *)userUrl:(NSString *)token
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/user?access_token=%@&client_id=%@&client_secret=%@", token, CLIENT_ID, CLIENT_SECRET]];
}

-(NSString *)verificationURL
{ 
    return [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&scope=repo%%20user",CLIENT_ID];
}

-(void)userFromLogin:(NSString *)login andComplation:(void (^)(GitHubUser *))complation
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/users/%@",login]] andMethod:@"GET" andParameters:nil andSuccess:^(NSData *data)
    {
        NSError * jsonError=nil;
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if(jsonError)
        {
            NSLog(@"%@",jsonError.localizedDescription);
            return;
        }
        complation([GitHubUser userFromDictionary:dict]);
    } orFailure:^(NSString *message)
    {
        NSLog(@"%@",message);
    }];
}

-(GitHubUser *)userFromToken:(NSString *)token
{
    NSString * page=[NSString stringWithContentsOfURL:[self userUrl:token] encoding:NSUTF8StringEncoding error:nil];
    if(![page containsString:@"Bad credentials"])
    {
        NSError * jsonError=nil;
        NSData * data =[page dataUsingEncoding:NSUTF8StringEncoding];
        if(!data)
        {
            return nil;
        }
        
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if(jsonError)
        {
            NSLog(@"%@",jsonError);
            return nil;
        }
        return [GitHubUser userFromDictionary:dict];
    }
    return nil;
}

-(NSString *)tokenFromCode:(NSString *)code
{
    NSString * page=[NSString stringWithContentsOfURL:[self tokenURLFromCode:code] encoding:NSUTF8StringEncoding error:nil];
    //validation
    page=[page substringToIndex:[page rangeOfString:@"&"].location];
    page=[page substringFromIndex:[page rangeOfString:@"="].location+1];
    return page;
}

-(void)searchReposByToken:(NSString *)token andPerPage:(NSUInteger)perPage andPage:(NSUInteger)page andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail
{
    NSLog(@"%@",token);
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:@"/search/repositories"] andMethod:@"GET" andParameters:@{@"q":token, @"per_page":[NSString stringWithFormat:@"%ld",perPage], @"page":[NSString stringWithFormat:@"%ld",page]} andSuccess:Success orFailure:Fail];
}

-(void)owndReposByUser:(GitHubUser *)user andPer_page:(NSUInteger)perPage andPage:(NSUInteger)page andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[user.login isEqualToString:[AuthorizedUser sharedUser].login]?@"/user/repos":[NSString stringWithFormat:@"/users/%@/repos",user.login]] andMethod:@"GET" andParameters:@{@"per_page":[NSString stringWithFormat:@"%ld",perPage],@"page":[NSString stringWithFormat:@"%ld",page],@"access_token":[AuthorizedUser sharedUser].accessToken} andSuccess:Success orFailure:Fail];
}

-(void)listWatchesForRepo:(GitHubRepository *)repo withComplation:(void(^)(NSArray * stars))complation
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/repos/%@/subscribers",repo.fullName]] andMethod:@"GET" andParameters:@{@"page":@"1", @"per_page":[NSString stringWithFormat:@"%ld",(NSUInteger)MAXFLOAT]} andSuccess:^(NSData *data)
    {
        NSError * jsonError=nil;
        NSArray * stars=[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if(jsonError)
        {
            NSLog(@"%@",jsonError.localizedDescription);
            return;
        }
        complation(stars);
    } orFailure:^(NSString *message)
    {
        NSLog(@"%@",message);
    }];
}
-(void)newsWithPer_page:(NSUInteger)per_page andPage:(NSUInteger)page andComplation:(void (^)(NSArray<Event *> *))completion
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/users/%@/received_events",[AuthorizedUser sharedUser].login]] andMethod:@"GET" andParameters:@{@"per_page":[NSString stringWithFormat:@"%ld",per_page], @"page":[NSString stringWithFormat:@"%ld",page], @"access_token":[AuthorizedUser sharedUser].accessToken} andSuccess:^(NSData *data)
    {
        NSError * error=nil;
        NSArray * eventDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSMutableArray<Event *> * news=[NSMutableArray array];
        if(error)
        {
            NSLog(@"%@",error.localizedDescription);
            return;
        }

        EventController * controller=[[EventController alloc] init];
        for(NSUInteger i=0; i<eventDictionary.count; ++i)
        {
            [news addObject:[controller eventFromDictionary:eventDictionary[i]]];
        }
        completion(news);
    } orFailure:^(NSString *message)
    {
        NSLog(@"%@",message);
    }];
    
}

-(void)repo:(GitHubRepository *)repo isStarred:(void(^)(BOOL isStarred))isStarred;
{
//    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/user/starred/%@?access_token=%@",repo.fullName,[AuthorizedUser sharedUser].accessToken]]]
//                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                      timeoutInterval:10];
//    request.HTTPMethod=@"GET";
//    [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
//    {
//        if([response isKindOfClass:[NSHTTPURLResponse class]])
//        {
//            NSHTTPURLResponse * httpResponse=(NSHTTPURLResponse *)response;
//            if(httpResponse.statusCode==204)
//            {
//                isStarred(YES);
//            }
//            else
//            {
//                isStarred(NO);
//            }
//        }
//    }];
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/user/starred/%@",repo.fullName]] andMethod:@"GET" andParameters:@{@"access_token":[AuthorizedUser sharedUser].accessToken} andSuccess:^(NSData *data)
    {
        isStarred(YES);
    } orFailure:^(NSString *message)
    {
        isStarred(NO);
    }];
}
-(void)starRepo:(GitHubRepository *)repo andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/user/starred/%@",repo.fullName]] andMethod:@"PUT" andParameters:@{@"access_token":[AuthorizedUser sharedUser].accessToken} andSuccess:Success orFailure:Fail];
}
-(void)unStarRepo:(GitHubRepository *)repo andSuccess:(void(^)(NSData *data))Success orFailure:(void(^)(NSString *message))Fail
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/user/starred/%@",repo.fullName]] andMethod:@"DELETE" andParameters:@{@"access_token":[AuthorizedUser sharedUser].accessToken} andSuccess:Success orFailure:Fail];
}

-(void)watchRepo:(GitHubRepository *)repo watchComplation:(void (^)(void))watch unWatchComplation:(void (^)(void))unwatch
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/user/subscriptions/%@",repo.fullName]] andMethod:@"GET" andParameters:@{@"access_token":[AuthorizedUser sharedUser].accessToken} andSuccess:^(NSData *data)
     {
         [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/user/subscriptions/%@",repo.fullName]] andMethod:@"DELETE" andParameters:@{@"access_token":[AuthorizedUser sharedUser].accessToken} andSuccess:^(NSData *data)
          {
              unwatch();
          } orFailure:^(NSString *message)
          {
              NSLog(@"%@",message);
          }];
     } orFailure:^(NSString *message)
     {
         [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/user/subscriptions/%@",repo.fullName]] andMethod:@"PUT" andParameters:@{@"access_token":[AuthorizedUser sharedUser].accessToken} andSuccess:^(NSData *data)
          {
              watch();
          } orFailure:^(NSString *message)
          {
              NSLog(@"%@",message);
          }];
     }];
}
-(void)followersForUser:(GitHubUser *)user andPerPage:(NSUInteger)per_page andPage:(NSUInteger)page andComplation:(void (^)(NSMutableArray<GitHubUser *> *))completion
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/users/%@/followers",user.login]] andMethod:@"GET" andParameters:@{@"per_page":[NSString stringWithFormat:@"%ld",per_page],@"page":[NSString stringWithFormat:@"%ld",page]} andSuccess:^(NSData *data)
    {
        NSError * error=nil;
        NSArray * usersDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSMutableArray<GitHubUser *> * followers=[NSMutableArray array];
        if(error)
        {
            NSLog(@"%@",error.localizedDescription);
            return;
        }
        
        for(NSUInteger i=0; i<usersDictionary.count; ++i)
        {
            [followers addObject:[GitHubUser userFromDictionary:usersDictionary[i]]];
        }
        
        completion(followers);
    } orFailure:^(NSString *message)
    {
        NSLog(@"%@",message);
    }];
}

-(void)followingForUser:(GitHubUser *)user andPerPage:(NSUInteger)per_page andPage:(NSUInteger)page andComplation:(void (^)(NSMutableArray<GitHubUser *> *))completion
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/users/%@/following",user.login]] andMethod:@"GET" andParameters:nil andSuccess:^(NSData *data)
     {
         NSError * error=nil;
         NSArray * usersDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         NSMutableArray<GitHubUser *> * followers=[NSMutableArray array];
         if(error)
         {
             NSLog(@"%@",error.localizedDescription);
             return;
         }
         
         for(NSUInteger i=0; i<usersDictionary.count; ++i)
         {
             [followers addObject:[GitHubUser userFromDictionary:usersDictionary[i]]];
         }
         
         completion(followers);
     } orFailure:^(NSString *message)
     {
         NSLog(@"%@",message);
     }];
}

-(void)commentsOnIssue:(GitHubIssue *)issue withPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page Success:(void (^)(NSMutableArray<GitHubIssue *> *))Sucess orFailure:(void (^)(NSString *))Fail
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/repos/%@/%@/issues/%@/comments",issue.user.login,issue.repo.name,issue.issueNumber]] andMethod:@"GET" andParameters:@{@"access_token":[AuthorizedUser sharedUser].accessToken, @"per_page":[NSString stringWithFormat:@"%ld",per_page], @"page":[NSString stringWithFormat:@"%ld",page]} andSuccess:^(NSData *data)
    {
        
    } orFailure:^(NSString *message)
    {
        
    }];
}

-(void)issuesWithState:(NSString *)state andPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page Success:(void (^)(NSMutableArray<GitHubIssue *> *))Sucess orFailure:(void (^)(NSString *))Fail
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:@"/issues"] andMethod:@"GET" andParameters:@{@"access_token":[AuthorizedUser sharedUser].accessToken, @"state":state, @"per_page":[NSString stringWithFormat:@"%ld",per_page], @"page":[NSString stringWithFormat:@"%ld",page]} andSuccess:^(NSData *data)
    {
        NSError * Error=nil;
        NSArray * issuesDicts=[NSJSONSerialization JSONObjectWithData:data options:0 error:&Error];
        if(Error)
        {
            Fail(Error.localizedDescription);
            return;
        }
        
        NSMutableArray<GitHubIssue *> * issues=[NSMutableArray array];
        for(NSDictionary * dict in issuesDicts)
        {
            [issues addObject:[GitHubIssue issueFromDictionary:dict]];
        }
        Sucess(issues);
    } orFailure:^(NSString *message)
    {
        Fail(message);
    }];
}

-(void)starredReposWithPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page andSuccess:(void (^)(NSMutableArray<GitHubRepository *> *))Sucess orFailure:(void (^)(NSString *))Fail
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:@"/user/starred"] andMethod:@"GET" andParameters:@{@"per_page":[NSString stringWithFormat:@"%ld",per_page], @"page":[NSString stringWithFormat:@"%ld",page], @"access_token":[AuthorizedUser sharedUser].accessToken} andSuccess:^(NSData *data)
    {
        NSError * Error=nil;
        NSArray * reposDicts=[NSJSONSerialization JSONObjectWithData:data options:0 error:&Error];
        NSLog(@"%@",reposDicts);
        if(Error)
        {
            Fail(Error.localizedDescription);
            return;
        }
        
        NSMutableArray<GitHubRepository *> * repos=[NSMutableArray array];
        for(NSDictionary * dict in reposDicts)
        {
            [repos addObject:[GitHubRepository repositoryFromDictionary:dict]];
        }
        Sucess(repos);
    } orFailure:^(NSString *message)
    {
        Fail(message);
    }];
}

-(void)issuesForRepo:(GitHubRepository *)repo withState:(NSString *)state andPer_Page:(NSUInteger)per_page andPage:(NSUInteger)page Success:(void (^)(NSMutableArray<GitHubIssue *> *))Sucess orFailure:(void (^)(NSString *))Fail
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/repos/%@/%@/issues",repo.user.login,repo.name]] andMethod:@"GET" andParameters:@{@"access_token":[AuthorizedUser sharedUser].accessToken, @"state":state, @"per_page":[NSString stringWithFormat:@"%ld",per_page], @"page":[NSString stringWithFormat:@"%ld",page]} andSuccess:^(NSData *data)
     {
         NSError * Error=nil;
         NSArray * issuesDicts=[NSJSONSerialization JSONObjectWithData:data options:0 error:&Error];
         if(Error)
         {
             Fail(Error.localizedDescription);
             return;
         }
         
         NSMutableArray<GitHubIssue *> * issues=[NSMutableArray array];
         for(NSDictionary * dict in issuesDicts)
         {
             [issues addObject:[GitHubIssue issueFromDictionary:dict]];
         }
         Sucess(issues);
     } orFailure:^(NSString *message)
     {
         Fail(message);
     }];
}

-(void)updateUserWithComplation:(void (^)(void))complation
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/user?access_token=%@",[AuthorizedUser sharedUser].accessToken]] andMethod:@"PATCH" andParameters:@{@"name":[AuthorizedUser sharedUser].name, @"email":[AuthorizedUser sharedUser].email, @"blog":[AuthorizedUser sharedUser].blog, @"company":[AuthorizedUser sharedUser].company, @"location":[AuthorizedUser sharedUser].location, @"bio":[AuthorizedUser sharedUser].bio} andSuccess:^(NSData *data)
    {
        NSError * jsonError=nil;
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSLog(@"%@",dict);
    } orFailure:^(NSString *message)
    {
        NSLog(@"%@",message);
    }];
}

-(void)eventsForUser:(GitHubUser *)user withPer_page:(NSUInteger)per_page andPage:(NSUInteger)page andComplation:(void (^)(NSArray<Event *> *))completion
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/users/%@/events",user.login]] andMethod:@"GET" andParameters:@{@"per_page":[NSString stringWithFormat:@"%ld",per_page], @"page":[NSString stringWithFormat:@"%ld",page],@"access_token":[AuthorizedUser sharedUser].accessToken} andSuccess:^(NSData *data)
     {
         NSError * error=nil;
         NSArray * eventDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         NSMutableArray<Event *> * news=[NSMutableArray array];
         if(error)
         {
             NSLog(@"%@",error.localizedDescription);
             return;
         }
         
         EventController * controller=[[EventController alloc] init];
         for(NSUInteger i=0; i<eventDictionary.count; ++i)
         {
             [news addObject:[controller eventFromDictionary:eventDictionary[i]]];
         }
         completion(news);
     } orFailure:^(NSString *message)
     {
         NSLog(@"%@",message);
     }];
}

-(void)loginUserWithCode:(NSString *)code andSuccess:(void (^)(void))Success orFailure:(void (^)(void))Fail
{
    if(code)
    {
        code=[code substringFromIndex:[code rangeOfString:@"code="].location+5];
        if(code.length>10)
        {
            [AuthorizedUser loginWithCode:code andCompletion:Success];
        }
        else
        {
            Fail();
        }
    }
    else
    {
        Fail();
    }
}
@end
