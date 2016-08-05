//
//  Event.m
//  AMGitHubApplication
//
//  Created by Амин on 05.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "Event.h"

@implementation Event

+(Event *)eventFromDictionary:(NSDictionary *)dict
{
    Event * result=[[Event alloc] init];
    
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.type=[NSString stringWithFormat:@"%@",dict[@"type"]];
    result.actor=dict[@"actor"];
    result.repo=dict[@"repo"];
    result.payload=dict[@"payload"];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"updated_at"]] substringToIndex:10];
    
    return result;
}

-(void)fillCell:(EventCell *)cell
{
    
}
@end
