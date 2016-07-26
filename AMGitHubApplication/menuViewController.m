//
//  menuViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "menuViewController.h"

@interface menuViewController ()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation menuViewController
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
    cell.backgroundColor=[UIColor colorWithRed:0.10 green:0.30 blue:0.37 alpha:1.0];
    cell.textLabel.text=@"allah";
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.view.backgroundColor=[UIColor colorWithRed:0.10 green:0.30 blue:0.37 alpha:1.0];
    self.table.backgroundColor=[UIColor colorWithRed:0.10 green:0.30 blue:0.37 alpha:1.0];
    self.table.tintColor=[UIColor colorWithRed:42 green:54 blue:67 alpha:1.0];
}
@end
