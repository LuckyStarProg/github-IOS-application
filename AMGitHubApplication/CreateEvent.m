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

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"CreateEvent";
    }
    return self;
}

-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    CreateEvent * result=[[CreateEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ created %@ %@",dict[@"actor"][@"login"],dict[@"payload"][@"ref_type"],dict[@"repo"][@"name"]];
    result.descriptionStr=dict[@"payload"][@"description"];
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}

//-(void)fillCell:(EventCell *)cell
//{
//    NSLog(@"%@",self.payload);
//    cell.eventHeader.text=[NSString stringWithFormat:@"%@ created %@ %@",self.actor[@"login"],self.payload[@"ref_type"],self.repo[@"name"]];
//    cell.date.text=self.date;
//    cell.descriptionLabel.text=self.payload[@"description"];
//    
//    if(!self.avatarPath)
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
//}
@end
