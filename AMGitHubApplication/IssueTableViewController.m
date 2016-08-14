//
//  IssueTableViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 14.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssueTableViewController.h"
#import "testView.h"
#import "UIColor+GitHubColor.h"
#import "AMGitHubCommentParser.h"
#import "bodyCollectionViewCell.h"
#import "AMDataManager.h"
#import "IssuTableViewCell.h"

@interface IssueTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)UIView * footerView;
@property (nonatomic)testView * header;
@property (nonatomic)NSMutableArray<UIView *>* bodyView;
@property (nonatomic)NSMutableArray<NSMutableArray<UIView *>*> * subViews;
@property (nonatomic)NSMutableArray<NSDictionary *>* tokens;
@end

@implementation IssueTableViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count+1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"reuse";
    IssuTableViewCell * cell;//=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell=[[IssuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //cell.subviewsnil;
    [self.subViews[indexPath.row] removeAllObjects];
    if(indexPath.row-1>=0)
    {
        [self setCommentlayoutForIndex:indexPath.row-1];
    }
    [self setBody:self.tokens[indexPath.row] and:self.bodyView[indexPath.row] and:self.subViews[indexPath.row]];
        NSUInteger i=self.subViews[indexPath.row].count;
        NSLog(@"%@",cell.subviews);
            for(NSInteger k=0;k<i;++k)
            {
                [cell addSubview:self.bodyView[indexPath.row].subviews.firstObject];
                cell.isAddContent=YES;
                NSLog(@"%ld",self.bodyView[indexPath.row].subviews.count);
            }
         NSLog(@"%@",cell.subviews);
        cell.backgroundColor=[UIColor whiteColor];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.footerView.frame=CGRectMake(self.footerView.frame.origin.x, -self.tableView.contentOffset.y, self.footerView.frame.size.width, self.footerView.frame.size.height);
}

-(void)setCommentlayoutForIndex:(NSUInteger)index
{
    UIImageView * image=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
    image.clipsToBounds=YES;
    image.autoresizesSubviews=YES;
    image.opaque=YES;
    image.clearsContextBeforeDrawing=YES;
    image.layer.cornerRadius=15.0;
    
    UILabel * nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(38, 8, self.view.bounds.size.width-38, 15.0)];
    nameLabel.text=self.comments[index].user.login;
    nameLabel.font=[UIFont systemFontOfSize:14.0];
    
    UILabel * dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(38, 23, self.view.bounds.size.width-38, 15.0)];
    dateLabel.text=self.comments[index].createdDate;
    dateLabel.font=[UIFont systemFontOfSize:14.0];
    
    [self.bodyView[index+1] addSubview:image];
    [self.bodyView[index+1] addSubview:nameLabel];
    [self.bodyView[index+1] addSubview:dateLabel];
    
    [self.subViews[index+1] addObject:nameLabel];
    [self.subViews[index+1] addObject:dateLabel];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        CGFloat height=0;
        for(NSUInteger i=0;i<self.subViews[indexPath.row].count;++i)
        {
            height+=self.subViews[indexPath.row][i].bounds.size.height+8;
        }
        return height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.isAll=NO;
    UIView * upperView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    upperView.backgroundColor=[UIColor GitHubColor];
    self.tokens=[NSMutableArray array];
    
    self.tableView.backgroundView=upperView;
    self.comments=[NSMutableArray array];
    self.footerView=[[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bounds.size.height/3.3, self.tableView.bounds.size.width, [UIScreen mainScreen].bounds.size.height*2)];
    self.footerView.backgroundColor=[UIColor SeparatorColor];
    [upperView addSubview:self.footerView];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"testView"owner:self options:nil];
    self.header=[nib objectAtIndex:0];
    self.header.bounds=CGRectMake(0, 0, self.view.bounds.size.width, 280);
    self.header.frame=CGRectMake(0, 0, self.view.bounds.size.width, 280);
    self.tableView.tableHeaderView=self.header;
    
    self.bodyView=[NSMutableArray array];
    [self.bodyView addObject:[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CGFLOAT_MAX)]];
    self.subViews=[NSMutableArray array];
    [self.subViews addObject:[NSMutableArray array]];
    [self parseDataForBody:self.issue.body];
    //[self setBody:self.issue.body and:self.bodyView[0] and:self.subViews[0]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addIssueComments" object:self];
}

