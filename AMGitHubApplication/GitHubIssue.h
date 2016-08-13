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
@property (nonatomic) NSString * state;
@property (nonatomic) NSString * createDate;
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * issueNumber;
@property (nonatomic) NSUInteger labelsCount;
@property (nonatomic) GitHubUser * user;
@property (nonatomic) NSArray* events;
@property (nonatomic) NSString * comments;
@property (nonatomic) NSString* eventsUrl;
@property (nonatomic) GitHubRepository * repo;
@property (nonatomic) NSString * body;
@property (nonatomic) GitHubUser * assigneeUser;

+(GitHubIssue *)issueFromDictionary:(NSDictionary *)dictionary;
@end
