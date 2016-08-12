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
    result.headerInfo=[NSString stringWithFormat:@"%@ commented on issue #%@ in %@",dict[@"actor"][@"login"],dict[@"payload"][@"issue"][@"number"],dict[@"repo"][@"name"]];
    result.descriptionStr=dict[@"payload"][@"comment"][@"body"];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}

//-(void)fillCell:(EventCell *)cell
//{
//    cell.eventHeader.text=[NSString stringWithFormat:@"%@ commented on issue #%@ in %@",self.actor[@"login"],self.payload[@"issue"][@"number"],self.repo[@"name"]];
//    if(!self.avatarPath && ![[NSFileManager defaultManager] fileExistsAtPath:cell.avatarPath])
//    {
//        AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
//        [manager loadDataWithURLString:self.actor[@"avatar_url"] andSuccess:^(NSString * path)
//         {
//             self.avatarPath=path;
//             cell.avatarView.image=[UIImage imageWithContentsOfFile:path];
//             [cell setNeedsLayout];
//         } orFailure:^(NSString * message)
//         {
//             NSLog(@"%@",message);
//         }];
//    }
//    else
//    {
//        cell.avatarView.image=[UIImage imageWithContentsOfFile:self.avatarPath];
//        [cell setNeedsLayout];
//    }
//    cell.date.text=self.date;
//    cell.descriptionLabel.text=self.payload[@"comment.body"];
//}
@end
