//
//  User.h
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitHubUser : NSObject

@property (nonatomic)NSString * name;
@property (nonatomic)NSString * apiRef;
@property (nonatomic)NSString * avatarPath;
@property (nonatomic)NSString * avatarRef;
@property (nonatomic)NSUInteger ID;
@property (nonatomic)NSArray * repos;

@end
