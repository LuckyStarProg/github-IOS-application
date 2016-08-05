//
//  CreateEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 05.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "CreateEvent.h"
#import "AMDataManager.h"

@implementation CreateEvent

+(CreateEvent *)eventFromDictionary:(NSDictionary *)dict
{
    CreateEvent * result=(CreateEvent *)[Event eventFromDictionary:dict];
    result.ref=result.payload[@"ref"];
    result.ref_type=result.payload[@"ref_type"];
    result.descriptionStr=result.payload[@"description"];
    return result;
}

-(void)fillCell:(EventCell *)cell
{
    AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    cell.eventHeader.text=[NSString stringWithFormat:@"%@ created %@ %@ in %@",self.actor[@"login"],self.ref_type,self.ref,self.repo[@"name"]];
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
