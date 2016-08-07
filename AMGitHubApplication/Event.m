//
//  Event.m
//  AMGitHubApplication
//
//  Created by Амин on 05.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "Event.h"
#import "AMDataManager.h"
@implementation Event

-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    Event * event=[[Event alloc] init];
        event.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
        event.actor=dict[@"actor"];
        event.repo=dict[@"repo"];
        event.payload=dict[@"payload"];
        event.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    return event;
}

-(void)fillCell:(EventCell *)cell
{
    AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    cell.eventHeader.text=[NSString stringWithFormat:@"Unknown event"];
    [manager loadDataWithURLString:self.actor[@"avatar_url"] andSuccess:^(NSString * path)
     {
         cell.avatarView.image=[UIImage imageWithContentsOfFile:path];
     } orFailure:^(NSString * message)
     {
         NSLog(@"%@",message);
     }];
    cell.date.text=self.date;
    cell.descriptionLabel.text=@"";
}

@end
