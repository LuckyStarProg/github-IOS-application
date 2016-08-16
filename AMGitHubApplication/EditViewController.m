//
//  EditViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 11.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "EditViewController.h"
#import "AuthorizedUser.h"

@interface EditViewController ()
@property (nonatomic)UITextView * textView;
@property (nonatomic)NSString * key;
@end

@implementation EditViewController
-(instancetype)initWithString:(NSMutableString *)key;
{
    if(self=[super init])
    {
        self.key=key;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView removeFromSuperview];
    UIBarButtonItem * doneItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDudTap)];
    doneItem.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=doneItem;
    self.textView=[[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.text=[[AuthorizedUser sharedUser] valueForKey:self.key];
    [self.view addSubview:self.textView];

}

-(void)doneDudTap
{
    [[AuthorizedUser sharedUser] setValue:[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] forKey:self.key];
    [[AuthorizedUser sharedUser] update];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
