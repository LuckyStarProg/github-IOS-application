//
//  defaultTextToken.m
//  AMGitHubApplication
//
//  Created by Амин on 13.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "defaultTextToken.h"
@interface defaultTextToken()
@end

@implementation defaultTextToken

-(instancetype)initWithValue:(NSString *)value
{
    if(self=[super init])
    {
        self.value=value;
    }
    return self;
}

-(NSString *)valueByTrimmingPattern
{
    return [self.value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
}
@end
