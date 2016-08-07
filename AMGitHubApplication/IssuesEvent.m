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

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"IssuesEvent";
    }
    return self;
}

-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    IssuesEvent * result=[[IssuesEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.actor=dict[@"actor"];
    result.repo=dict[@"repo"];
    result.payload=dict[@"payload"];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    return result;
}

-(void)fillCell:(EventCell *)cell
{
    AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    NSString * str2=[NSString stringWithFormat:@"%@ %@ issue #%@ in %@",self.actor[@"login"],self.payload[@"action"], self.payload[@"issue"][@"number"],self.repo[@"name"]];
    cell.eventHeader.text=str2;
    NSString * str=self.actor[@"avatar_url"];
    [manager loadDataWithURLString:str andSuccess:^(NSString * path)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            cell.avatarView.image=[UIImage imageWithContentsOfFile:path];
                            [cell setNeedsLayout];
                        });
     } orFailure:^(NSString * message)
     {
         NSLog(@"%@",message);
     }];
    cell.date.text=self.date;
    cell.descriptionLabel.text=self.payload[@"issue.title"];
}
@end
