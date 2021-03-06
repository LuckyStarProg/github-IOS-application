//
//  PushEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "PushEvent.h"
#import "AMDataManager.h"

@implementation PushEvent

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"PushEvent";
    }
    return self;
}

-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    PushEvent * result=[[PushEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ pushed to %@ at %@",dict[@"actor"][@"login"],dict[@"payload"][@"ref"],dict[@"repo"][@"name"]];
    result.descriptionStr=[NSString stringWithFormat:@"%@",[dict[@"payload"][@"commits"] lastObject][@"message"]];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}

@end
