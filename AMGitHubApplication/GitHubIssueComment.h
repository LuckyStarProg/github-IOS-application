//
//  GitHubIssueComment.h
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubUser.h"

@interface GitHubIssueComment : NSObject

@property (nonatomic)NSString * body;
@property (nonatomic)GitHubUser * user;
@property (nonatomic)NSString * createdDate;
+(GitHubIssueComment *)commentByDictionary:(NSDictionary *)dictionary;
@end
