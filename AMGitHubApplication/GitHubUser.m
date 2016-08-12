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
    
    NSLog(@"%@",dictionary);
    result.ID=(NSUInteger)dictionary[@"id"];
    result.name=[NSString stringWithFormat:@"%@",dictionary[@"name"]];
    result.apiRef=[NSString stringWithFormat:@"%@",dictionary[@"url"]];
    result.avatarRef=[NSString stringWithFormat:@"%@",dictionary[@"avatar_url"]];
    result.reposRef=[NSString stringWithFormat:@"%@",dictionary[@"repos_url"]];
    result.login=[NSString stringWithFormat:@"%@",dictionary[@"login"]];
    result.followers_count=[NSString stringWithFormat:@"%@",dictionary[@"followers"]].integerValue;
    result.following_count=[NSString stringWithFormat:@"%@",dictionary[@"following"]].integerValue;
    
    NSString * equalStr=[NSString stringWithFormat:@"%@",dictionary[@"location"]];
    result.location=[equalStr isEqualToString:@"<null>"]?@"N/A":equalStr;
    
    equalStr=[NSString stringWithFormat:@"%@",dictionary[@"email"]];
    result.email=[equalStr isEqualToString:@"<null>"]?@"N/A":equalStr;
    
    equalStr=[NSString stringWithFormat:@"%@",dictionary[@"company"]];
    result.company=[equalStr isEqualToString:@"<null>"]?@"N/A":equalStr;
    
    equalStr=[NSString stringWithFormat:@"%@",dictionary[@"blog"]];
    result.blog=[equalStr isEqualToString:@"<null>"]?@"N/A":equalStr;
    
    equalStr=[NSString stringWithFormat:@"%@",dictionary[@"bio"]];
    result.bio=[equalStr isEqualToString:@"<null>"]?@"N/A":equalStr;
//    [[GitHubApiController sharedController] followersForUser:result andComplation:^(NSArray * followers)
//    {
//        result.followers=followers;
//    }];
//    [[GitHubApiController sharedController] followingForUser:result andComplation:^(NSArray * following)
//     {
//         result.following=following;
//     }];
//    while (!result.following && !result.followers);
    NSLog(@"%@",result.bio);
    return result;
}
@end
