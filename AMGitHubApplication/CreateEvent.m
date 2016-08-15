//
//  CreateEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 05.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "CreateEvent.h"
#import "AMDataManager.h"

@implementation CreateEvent

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"CreateEvent";
    }
    return self;
}

-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    CreateEvent * result=[[CreateEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ created %@ %@",dict[@"actor"][@"login"],dict[@"payload"][@"ref_type"],dict[@"repo"][@"name"]];
    result.descriptionStr=[NSString stringWithFormat:@"%@",dict[@"payload"][@"description"]];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}

@end
