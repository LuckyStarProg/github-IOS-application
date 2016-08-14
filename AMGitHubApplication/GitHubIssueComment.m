//
//  GitHubIssueComment.m
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "GitHubIssueComment.h"

@implementation GitHubIssueComment

+(GitHubIssueComment *)commentByDictionary:(NSDictionary *)dictionary
{
    GitHubIssueComment * result=[[GitHubIssueComment alloc] init];
    result.user=[GitHubUser userFromDictionary:dictionary[@"user"]];
    NSString * validatingStr=[NSString stringWithFormat:@"%@",dictionary[@"body"]];
    result.body=[validatingStr isEqualToString:@"<null>"]?@"N/A":validatingStr;
    
    validatingStr=[NSString stringWithFormat:@"%@",dictionary[@"created_at"]];
    result.createdDate=[validatingStr isEqualToString:@"<null>"]?@"N/A":[validatingStr substringToIndex:10];
    return result;
}
@end
