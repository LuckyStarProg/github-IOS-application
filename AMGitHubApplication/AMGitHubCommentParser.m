//
//  AMGitHubCommentPurser.m
//  AMGitHubApplication
//
//  Created by Амин on 13.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "AMGitHubCommentParser.h"

@interface AMGitHubCommentParser ()
@property (nonatomic)NSArray<ParserToken *> * tokens;
@property (nonatomic)NSMutableDictionary * results;
@end
@implementation AMGitHubCommentParser
-(instancetype)initWithTokens:(NSArray<ParserToken *> *)tokens
{
    if(self=[super init])
    {
        self.tokens=tokens;
    }
    return self;
}

-(NSDictionary *)parseString:(NSString *)string
{
    __block NSString * startString=[NSString stringWithFormat:@"%@",string];
    NSUInteger startindex=0;
    self.results=[NSMutableDictionary dictionary];
    NSUInteger textCount=0;

    for(NSUInteger i=0;i<startString.length;++i)
    {
        for(NSUInteger j=0;j<self.tokens.count;++j)
        {
            self.tokens[j].inputValue=[startString substringToIndex:i+1];
            if(self.tokens[j].isMatch)
            {
                NSRange secondRange=self.tokens[j].matchRange;
                
                NSRange firstRange;
                firstRange.location=startindex;
                firstRange.length=secondRange.location;
                NSString * first=[startString substringWithRange:firstRange];
                if([first stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length!=0)
                {
                    [self.results setObject:first forKey:[NSString stringWithFormat:@"text%ld",textCount++]];
                }
                [self.results setObject:self.tokens[j].value forKey:[NSString stringWithFormat:@"%@",self.tokens[j]]];
                    startString=[startString stringByReplacingCharactersInRange:firstRange withString:@""];
                secondRange.location-=firstRange.length;
                    startString=[startString stringByReplacingCharactersInRange:secondRange withString:@""];
                i-=firstRange.length;
                i-=secondRange.length-1;

            }
        }
        
    }
    if(startString.length)
    {
        [self.results setObject:startString forKey:[NSString stringWithFormat:@"text%ld",textCount++]];
    }

    return self.results;
}
@end
