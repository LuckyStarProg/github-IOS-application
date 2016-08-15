//
//  PullRequestReviewCommentEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 15.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "PullRequestReviewCommentEvent.h"

@implementation PullRequestReviewCommentEvent

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"PullRequestReviewCommentEvent";
    }
    return self;
}


-(PullRequestReviewCommentEvent *)eventFromDictionary:(NSDictionary *)dict
{
    PullRequestReviewCommentEvent * result=[[PullRequestReviewCommentEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ commented on pull reques in %@",dict[@"actor"][@"login"],dict[@"repo"][@"name"]];
    result.descriptionStr=[NSString stringWithFormat:@"%@",dict[@"payload"][@"comment"][@"body"]];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}
@end
