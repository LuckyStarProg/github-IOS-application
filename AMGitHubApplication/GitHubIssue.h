//
//  GitHubIssue.h
//  AMGitHubApplication
//
//  Created by Амин on 11.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubUser.h"
#import "GitHubRepository.h"

@interface GitHubIssue : NSObject
@property NSString * state;
@property NSString * createDate;
@property NSString * title;
@property NSString * issueNumber;
@property NSUInteger labelsCount;
@property GitHubUser * user;
@property NSArray* events;
@property NSString* eventsUrl;
@property GitHubRepository * repo;

+(GitHubIssue *)issueFromDictionary:(NSDictionary *)dictionary;
@end
