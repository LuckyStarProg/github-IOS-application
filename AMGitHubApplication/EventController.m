//
//  EventController.m
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "EventController.h"

@interface EventController ()
@property NSArray<Event *> * events;
@end
@implementation EventController
-(instancetype)init
{
    if(self=[super init])
    {
        self.events=[NSArray arrayWithObjects:
                     [[CreateEvent alloc] init],
                     [[PushEvent alloc] init],
                     [[IssueCommentEvent alloc] init],
                     [[IssuesEvent alloc] init],
                     [[ForkEvent alloc] init],
                     [[WatchEvent alloc] init],
                     [[MemberEvent alloc] init],
                     [[PullRequestEvent alloc] init],
                     [[DeleteEvent alloc] init],
                     [[CommitCommentEvent alloc] init],
                     [[PullRequestReviewCommentEvent alloc] init],
                     [[ReleaseEvent alloc] init],nil];
    }
    return self;
}

-(Event *)eventFromDictionary:(NSDictionary *)dictionary
{
    for(Event * event in self.events)
    {
        NSString * str=dictionary[@"type"];
        if([event.type isEqualToString:str])
        {
            return [event eventFromDictionary:dictionary];
        }
    }
    Event * event=[[Event alloc] init];
    return [event eventFromDictionary:dictionary];
}
@end
