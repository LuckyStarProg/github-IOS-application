//
//  EventController.h
//  AMGitHubApplication
//
//  Created by Амин on 06.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventsHeader.h"

@interface EventController : NSObject

-(instancetype)init;
-(Event *)eventFromDictionary:(NSDictionary *)dictionary;
@end
