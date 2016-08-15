//
//  MemberEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "MemberEvent.h"
#import "AMDataManager.h"

@implementation MemberEvent

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"MemberEvent";
    }
    return self;
}


-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    MemberEvent * result=[[MemberEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ add as colaborator to %@",dict[@"actor"][@"login"],dict[@"repo"][@"name"]];
    result.descriptionStr=@"";
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}

@end
