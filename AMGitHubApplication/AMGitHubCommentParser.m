//
//  AMGitHubCommentPurser.m
//  AMGitHubApplication
//
//  Created by Амин on 13.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "AMGitHubCommentParser.h"
#import "AMDataManager.h"

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
    __block NSString * startString=string;
    NSUInteger startindex=0;
    self.results=[NSMutableDictionary dictionary];
    for(NSUInteger i=0;i<startString.length;++i)
    {
        for(NSUInteger j=0;j<self.tokens.count;++j)
        {
            self.tokens[j].inputValue=[startString substringToIndex:i];
            if(self.tokens[j].isMatch)
            {
                NSRange secondRange=self.tokens[j].matchRange;
                NSString * second=[startString substringWithRange:secondRange];
                
                NSRange firstRange;
                firstRange.location=startindex;
                firstRange.length=secondRange.location;
                NSString * first=[startString substringWithRange:firstRange];
                if([first stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length!=0)
                {
                    [self.results setObject:first forKey:@"text"];
                }
                [self.results setObject:self.tokens[j].value forKey:[NSString stringWithFormat:@"%@",self.tokens[j]]];
                    startString=[startString stringByReplacingOccurrencesOfString:first withString:@""];
                    startString=[startString stringByReplacingOccurrencesOfString:second withString:@""];
                i-=firstRange.length;
                i-=secondRange.length-1;
                NSLog(@"%@",second);
            }
        }
        
        if(i+1==startString.length)
        {
            [self.results setObject:startString forKey:@"text"];
        }
    }
        NSLog(@"%@",self.results);
//        for(NSUInteger i=0;i<self.results.count;++i)
//        {
//            if([self.results.allValues[i] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length==0)
//            {
//                [self.results Foro];
//                --i;
//            }
//        }
        return self.results;
}
@end
