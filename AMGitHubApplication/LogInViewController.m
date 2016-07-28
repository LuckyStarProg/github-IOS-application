//
//  LogInViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 27.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "LogInViewController.h"
#import "LogInTableViewCell.h"
#import "AMSideBarViewController.h"

@interface LogInViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)UITextField * loginField;
@property (nonatomic)UITextField * passwordField;
@end

@implementation LogInViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifaer=@"Reusable sell default";
    LogInTableViewCell * cell;
    cell=(LogInTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifaer];
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LogInTableViewCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSLog(@"%@",cell.contentView);
    NSLog(@"%@",[cell.contentView class]);
    switch (indexPath.row)
    {
        case 0:
            cell.textField.placeholder=@"Email";
            self.loginField=cell.textField;
            return cell;
        case 1:
            cell.textField.placeholder=@"Password";
            self.passwordField=cell.textField;
            return cell;
        default:
            return nil;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textChanged
{
    if(self.loginField.text.length>0 && self.passwordField.text.length>0)
    {
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginTable=[[UITableView alloc] initWithFrame:self.view.bounds];
    self.title=@"GitHub";
    UIBarButtonItem * enterItem=[[UIBarButtonItem alloc] initWithTitle:@"Enter" style:UIBarButtonItemStylePlain target:self action:@selector(enterDidTap)];
    enterItem.tintColor=[UIColor whiteColor];
    UIBarButtonItem * menuItem=[[UIBarButtonItem alloc] initWithTitle:@"Enter" style:UIBarButtonItemStylePlain target:self action:@selector(menuDidTap)];
    menuItem.tintColor=[UIColor whiteColor];
    menuItem.image=[UIImage imageNamed:@"menu_icon"];
    
    self.navigationItem.rightBarButtonItem=enterItem;
    self.navigationItem.leftBarButtonItem=menuItem;
    self.loginTable.backgroundColor=self.loginTable.separatorColor;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.10 green:0.30 blue:0.37 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem.enabled=NO;
    self.loginTable.delegate=self;
    self.loginTable.dataSource=self;
    [self.view addSubview:self.loginTable];
}
- (void)enterDidTap
{
    
}

- (void)menuDidTap
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
    [sider side];
}
@end
