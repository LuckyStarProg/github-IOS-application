//
//  AMGitHubCommentPurser.h
//  AMGitHubApplication
//
//  Created by Амин on 13.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserToken.h"
#import "defaultTextToken.h"
#import "scrollableToken.h"
#import "imageToken.h"
#import "AMDataManager.h"

@interface AMGitHubCommentParser : NSObject

-(instancetype)initWithTokens:(NSArray<ParserToken *> *)tokens;
-(NSDictionary *)parseString:(NSString *)string;
@end
