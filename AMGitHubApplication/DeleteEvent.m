//
//  DeleteEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 15.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "DeleteEvent.h"

@implementation DeleteEvent

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"DeleteEvent";
    }
    return self;
}


-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    DeleteEvent * result=[[DeleteEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ deleted %@ %@ in %@",dict[@"actor"][@"login"],dict[@"payload"][@"ref_type"], dict[@"payload"][@"ref"], dict[@"repo"][@"name"]];
    result.descriptionStr=@"";
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}
@end
