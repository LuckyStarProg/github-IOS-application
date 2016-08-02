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
    result.forks=[NSString stringWithFormat:@"%@",dictionary[@"forks_count"]];
    result.watchers=[NSString stringWithFormat:@"%@",dictionary[@"watchers"]];
    result.issues=[NSString stringWithFormat:@"%@",dictionary[@"open_issues_count"]];
    result.isPrivate=(BOOL)dictionary[@"private"];
    result.date=[[NSString stringWithFormat:@"%@",dictionary[@"updated_at"]] substringToIndex:10];
    
    NSString * lang=[NSString stringWithFormat:@"%@",dictionary[@"language"]];
    result.language=[lang isEqualToString:@"<null>"]?@"N/A":lang;
    return result;
}
@end
