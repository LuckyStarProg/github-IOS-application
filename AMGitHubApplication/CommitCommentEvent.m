//
//  CommitCommentEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 15.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "CommitCommentEvent.h"

@implementation CommitCommentEvent

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"CommitCommentEvent";
    }
    return self;
}


-(CommitCommentEvent *)eventFromDictionary:(NSDictionary *)dict
{

    CommitCommentEvent * result=[[CommitCommentEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ commented on commit in %@",dict[@"actor"][@"login"],dict[@"repo"][@"name"]];
    NSLog(@"%@",[dict[@"payload"][@"pull_request"] allKeys]);
    result.descriptionStr=[NSString stringWithFormat:@"%@",dict[@"payload"][@"comment"][@"body"]];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}
@end
