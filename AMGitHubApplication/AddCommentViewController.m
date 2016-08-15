//
//  AddCommentViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 15.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "AddCommentViewController.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView removeFromSuperview];
    
    UIBarButtonItem * doneItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDudTap)];
    doneItem.tintColor=[UIColor whiteColor];
    UIBarButtonItem * cancelItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDidTap)];
    cancelItem.tintColor=[UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem=doneItem;
    self.navigationItem.rightBarButtonItem=cancelItem;
    self.content=[[UITextView alloc] initWithFrame:self.view.bounds];
    self.content.font=[UIFont systemFontOfSize:12];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [self.view addSubview:self.content];
}

-(void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.content.bounds=CGRectMake(0, 0, self.view.bounds.size.width, keyboardFrameBeginRect.origin.y);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)cancelDidTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneDudTap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EndAddComment" object:self.content.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
