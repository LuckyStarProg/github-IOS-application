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

+(IssueCommentEvent *)eventFromDictionary:(NSDictionary *)dict
{
    IssueCommentEvent * result=(IssueCommentEvent *)[Event eventFromDictionary:dict];
    //result.ref=result.payload[@"ref"];
    //result.ref_type=result.payload[@"ref_type"];
    //result.descriptionStr=result.payload[@"description"];
    return result;
}

-(void)fillCell:(EventCell *)cell
{
    AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    cell.eventHeader.text=[NSString stringWithFormat:@"%@ commented on issue %ld in %@",self.actor[@"login"],(NSUInteger)self.payload[@"issue.numder"],self.repo[@"name"]];
    [manager loadDataWithURLString:self.actor[@"avatar_url"] andSuccess:^(NSString * path)
     {
         cell.avatarView.image=[UIImage imageWithContentsOfFile:path];
     } orFailure:^(NSString * message)
     {
         NSLog(@"%@",message);
     }];
    cell.date.text=self.date;
    cell.descriptionLabel.text=self.payload[@"comment.body"];
}
@end
