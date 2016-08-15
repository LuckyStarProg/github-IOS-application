//
//  ForkEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "ForkEvent.h"
#import "AMDataManager.h"

@implementation ForkEvent
-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"ForkEvent";
    }
    return self;
}

-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    ForkEvent * result=[[ForkEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ forked %@ to %@",dict[@"actor"][@"login"],dict[@"repo"][@"name"],dict[@"payload"][@"forkee"][@"full_name"]];
    result.descriptionStr=@"";
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}

@end
