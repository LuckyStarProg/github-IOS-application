//
//  detailsViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 25.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "detailsViewController.h"
#import "AMSideBarViewController.h"

@interface detailsViewController()<UITableViewDataSource, UITableViewDelegate>
@end

@implementation detailsViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifaer=@"Reusable sell default";
    UITableViewCell * cell;
    cell=[tableView dequeueReusableCellWithIdentifier:identifaer];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifaer];
    }
    cell.textLabel.text=@"babah";
    
    return cell;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.table=[[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.table];
    
    self.table.delegate=self;
    self.table.dataSource=self;
}
- (IBAction)menuDidTap:(UIBarButtonItem *)sender
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
    [sider side];
    
}
@end
