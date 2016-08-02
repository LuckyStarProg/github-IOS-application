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
    result.name=[NSString stringWithFormat:@"%@",dictionary[@"name"]];
    result.apiRef=[NSString stringWithFormat:@"%@",dictionary[@"url"]];
    result.avatarRef=[NSString stringWithFormat:@"%@",dictionary[@"avatar_url"]];
    result.reposRef=[NSString stringWithFormat:@"%@",dictionary[@"repos_url"]];
    result.login=[NSString stringWithFormat:@"%@",dictionary[@"login"]];
    return result;
}
@end
