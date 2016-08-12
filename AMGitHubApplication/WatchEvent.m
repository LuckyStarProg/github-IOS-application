//
//  WatchEvent.m
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "WatchEvent.h"
#import "AMDataManager.h"

@implementation WatchEvent

-(instancetype)init
{
    if(self=[super init])
    {
        self.type=@"WatchEvent";
    }
    return self;
}

-(Event *)eventFromDictionary:(NSDictionary *)dict
{
    WatchEvent * result=[[WatchEvent alloc] init];
    result.ID=[NSString stringWithFormat:@"%@",dict[@"id"]];
    result.headerInfo=[NSString stringWithFormat:@"%@ %@ %@",dict[@"actor"][@"login"],dict[@"payload"][@"action"],dict[@"repo"][@"name"]];
    result.descriptionStr=@"";
    result.date=[[NSString stringWithFormat:@"%@",dict[@"created_at"]] substringToIndex:10];
    result.avatarPath=nil;
    result.avatarUrl=dict[@"actor"][@"avatar_url"];
    return result;
}

//-(void)fillCell:(EventCell *)cell
//{
//    cell.eventHeader.text=[NSString stringWithFormat:@"%@ %@ %@",self.actor[@"login"],self.payload[@"action"],self.repo[@"name"]];
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
//    cell.descriptionLabel.text=@"";
//}
@end
