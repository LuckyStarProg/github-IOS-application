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
    event.type=[NSString stringWithFormat:@"%@",dict[@"type"]];
    event.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    self.descriptionStr=@"None";
    self.headerInfo=@"Unkown event!";
    event.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    event.avatarPath=nil;
    return event;
}

-(void)fillCell:(EventCell *)cell
{
    cell.eventHeader.text=self.headerInfo;
    if(!self.avatarPath)
    {
        AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
        [manager loadDataWithURLString:self.avatarUrl andSuccess:^(NSString * path)
         {
             self.avatarPath=path;
             dispatch_async(dispatch_get_main_queue(), ^
             {
                 cell.avatarView.image=[UIImage imageWithContentsOfFile:path];
                 [cell setNeedsLayout];
             });
         } orFailure:^(NSString * message)
         {
         NSLog(@"%@",message);
         }];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            cell.avatarView.image=[UIImage imageWithContentsOfFile:self.avatarPath];
            [cell setNeedsLayout];
        });
    }
    cell.date.text=self.date;
    cell.descriptionLabel.text=self.descriptionStr;
}
@end
