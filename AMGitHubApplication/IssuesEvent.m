//
//  IssuesEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssuesEvent.h"
#import "AMDataManager.h"
@implementation IssuesEvent
+(IssuesEvent *)eventFromDictionary:(NSDictionary *)dict
{
    IssuesEvent * result=(IssuesEvent *)[Event eventFromDictionary:dict];
    //result.ref=result.payload[@"ref"];
    //result.ref_type=result.payload[@"ref_type"];
    //result.descriptionStr=result.payload[@"description"];
    return result;
}

-(void)fillCell:(EventCell *)cell
{
    AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    cell.eventHeader.text=[NSString stringWithFormat:@"%@ %@ issue %ld in %@",self.actor[@"login"],self.payload[@"action"],(NSUInteger)self.payload[@"issue.number"],self.payload[@"name"]];
    [manager loadDataWithURLString:self.actor[@"avatar_url"] andSuccess:^(NSString * path)
     {
         cell.avatarView.image=[UIImage imageWithContentsOfFile:path];
     } orFailure:^(NSString * message)
     {
         NSLog(@"%@",message);
     }];
    cell.date.text=self.date;
    cell.descriptionLabel.text=self.payload[@"issue.title"];
}
@end
