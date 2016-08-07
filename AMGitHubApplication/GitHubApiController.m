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
    return [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@",CLIENT_ID];
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
    NSArray * params=[NSArray arrayWithObjects:
                      [NSString stringWithFormat:@"q=%@",token],
                      [NSString stringWithFormat:@"per_page=%ld",perPage],
                      [NSString stringWithFormat:@"page=%ld",page],nil];
                       
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:@"/search/repositories"] andMethod:@"GET" andParameters:params andSuccess:Success orFailure:Fail];
}

-(void)newsWithPer_page:(NSUInteger)per_page andPage:(NSUInteger)page andComplation:(void (^)(NSArray<Event *> *))completion
{
    [super performRequestWithReference:[self.apiRef stringByAppendingPathComponent:[NSString stringWithFormat:@"/users/%@/received_events",[AuthorizedUser sharedUser].login]] andMethod:@"GET" andParameters:@{@"per_page":[NSString stringWithFormat:@"%ld",per_page], @"page":[NSString stringWithFormat:@"%ld",page]} andSuccess:^(NSData *data)
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
//    NSString* page = [NSString stringWithContentsOfURL:[NSURL URLWithString:[[GitHubApiController sharedController] verificationURL]]  encoding:NSUTF8StringEncoding  error:nil];
//    NSLog(@"%@",page);
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
