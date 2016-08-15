//
//  IssueTableViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssueTableViewController.h"

//Warning: Кол-во костылей выше нормы! Будьте осторожны !
@interface IssueTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)UIView * footerView;
@property (nonatomic)IssueHeaderReusableView * header;
@property (nonatomic)UIView * bodyView;
@property (nonatomic)NSMutableArray<UIView*> * subViews;
@property (nonatomic)NSDictionary * tokens;
@end

@implementation IssueTableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count+3;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if([cell isKindOfClass:[IssuTableViewCell class]])
    {
        for(UIView * view in self.subViews)
        {
            [view removeFromSuperview];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row-2<self.comments.count)
    {
        UserProfileViewController * profile=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profile"];
        [[GitHubApiController sharedController] userFromLogin:self.comments[indexPath.row-2].user.login andComplation:^(GitHubUser * user)
         {
             user.avatarPath=self.comments[indexPath.row-2].user.avatarPath;
             profile.user=user;
         }];
        [self.navigationController pushViewController:profile animated:YES];
    }
    
    if(indexPath.row==self.comments.count+2)
    {
        AddCommentViewController * addCommentViewController=[[AddCommentViewController alloc] init];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:addCommentViewController] animated:YES completion:nil];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
    if(toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)
    {
        self.footerView.bounds=CGRectMake(0, self.tableView.bounds.size.width/2, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    else
    {
        self.footerView.frame=CGRectMake(0, self.tableView.bounds.size.height/2, self.tableView.bounds.size.width, [UIScreen mainScreen].bounds.size.height*2);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"reuseFirst";
    static NSString * commentIdentifier=@"commentIdentifier";
    static NSString * editIdentifier=@"edit";
    static NSString * separatorIdentifier=@"separator";
    
    if(indexPath.row==0)
    {
        IssuTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell=[[IssuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [self.subViews removeAllObjects];
        [self setBody:self.tokens and:self.bodyView and:self.subViews];
        NSUInteger i=self.subViews.count;

            for(NSInteger k=0;k<i;++k)
            {
                [cell addSubview:self.bodyView.subviews.firstObject];
            }
        cell.backgroundColor=[UIColor whiteColor];
            return cell;
    }
    else if(indexPath.row==1)
    {
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:separatorIdentifier];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:separatorIdentifier];
        }
        cell.textLabel.text=@"Comments:";
        cell.textLabel.font=[UIFont systemFontOfSize:12];
        cell.backgroundColor=[UIColor SeparatorColor];
        return cell;
    }
    else if(self.comments.count+2>indexPath.row)
    {
        CommentTableViewCell * customCell=[tableView dequeueReusableCellWithIdentifier:commentIdentifier];
        if(!customCell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
            customCell=[nib objectAtIndex:0];
        }
        customCell.nameLabel.text=self.comments[indexPath.row-2].user.login;
        customCell.dateLabel.text=self.comments[indexPath.row-2].createdDate;
        if(!self.comments[indexPath.row-2].user.avatarPath)
        {
            AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
            [manager loadDataWithURLString:self.comments[indexPath.row-2].user.avatarRef andSuccess:^(NSString * path)
            {
                self.comments[indexPath.row-2].user.avatarPath=path;
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    customCell.avatarView.image=[UIImage imageWithContentsOfFile:path];
                    [customCell setNeedsLayout];
                });
                
            } orFailure:^(NSString * message)
            {
                NSLog(@"%@",message);
            }];
        }
        else
        {
            customCell.avatarView.image=[UIImage imageWithContentsOfFile:self.comments[indexPath.row-2].user.avatarPath];
        }
        customCell.textView.text=self.comments[indexPath.row-2].body;
        customCell.textView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        
        return customCell;
    }
    else
    {
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:editIdentifier];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:editIdentifier];
        }
        cell.imageView.image=[UIImage imageNamed:@"brand"];
        cell.textLabel.text=@"Add comment";
        cell.textLabel.font=[UIFont systemFontOfSize:12];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=0;
    if(indexPath.row==0)
    {
        for(NSUInteger i=0;i<self.subViews.count;++i)
        {
            height+=self.subViews[i].bounds.size.height+8;
        }
    }
    else if(indexPath.row==1)
    {
        height=30;
    }
    else if(self.comments.count+2>indexPath.row)
    {
        if(self.comments.count>0)
        {
            height=[CommentTableViewCell heightForText:self.comments[indexPath.row-2].body]+50;
        }
    }
    else
    {
        height=30;
    }
        return height;
}

-(void)refreshDidSwipe
{
    [self.comments removeAllObjects];
    self.isAll=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addIssueComments" object:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.isAll=NO;
    UIView * upperView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    upperView.backgroundColor=[UIColor GitHubColor];
    [self.searchBar removeFromSuperview];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentIdentifier"];
    
    self.tableView.backgroundView=upperView;
    self.comments=[NSMutableArray array];
    self.footerView=[[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bounds.size.height/3, self.tableView.bounds.size.width, [UIScreen mainScreen].bounds.size.height*2)];
    self.footerView.backgroundColor=[UIColor SeparatorColor];
    [upperView addSubview:self.footerView];
    
    [self.refresh addTarget:self action:@selector(refreshDidSwipe) forControlEvents:UIControlEventValueChanged];
    self.refresh.tintColor=[UIColor whiteColor];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IssueHeaderReusableView"owner:self options:nil];
    self.header=[nib objectAtIndex:0];
    self.header.bounds=CGRectMake(0, 0, self.view.bounds.size.width, 280);
    self.header.frame=CGRectMake(0, 0, self.view.bounds.size.width, 280);
    self.tableView.tableHeaderView=self.header;
    self.tableView.tableFooterView=[UIView new];
    
    self.header.nameLabel.text=self.issue.title;
    self.header.desrLabel.text=self.issue.createDate;
    AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
    [manager loadDataWithURLString:self.issue.user.avatarRef andSuccess:^(NSString * path)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.header.avatarView.image=[UIImage imageWithContentsOfFile:path];
        });
    } orFailure:^(NSString *message)
    {
        NSLog(@"%@",message);
    }];;
    
    self.bodyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CGFLOAT_MAX)];
    self.subViews=[NSMutableArray array];
    [self parseDataForBody:self.issue.body];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addIssueComments" object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddAuthUserComment:) name:@"EndAddComment" object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)AddAuthUserComment:(NSNotification *)not
{
    NSString * comment=[not object];
    [[GitHubApiController sharedController]sendCommentToIssue:self.issue withBody:comment andSuccess:^(GitHubIssueComment *comment)
    {
        comment.user.avatarPath=[AuthorizedUser sharedUser].avatarPath;
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.comments addObject:comment];
                           [self.tableView reloadData];
                       });
    } orFailure:^(NSString *message)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [AlertController showAlertOnVC:self withMessage:message];
                       });
    }];
}