-(void)addComments:(NSArray<GitHubIssueComment *> *)comments
{
    NSMutableArray * indexPaths=[NSMutableArray array];
    NSUInteger k=0;
    for(NSUInteger i=self.comments.count;i<self.comments.count+comments.count;++i)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i+1 inSection:0]];
        [self.bodyView addObject:[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CGFLOAT_MAX)]];
        [self.subViews addObject:[NSMutableArray array]];
        [self parseDataForBody:comments[k].body];
        ++k;
        //[self setBody:comments[i-self.comments.count].body and:self.bodyView.lastObject and:self.subViews.lastObject];
    }
    [self.comments addObjectsFromArray:comments];
    [self.tableView reloadData];
    //[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

-(NSUInteger)commentsCount
{
    return self.comments.count;
}

-(void)parseDataForBody:(NSString *)body
{
    AMGitHubCommentParser * parser=[[AMGitHubCommentParser alloc] initWithTokens:[NSArray arrayWithObjects:[[imageToken alloc] init],[[scrollableToken alloc] init], nil]];
    [self.tokens addObject:[parser parseString:body]];
}

-(void)setBody:(NSDictionary *)tokens and:(UIView *)view and:(NSMutableArray<UIView *> *)bodyViews
{
    __block NSUInteger maxCount=0;
    __block NSArray<NSString *> * array;
    __block NSString * maxStr;
    __block CGFloat width;
    //AMGitHubCommentParser * parser=[[AMGitHubCommentParser alloc] initWithTokens:[NSArray arrayWithObjects:[[imageToken alloc] init],[[scrollableToken alloc] init], nil]];
    //[self.collectionView registerClass:[self.cellView class] forCellWithReuseIdentifier:@"bodyCell"];
    //NSDictionary * tokens= [parser parseString:body];
    NSArray * allkeys=tokens.allKeys;
    NSArray * allValues=tokens.allValues;
    CGFloat bodyHeight=0;
//    for(NSUInteger i=0;i<bodyViews.count;++i)
//    {
//        bodyHeight+=bodyViews[i].bounds.size.height+8;
//    }
    NSLog(@"%@",view.subviews);
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
            NSLog(@"%@",maxStr);
            width=[bodyCollectionViewCell widthByString:maxStr]+20;
            UITextView * tempText=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
            [tempText setFont:[UIFont systemFontOfSize:12.0]];
            tempText.text=allValues[i];
            
            CGFloat height=tempText.contentSize.height;
            UIScrollView * scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(8,bodyHeight+view.subviews.lastObject.frame.origin.y+view.subviews.lastObject.bounds.size.height+8, self.view.bounds.size.width-8, height)];
            NSLog(@"%f",tempText.contentSize.height);
            UITextView * textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            NSLog(@"Widtch:%f   Height:%f",textView.bounds.size.width, textView.bounds.size.height);
            textView.text=allValues[i];
            [textView setFont:[UIFont systemFontOfSize:12.0]];
            textView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.0];
            NSLog(@"%f",textView.contentSize.height);
            scrollView.contentSize=CGSizeMake(width, height);
            scrollView.backgroundColor=[UIColor scrollCollor];
            scrollView.layer.cornerRadius=5.0;
            [scrollView addSubview:textView];
            [view addSubview:scrollView];
            [bodyViews addObject:scrollView];
        }
        else if([allkeys[i] containsString:@"imageRef"])
        {
            UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, bodyHeight+view.subviews.lastObject.frame.origin.y+view.subviews.lastObject.bounds.size.height+8, self.view.bounds.size.width, 300)];
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
                 NSLog(@"%f   %f",imageView.bounds.size.height,imageView.bounds.size.width);
                 imageView.image=[UIImage imageWithContentsOfFile:path];
             } orFailure:^(NSString * message)
             {
                 NSLog(@"%@",message);
             }];
            [view addSubview:imageView];
            [bodyViews addObject:imageView];
        }
        else
        {
            UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(8, bodyHeight+view.subviews.lastObject.frame.origin.y+view.subviews.lastObject.bounds.size.height+8, self.view.bounds.size.width+8, [bodyCollectionViewCell heightByString:allValues[i]])];
            NSLog(@"%@",label);
            NSLog(@"%f",view.subviews.lastObject.frame.origin.y);
            NSLog(@"%f",view.subviews.lastObject.bounds.size.height);
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
    NSLog(@"%@",view.subviews);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
