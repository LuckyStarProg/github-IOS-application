//
//  IssueCommentEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssueCommentEvent.h"
#import "AMDataManager.h"
@implementation IssueCommentEvent

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"IssueCommentEvent";
    }
    return self;
}

-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    IssueCommentEvent * result=[[IssueCommentEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ commented on issue #%@ in %@",dict[@"actor"][@"login"],dict[@"payload"][@"issue"][@"number"],dict[@"repo"][@"name"]];
    result.descriptionStr=[NSString stringWithFormat:@"%@",dict[@"payload"][@"comment"][@"body"]];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}

@end
