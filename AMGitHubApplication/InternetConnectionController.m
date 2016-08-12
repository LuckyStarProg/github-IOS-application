//
//  InternetConnectionController.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "InternetConnectionController.h"

@interface InternetConnectionController ()
@end

@implementation InternetConnectionController

+(InternetConnectionController *) sharedController
{
    static InternetConnectionController * internetConnectionControllerInstance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^
    {
        internetConnectionControllerInstance=[[InternetConnectionController alloc] init];
    });
    return internetConnectionControllerInstance;
}

-(NSString *)statusCodeWithResponse:(NSURLResponse *)response andError:(NSError *)error
{
    if(error)
    {
        return @"The request to load this item did not complete successfuly! Please check your connection and try again.";
    }
    NSHTTPURLResponse * httpResponse=nil;
    if(![response isKindOfClass:[NSHTTPURLResponse class]])
    {
        return nil;
    }

    httpResponse=(NSHTTPURLResponse *)response;
    NSString * errorStr=nil;
    NSInteger status=httpResponse.statusCode;
    
    NSLog(@"%@",response);
    if(status>=200 && status<300)
    {
        //success
    }
    else if(status>=400 && status<500)
    {
        errorStr=@"Client error";
    }
    else if(status>=500 && status<600)
    {
        errorStr=@"Server error";
    }
    else
    {
        errorStr=@"Unknown error";
    }

    return errorStr;
}

-(NSString *)encodeString:(NSDictionary *)params
{
    NSMutableArray * result=[NSMutableArray array];
    NSArray * keys=[params allKeys];
    NSArray * values=[params allValues];
    
    for(int i=0;i<keys.count;++i)
    {
        [result addObject:[NSString stringWithFormat:@"%@=%@",[keys[i] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],[values[i] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        NSLog(@"%@",values[i]);
    }
    
    return [result componentsJoinedByString:@"&"];
}

-(void)performRequestWithReference:(NSString *)reference
                         andMethod:(NSString *)method
                     andParameters:(NSDictionary *)params
                        andSuccess:(void (^)(NSData * data))Success
                           orFailure:(void (^)(NSString * message))Error
{
    
    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:reference]
                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        timeoutInterval:10];
    request.HTTPMethod=method;
    //[request setValue:@"repo" forHTTPHeaderField:@"X-OAuth-Scopes"];
    //[request setValue:@"repo" forHTTPHeaderField:@"X-Accepted-OAuth-Scopes"];
    
//    NSString *authenticationString = @"LuckyStarProg:Allah2911";
//    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
//    NSString *authenticationValue = [authenticationData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    [request setValue:[NSString stringWithFormat:@"Basic %@", authenticationValue] forHTTPHeaderField:@"Authorization"];
//    
//    request.URL=[NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/authorizations"]];
//    request.HTTPMethod=@"POST";
//    NSError * serialisationError=nil;
//    NSData * data=[NSJSONSerialization dataWithJSONObject:@{@"note":@"admin",@"client_id":@"8318492ac2d21b463e69",@"client_secret":@"6dcac3f941bf6cc14dfb754efa4ee764bd3078f9"} options:0 error:&serialisationError];
//    
//    request.HTTPBody=data;
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    if(params)
    {
        if([method  isEqualToString:@"POST"] || [method  isEqualToString:@"PATCH"])
        {
            NSError * serialisationError=nil;
            NSData * data=[NSJSONSerialization dataWithJSONObject:params options:0 error:&serialisationError];
            if(serialisationError)
            {
                Error(@"JSONSerialisation error!");
                return;
            }
            
            if(!data)
            {
                Error(@"Error data is nil!");
                return;
            }
            
            NSLog(@"%ld",data.length);
            request.HTTPBody=data;
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:[NSString stringWithFormat:@"%ld",data.length] forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        }
        else
        {
            NSString * encodedStr=[self encodeString:params];
            NSString * ar=[NSString stringWithFormat:@"%@?%@",reference,encodedStr];
            NSURL * url=[NSURL URLWithString:ar];
            NSLog(@"%@",url);
            request.URL=url;
        }
    }
//    NSData * data=[@"LuckyStarProg:Allah2911" dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody=data;
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:[NSString stringWithFormat:@"%ld",data.length] forHTTPHeaderField:@"Content-length"];
//    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"%@",request);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^
     (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSString * errorStr=nil;
        if((errorStr=[self statusCodeWithResponse:response andError:error]))
        {
            Error(errorStr);
            return;
        }
        if(data==nil)
        {
            Error(@"Data is nil!");
            return;
        }
//        NSError * Error=nil;
//        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&Error];
//        NSLog(@"%@",dict);
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
                Success(data);
        });
    }] resume];
}
@end