-(void)addComments:(NSArray<GitHubIssueComment *> *)comments
{
    NSMutableArray * indexPaths=[NSMutableArray array];
    for(NSUInteger i=self.comments.count;i<self.comments.count+comments.count;++i)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i+1 inSection:0]];
    }
    [self.comments addObjectsFromArray:comments];
    [self.tableView reloadData];
    [self.refresh endRefreshing];
}

-(NSUInteger)commentsCount
{
    return self.comments.count;
}

-(void)parseDataForBody:(NSString *)body
{
    AMGitHubCommentParser * parser=[[AMGitHubCommentParser alloc] initWithTokens:[NSArray arrayWithObjects:[[imageToken alloc] init],[[scrollableToken alloc] init], nil]];
    self.tokens=[parser parseString:body];
}

-(void)setBody:(NSDictionary *)tokens and:(UIView *)view and:(NSMutableArray<UIView *> *)bodyViews
{
    NSUInteger maxCount=0;
    NSArray<NSString *> * array;
    NSString * maxStr;
    CGFloat width;
    NSArray * allkeys=tokens.allKeys;
    NSArray * allValues=tokens.allValues;
    CGFloat bodyHeight=0;
    
    for(NSUInteger i=0;i<tokens.count;++i)
    {
        if([allkeys[i] containsString:@"scroll"])
        {
            array=[allValues[i] componentsSeparatedByString:@"\n"];
            for(NSString * str in array)
            {
                if(str.length>maxCount)
                {
                    maxCount=str.length;
                    maxStr=str;
                }
            }

            width=[bodyCollectionViewCell widthByString:maxStr]+20;
            UITextView * tempText=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
            [tempText setFont:[UIFont systemFontOfSize:12.0]];
            tempText.text=allValues[i];
            
            CGFloat height=tempText.contentSize.height;
            UIScrollView * scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(8,bodyHeight+view.subviews.lastObject.frame.origin.y+view.subviews.lastObject.bounds.size.height+8, self.view.bounds.size.width-16, height)];

            UITextView * textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            textView.editable=NO;
            textView.dataDetectorTypes=UIDataDetectorTypeLink|UIDataDetectorTypeAddress|UIDataDetectorTypePhoneNumber;
            
            textView.text=allValues[i];
            [textView setFont:[UIFont systemFontOfSize:12.0]];
            textView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.0];
            scrollView.contentSize=CGSizeMake(width, height);
            scrollView.backgroundColor=[UIColor scrollCollor];
            scrollView.layer.cornerRadius=5.0;
            [scrollView addSubview:textView];
            [view addSubview:scrollView];
            [bodyViews addObject:scrollView];
        }
        else if([allkeys[i] containsString:@"imageRef"])
        {
            UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, bodyHeight+view.subviews.lastObject.frame.origin.y+view.subviews.lastObject.bounds.size.height+8, self.view.bounds.size.width-16, 300)];
            AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
            [manager loadDataWithURLString:allValues[i] andSuccess:^(NSString * path)
             {
                 UIImage * image=[UIImage imageWithContentsOfFile:path];
                 CGFloat coeficient;
                 CGFloat width=image.size.width;
                 CGFloat height=image.size.height;
                 if(image.size.height>image.size.width)
                 {
                     coeficient=image.size.height/image.size.width;
                     
                     while(width>self.view.bounds.size.width || height>300.0)
                     {
                         height-=coeficient;
                         width--;
                     }
                 }
                 else
                 {
                     coeficient=image.size.width/image.size.height;
                     
                     while(width>self.view.bounds.size.width || height>300.0)
                     {
                         height--;
                         width-=coeficient;
                     }
                 }
                 imageView.bounds=CGRectMake(0, 0, width, height);

                 dispatch_async(dispatch_get_main_queue(), ^
                 {
                        imageView.image=[UIImage imageWithContentsOfFile:path];
                 });
             } orFailure:^(NSString * message)
             {
                 NSLog(@"%@",message);
             }];
            [view addSubview:imageView];
            [bodyViews addObject:imageView];
        }
        else
        {
            UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(8, bodyHeight+view.subviews.lastObject.frame.origin.y+view.subviews.lastObject.bounds.size.height+8, self.view.bounds.size.width-16, [bodyCollectionViewCell heightByString:allValues[i]])];

            label.text=allValues[i];
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor blackColor];
            label.font=[UIFont systemFontOfSize:12.0];
            label.minimumScaleFactor=12;
            label.numberOfLines=0;
            [view addSubview:label];
            [bodyViews addObject:label];
        }
        self.isAll=YES;
    }
}



@end
