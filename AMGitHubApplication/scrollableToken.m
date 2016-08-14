//
//  scrollableToken.m
//  AMGitHubApplication
//
//  Created by Амин on 13.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "scrollableToken.h"

@interface scrollableToken()
@property (nonatomic)NSRegularExpression * regex;
@property (nonatomic)NSUInteger scrollCount;
@end

@implementation scrollableToken

-(NSRange)matchRange
{
    NSRange range=[self.regex firstMatchInString:self.inputValue options:0 range:NSMakeRange(0, self.inputValue.length)].range;
    self.patternValue=[self.inputValue substringWithRange:range];
    self.value=[self.patternValue stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"`"]];
    return range;
}

-(BOOL)isMatch
{

    NSArray *matches=[self.regex matchesInString:self.inputValue options:0 range:NSMakeRange(0, self.inputValue.length)];
    
    NSLog(@"%@",self.inputValue);
    return matches.count>0;
}

-(instancetype)init
{
    if(self=[super init])
    {
        NSError * regexError=nil;
        self.regex=[NSRegularExpression regularExpressionWithPattern:@"```(.+)```" options:NSRegularExpressionDotMatchesLineSeparators error:&regexError];
        if(regexError)
        {
            NSLog(@"%@",regexError.localizedDescription);
        }
    }
    return self;
}

-(NSString *)valueByTrimmingPattern
{
    return [self.value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"`"]];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"scroll%ld",self.scrollCount];
}
@end
