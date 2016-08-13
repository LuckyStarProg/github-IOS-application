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
    return @"scroll";
}
@end
