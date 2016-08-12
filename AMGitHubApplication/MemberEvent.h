//
//  MemberEvent.h
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "Event.h"

@interface MemberEvent : Event
-(instancetype)init;
-(Event *)eventFromDictionary:(NSDictionary *)dict;
//-(void)fillCell:(EventCell *)cell;
@end
