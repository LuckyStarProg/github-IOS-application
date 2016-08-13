//
//  ParserToken.h
//  AMGitHubApplication
//
//  Created by Амин on 13.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserToken : NSObject

@property (nonatomic)NSString * inputValue;
@property (nonatomic)NSString * patternValue;
@property (nonatomic)BOOL isMatch;
@property (nonatomic)NSRange matchRange;
@property (nonatomic)NSString * value;
-(NSString *)valueByTrimmingPattern;
@end
