//
//  ReleaseEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 15.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "ReleaseEvent.h"

@implementation ReleaseEvent
-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"ReleaseEvent";
    }
    return self;
}


-(ReleaseEvent *)eventFromDictionary:(NSDictionary *)dict
{
    ReleaseEvent * result=[[ReleaseEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ %@ release %@",dict[@"actor"][@"login"],dict[@"payload"][@"action"],dict[@"payload"][@"release"][@"name"]];
    result.descriptionStr=@"";
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}
@end
