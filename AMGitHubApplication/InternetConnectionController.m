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

-(NSString *)encodeString:(id)params
{
    NSMutableArray * result=[NSMutableArray array];
    NSDictionary * dict=params;
    NSArray * keys=[dict allKeys];
    NSArray * values=[dict allValues];
    
    for(int i=0;i<keys.count;++i)
    {
        [result addObject:[NSString stringWithFormat:@"%@=%@",keys[i],values[i]]];
    }
    return [result componentsJoinedByString:@"&"];
}

-(void)performRequestWithReference:(NSString *)reference
                         andMethod:(NSString *)method
                     andParameters:(id)params
                        andSuccess:(void (^)(NSData * data))Success
                           orFailure:(void (^)(NSString * message))Error
{
    
    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:reference]
                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        timeoutInterval:10];
    request.HTTPMethod=method;

    if(params)
    {
        if([method  isEqualToString:@"PUT"] || [method  isEqualToString:@"POST"] || [method  isEqualToString:@"DELETE"] || [method  isEqualToString:@"PATCH"])
        {
            NSError * serialisationError=nil;
            NSData * data=[NSJSONSerialization dataWithJSONObject:params
                                                          options:0
                                                            error:&serialisationError];
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
            
            request.HTTPBody=data;
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:[NSString stringWithFormat:@"%ld",data.length] forHTTPHeaderField:@"Content-length"];
            [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        }
        NSString * encodedStr=[self encodeString:params];
        request.URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",reference,encodedStr]];
    }
    NSLog(@"%@",request.URL);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^
     (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSString * errorStr=nil;
        if((errorStr=[self statusCodeWithResponse:response andError:error]))
        {
            //Error(errorStr);
            return;
        }
        if(data==nil)
        {
            Error(@"Data is nil!");
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
                Success(data);
        });
    }] resume];
}
@end
