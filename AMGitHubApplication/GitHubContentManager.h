//
//  GitHubContentManager.h
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitHubContentManager : NSObject
+(GitHubContentManager *)sharedManager;
-(void)startManaging;
@end
