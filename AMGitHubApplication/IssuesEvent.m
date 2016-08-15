//
//  IssuesEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssuesEvent.h"
#import "AMDataManager.h"
@implementation IssuesEvent

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"IssuesEvent";
    }
    return self;
}

-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    IssuesEvent * result=[[IssuesEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ %@ issue #%@ in %@",dict[@"actor"][@"login"],dict[@"payload"][@"action"], dict[@"payload"][@"issue"][@"number"],dict[@"repo"][@"name"]];
    result.descriptionStr=[NSString stringWithFormat:@"%@",dict[@"payload"][@"issue"][@"title"]];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}

@end
