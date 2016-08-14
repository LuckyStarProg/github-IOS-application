//
//  imageToken.m
//  AMGitHubApplication
//
//  Created by Амин on 13.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "imageToken.h"
@interface imageToken()
@property (nonatomic)NSRegularExpression * regex;
@property (nonatomic)NSUInteger imageCount;
@end

@implementation imageToken

-(NSRange)matchRange
{
    NSRange range=[self.regex firstMatchInString:self.inputValue options:0 range:NSMakeRange(0, self.inputValue.length)].range;
    self.patternValue=[self.inputValue substringWithRange:range];
    NSRange valueRange=[self.patternValue rangeOfString:@"src=\""];
    NSString * str=[self.patternValue substringFromIndex:valueRange.location+valueRange.length];
    NSRange valueRange2=[str rangeOfString:@"\""];
    self.value=[str substringToIndex:valueRange2.location];
    //self.value=[self.inputValue substringWithRange:NSMakeRange(range.location+3, range.length-3)];
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
        self.regex=[NSRegularExpression regularExpressionWithPattern:@"<img(.+)>" options:NSRegularExpressionDotMatchesLineSeparators error:&regexError];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"imageRef%ld",self.imageCount++];
}
@end
