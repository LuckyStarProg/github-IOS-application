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
    static InternetConnectionController * internetConnectionControllerInstance=0;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^
    {
        internetConnectionControllerInstance=[[InternetConnectionController alloc] init];
    });
    return internetConnectionControllerInstance;
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
            [request setValue:[NSString stringWithFormat:@"%ld",data.length] forHTTPHeaderField:@"Content-length"];
            [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        }
        else
        {
            NSString * encodedStr=[params componentsJoinedByString:@"&"];
            request.URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",reference,encodedStr]];
        }
    }
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^
     (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        
        if(data==nil)
        {
            Error(@"Data is nil!");
            return;
        }
        
        Success(data);
    }] resume];
}
@end
