//
//  Event.h
//  AMGitHubApplication
//
//  Created by Амин on 05.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventCell.h"

@protocol CellFill
@required
-(void)fillCell:(EventCell *)cell;
@end

@interface Event : NSObject <CellFill>

-(Event *)eventFromDictionary:(NSDictionary *)dict;
-(void)fillCell:(EventCell *)cell;

@property (nonatomic)NSString * ID;
@property (nonatomic)NSString * type;
@property (nonatomic)NSDictionary * actor;
@property (nonatomic)NSDictionary * repo;
@property (nonatomic)NSDictionary * payload;
@property (nonatomic)NSString * date;
@end
