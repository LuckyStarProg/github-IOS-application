//
//  WebViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 27.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest * reques=[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/login"]];
    [self.webView loadRequest:reques];
}
@end
