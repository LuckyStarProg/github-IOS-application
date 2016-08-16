//
//  DataManager.m
//  AMGitHubApplication
//
//  Created by Амин on 31.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "AMDataManager.h"
@interface AMDataManager ()
@property (nonatomic)NSString * reference;
@property (nonatomic)AMDataManageMod mod;
@property (nonatomic)NSURLSessionDownloadTask * dataTask;
@property (nonatomic)NSString * storagePath;
@end

@implementation AMDataManager

-(instancetype)initWithMod:(AMDataManageMod)mod
{
    self=[super init];
    if(self)
    {
        self.mod=mod;
        NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        self.storagePath=[myPathList firstObject];

    }
    return self;
}


-(void)loadImageFromServerWithCompletion:(void (^)(NSString *))reloadData andFailure:(void (^)(NSString *))Error
{
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.reference]
                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        timeoutInterval:10];
    self.dataTask=[[NSURLSession sharedSession]
    downloadTaskWithRequest:request
    completionHandler:^
    (NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
     {
         
         if(!location)
         {
             Error(@"Error location is nil!");
             return;
         }
         
         NSString * pathToData=[self.storagePath stringByAppendingPathComponent:[NSUUID UUID].UUIDString];
         NSError * fileError;
         [[NSFileManager defaultManager] copyItemAtPath:location.path
                                                 toPath:pathToData
                                                  error:&fileError];
         if(fileError)
         {
             NSLog(@"Error copy file!");
             return;
         }
         

            reloadData?reloadData(pathToData):NSLog(@"Reload block is nil!");
     }];
    [self.dataTask resume];
}

-(void)cancel
{
    [self.dataTask cancel];
}

-(void)loadDataWithURLString:(NSString *)reference andSuccess:(void (^)(NSString *))reloadData orFailure:(void (^)(NSString *))Error;
{
    self.reference=reference;
    if(self.mod==AMDataManageDefaultMod)
    {
        [self loadImageFromServerWithCompletion:reloadData andFailure:Error];
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.storagePath=[paths firstObject];
        [self loadImageFromServerWithCompletion:reloadData andFailure:Error];
    }
}
@end
