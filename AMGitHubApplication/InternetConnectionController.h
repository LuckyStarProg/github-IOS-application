//
//  InternetConnectionController.h
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternetConnectionController : NSObject

-(void)downloadDataWithReference:(NSString *)reference
                       andSuccess:(void (^)(NSString * path))Success
                          orError:(void (^)(NSString * message))Error;

-(void)performRequestWithReference:(NSString *)reference
                         andMethod:(NSString *)method
                     andParameters:(id)params
                    andSuccesBlock:(void (^)(NSData * data))Success
                           orError:(void (^)(NSString * message))Error;
@end
