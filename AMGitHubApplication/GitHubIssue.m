//
//  GitHubIssue.m
//  AMGitHubApplication
//
//  Created by Амин on 11.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "GitHubIssue.h"

@implementation GitHubIssue

+(GitHubIssue *)issueFromDictionary:(NSDictionary *)dictionary
{
    NSLog(@"%@",dictionary);
    GitHubIssue * issue=[[GitHubIssue alloc] init];
    NSString * validatingStr=dictionary[@"title"];
    issue.title=[validatingStr isEqualToString:@"<null>"]?@"N/A":validatingStr;
    
    validatingStr=dictionary[@"state"];
    issue.state=[validatingStr isEqualToString:@"<null>"]?@"N/A":validatingStr;
    
    issue.issueNumber=[NSString stringWithFormat:@"#%@",dictionary[@"number"]];
    
    validatingStr=dictionary[@"created_at"];
    issue.createDate=[validatingStr isEqualToString:@"<null>"]?@"N/A":[validatingStr substringToIndex:10];
    
    issue.comments=[NSString stringWithFormat:@"%@",dictionary[@"comments"]];
    
    validatingStr=dictionary[@"body"];
    issue.body=[validatingStr isEqualToString:@"<null>"]?@"N/A":validatingStr;
    
    issue.user=[GitHubUser userFromDictionary:dictionary[@"user"]];
    return issue;
}
@end
