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
    result.name=[NSString stringWithFormat:@"%@",dictionary[@"name"]];
    result.fullName=[NSString stringWithFormat:@"%@",dictionary[@"full_name"]];
    result.descriptionStr=[NSString stringWithFormat:@"%@",dictionary[@"description"]];
    result.user=[GitHubUser userFromDictionary:dictionary[@"owner"]];
    result.stars=[NSString stringWithFormat:@"%@",dictionary[@"stargazers_count"]];
    return result;
}
@end
