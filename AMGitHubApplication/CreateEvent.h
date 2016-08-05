//
//  CreateEvent.h
//  AMGitHubApplication
//
//  Created by Амин on 05.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "Event.h"

@interface CreateEvent : Event

@property (nonatomic)NSString * ref;
@property (nonatomic)NSString * ref_type;
@property (nonatomic)NSString * descriptionStr;

-(void)fillCell:(EventCell *)cell;
@end
