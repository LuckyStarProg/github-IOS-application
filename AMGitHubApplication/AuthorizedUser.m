//
//  AuthorizedUser.m
//  AMGitHubApplication
//
//  Created by Амин on 04.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "AuthorizedUser.h"
@implementation AuthorizedUser
static AuthorizedUser * authorizedUserInstance;

+(AuthorizedUser *)sharedUser
{
    return authorizedUserInstance;
}

+(void)loginWithCode:(NSString *)code andCompletion:(void (^)(void))comlation
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^
    {
        
        if(!authorizedUserInstance && [AuthorizedUser isExist])
        {
            [AuthorizedUser readUser];
        }
        
//        if(!authorizedUserInstance)
//        {
//            localToken=[[GitHubApiController sharedController] tokenURLFromCode:code].absoluteString;
//            [self writeTokenToFile];
//        }
    
        
            NSString* token=[[GitHubApiController sharedController] tokenFromCode:code];
            authorizedUserInstance=[[AuthorizedUser alloc] init];
            [AuthorizedUser setUser:[[GitHubApiController sharedController] userFromToken:token]];
            if(authorizedUserInstance)
            {
                authorizedUserInstance.accessToken=token;
                [[AuthorizedUser sharedUser]save];
                //[AuthorizedUser saveUser];
            }
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            comlation();
        });
    });
}

+(void)setUser:(GitHubUser *)user
{
    authorizedUserInstance.ID=user.ID;
    authorizedUserInstance.login=user.login;
    authorizedUserInstance.apiRef=user.apiRef;
    authorizedUserInstance.name=user.name;
    authorizedUserInstance.avatarRef=user.avatarRef;
    authorizedUserInstance.reposRef=user.reposRef;
    authorizedUserInstance.followers_count=user.followers_count;
    authorizedUserInstance.following_count=user.following_count;
    authorizedUserInstance.location=user.location;
    authorizedUserInstance.bio=user.bio;
    authorizedUserInstance.email=user.email;
    authorizedUserInstance.company=user.company;
    authorizedUserInstance.blog=user.blog;
}
+(void) writeTokenToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"token.txt"];
    [authorizedUserInstance.accessToken writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString*) readTokenFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"token.txt"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

-(void)save
{
    NSThread * saveThread=[[NSThread alloc] initWithTarget:self selector:@selector(saveUser) object:nil];
    saveThread.threadPriority=0.3;
    [saveThread start];
}

-(void)saveUser
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"AuthorizedUser.dat"];
    AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    [manager loadDataWithURLString:authorizedUserInstance.avatarRef andSuccess:^(NSString * avatar_path)
    {
        NSDictionary * userDict =[NSDictionary dictionaryWithObjectsAndKeys:
                                  authorizedUserInstance.login , @"login",
                                  authorizedUserInstance.accessToken , @"token", nil];
        
        NSError * jsonError=nil;
        NSOutputStream * stream=[NSOutputStream outputStreamToFileAtPath:path append:NO];
        [stream open];
        [NSJSONSerialization writeJSONObject:userDict toStream:stream options:0 error:&jsonError];
        [stream close];
        
        if(jsonError)
        {
            NSLog(@"%@",jsonError);
        }
    } orFailure:^(NSString * message)
    {
        NSLog(@"%@",message);
    }];

    //[self.accessToken writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(void)readUser
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"AuthorizedUser.dat"];
    if([AuthorizedUser isExist])
    {
        NSInputStream * stream=[NSInputStream inputStreamWithFileAtPath:path];
        NSError * jsonError=nil;
        [stream open];
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithStream:stream options:0 error:&jsonError];
        [stream close];
        if(jsonError)
        {
            NSLog(@"%@",jsonError.localizedDescription);
            return;
        }
        authorizedUserInstance=[[AuthorizedUser alloc] init];
        authorizedUserInstance.login=[NSString stringWithFormat:@"%@",dict[@"login"]];
        authorizedUserInstance.accessToken=[NSString stringWithFormat:@"%@",dict[@"token"]];
    }
}

+(BOOL)isExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:@"AuthorizedUser.dat"]];
}

-(void)update
{
    [[GitHubApiController sharedController] updateUserWithComplation:nil];
}

-(void)logOut
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError * deleteError=nil;
    [[NSFileManager defaultManager] removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:@"AuthorizedUser.dat"] error:&deleteError];
    if(deleteError)
    {
        NSLog(@"%@",deleteError.localizedDescription);
    }
    
}

@end
