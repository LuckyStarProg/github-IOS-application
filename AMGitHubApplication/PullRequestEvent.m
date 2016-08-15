//
//  PullRequestEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 15.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "PullRequestEvent.h"

@implementation PullRequestEvent
-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"PullRequestEvent";
    }
    return self;
}


-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    PullRequestEvent * result=[[PullRequestEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ %@ pull request #%@ in %@",dict[@"actor"][@"login"],dict[@"payload"][@"action"],dict[@"payload"][@"number"],dict[@"repo"][@"name"]];

    result.descriptionStr=[NSString stringWithFormat:@"%@",dict[@"payload"][@"pull_request"][@"title"]];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}
@end
