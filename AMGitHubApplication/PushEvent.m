//
//  PushEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "PushEvent.h"
#import "AMDataManager.h"

@implementation PushEvent

+(PushEvent *)eventFromDictionary:(NSDictionary *)dict
{
    PushEvent * result=(PushEvent *)[Event eventFromDictionary:dict];
    //result.ref=result.payload[@"ref"];
    //result.ref_type=result.payload[@"ref_type"];
    //result.descriptionStr=result.payload[@"description"];
    return result;
}

-(void)fillCell:(EventCell *)cell
{
    AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    cell.eventHeader.text=[NSString stringWithFormat:@"%@ pushed to %@ at %@",self.actor[@"login"],self.payload[@"ref"],self.repo[@"name"]];
    [manager loadDataWithURLString:self.actor[@"avatar_url"] andSuccess:^(NSString * path)
     {
         cell.avatarView.image=[UIImage imageWithContentsOfFile:path];
     } orFailure:^(NSString * message)
     {
         NSLog(@"%@",message);
     }];
    cell.date.text=self.date;
    cell.descriptionLabel.text=self.payload[@"commits.message"];
}
@end
