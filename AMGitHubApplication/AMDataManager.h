//
//  DataManager.h
//  AMGitHubApplication
//
//  Created by Амин on 31.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AMDataManageMod)
{
    AMDataManageStorageMod=1,
    AMDataManageDownloadOnlyMod,
    AMDataManageDefaultMod
};

@interface AMDataManager : NSObject

-(instancetype)initWithMod:(AMDataManageMod)mod;

-(void)loadDataWithURLString:(NSString *)reference andSuccess:(void (^)(NSString *))reloadData orFailure:(void (^)(NSString *))Error;
-(void)cancel;
@end
