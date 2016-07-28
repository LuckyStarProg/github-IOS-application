//
//  Repository.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "GitHubRepository.h"
#import "GitHubUser.h"

@implementation GitHubRepository

+(GitHubRepository *)repositoryFromDictionary:(NSDictionary *)dictionary
{
    GitHubRepository * result=[[GitHubRepository alloc] init];
    
    result.ID=(NSUInteger)dictionary[@"id"];
    result.name=(NSString *)dictionary[@"name"];
    result.fullName=(NSString *)dictionary[@"full_name"];
    result.descriptionStr=(NSString *)dictionary[@"description"];
    result.user=[GitHubUser userFromDictionary:dictionary[@"owner"]];
    
    return result;
}
@end
