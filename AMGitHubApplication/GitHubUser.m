//
//  User.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "GitHubUser.h"

@implementation GitHubUser

+(GitHubUser *)userFromDictionary:(NSDictionary *)dictionary
{
    GitHubUser * result=[[GitHubUser alloc] init];
    
    result.ID=(NSUInteger)dictionary[@"id"];
    result.name=(NSString *)dictionary[@"name"];
    result.apiRef=(NSString *)dictionary[@"url"];
    result.avatarRef=(NSString *)dictionary[@"avatar_url"];
    result.reposRef=(NSString *)dictionary[@"repos_url"];
    
    return result;
}
@end
