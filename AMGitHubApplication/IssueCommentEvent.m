//
//  IssueCommentEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssueCommentEvent.h"
#import "AMDataManager.h"
@implementation IssueCommentEvent

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"IssueCommentEvent";
    }
    return self;
}

-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    IssueCommentEvent * result=[[IssueCommentEvent alloc] init];
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
    cell.eventHeader.text=[NSString stringWithFormat:@"%@ commented on issue #%@ in %@",self.actor[@"login"],self.payload[@"issue"][@"number"],self.repo[@"name"]];
    [manager loadDataWithURLString:self.actor[@"avatar_url"] andSuccess:^(NSString * path)
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
    cell.descriptionLabel.text=self.payload[@"comment.body"];
}
@end
