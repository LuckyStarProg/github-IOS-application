//
//  IssueViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 12.08.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "IssueViewController.h"

@interface IssueViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic)UIView * footerView;
@property (nonatomic)UIView * cellView;
@property (nonatomic)NSMutableArray<UIView *> * bodyViews;
@property (nonatomic)NSMutableArray<NSMutableArray<UIView *> *> * commentsViews;
@property (nonatomic)NSMutableArray<UIView *> * cellViews;
@property (nonatomic)BOOL flag;
@end

@implementation IssueViewController
#define ROW_COUNT 3

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * idebtifier=@"some cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:idebtifier];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idebtifier];
    }
    if(indexPath.row==0)
    {

    }
    else
    {
        //cell.imageView.image=[UIImage imageNamed:@"man"];
        cell.textLabel.text=self.issue.body;
    }
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RepoAvatarView * headerView;
    if(kind==UICollectionElementKindSectionHeader)
    {
        headerView=(RepoAvatarView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.nameLabel.text=self.issue.title;
        headerView.descriptionLabel.text=self.issue.createDate;
        if(!self.issue.user.avatarPath)
        {
            AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
            [manager loadDataWithURLString:self.issue.user.avatarRef andSuccess:^(NSString * path)
             {
                 self.issue.user.avatarPath=path;
                 dispatch_async(dispatch_get_main_queue(), ^
                 {
                    headerView.imageView.image=[UIImage imageWithContentsOfFile:path];
                    [headerView setNeedsLayout];
                 });
             } orFailure:^(NSString * message)
             {
                 NSLog(@"%@",message);
             }];
        }
        else
        {
            headerView.imageView.image=[UIImage imageWithContentsOfFile:self.issue.user.avatarPath];
        }
        headerView.imageView.layer.borderWidth=2.0;
        headerView.imageView.layer.borderColor=[UIColor whiteColor].CGColor;
    }
return headerView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
//    SEL selector = NSSelectorFromString(self.methods[indexPath.row]);
//    ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    if(self.preferredInterfaceOrientationForPresentation==UIInterfaceOrientationPortrait || self.preferredInterfaceOrientationForPresentation==UIInterfaceOrientationPortraitUpsideDown)
    {
        size=CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height*0.3 + [RepoAvatarView heightForText:self.issue.title]);
    }
    else
    {
        size=CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height*0.5 + [RepoAvatarView heightForText:self.issue.title]);
    }
    
    return size;
}
-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout*)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    size.width=collectionView.bounds.size.width;
    if(indexPath.row==0)
    {
        size.height=45.0;
    }
    else if(indexPath.row==1)
    {
        size.height=20.0;
    }
    else if(indexPath.row==2)
    {
        CGFloat height;
        for(NSUInteger i=0;i<self.bodyViews.count;++i)
        {
            height+=self.bodyViews[i].bounds.size.height+8;
        }
        size.height=height+8;
    }
    else
    {
        CGFloat height;
        for(NSUInteger i=0;i<self.commentsViews[indexPath.row-3].count;++i)
        {
            height+=self.commentsViews[indexPath.row-3][i].bounds.size.height+8;
        }
        size.height=height+50;
    }
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ROW_COUNT+self.comments.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    defaultCollectionViewCell * defaultCell;
    UICollectionViewCell * emptyCell;
    UICollectionViewCell * commentCell;
//    if(indexPath.row==self.comments.count)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
//    }
     if(indexPath.row==0)
     {
         defaultCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"defaultCell" forIndexPath:indexPath];
            defaultCell.descriptionLabel.text=@"Assignee";
            defaultCell.nameLabel.text=self.issue.assigneeUser.name?self.issue.assigneeUser.name:@"Unassigned";
            defaultCell.backgroundColor=[UIColor whiteColor];
            return defaultCell;
     }
    else if(indexPath.row==1)
    {
        emptyCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"emptyCell" forIndexPath:indexPath];
        emptyCell.backgroundColor=[UIColor SeparatorColor];
        return emptyCell;
    }
      else if(indexPath.row==2)
      {
            emptyCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"emptyCell" forIndexPath:indexPath];
          NSLog(@"%ld",self.cellView.subviews.count);
          
          
          NSUInteger k=self.cellView.subviews.count;
          for(NSUInteger i=0;i<k;++i)
          {
              [emptyCell.contentView addSubview:[self.cellView.subviews firstObject]];
              NSLog(@"%ld",self.cellView.subviews.count);
          }
          //[collectionView.collectionViewLayout invalidateLayout];
            emptyCell.backgroundColor=[UIColor whiteColor];
            return emptyCell;
      }
    else
    {
        commentCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"emptyCell" forIndexPath:indexPath];
        //commentCell.nameLabel.text=self.comments[indexPath.row-3].user.login;
        //commentCell.createdDateLabel.text=self.comments[indexPath.row-3].createdDate;
//        if(!self.comments[indexPath.row-3].user.avatarPath)
//        {
//            AMDataManager * manager=[[AMDataManager alloc] initWithMod:AMDataManageDefaultMod];
//            [manager loadDataWithURLString:self.comments[indexPath.row-3].user.avatarRef andSuccess:^(NSString * path)
//            {
//                self.comments[indexPath.row-3].user.avatarPath=path;
//                dispatch_async(dispatch_get_main_queue(), ^
//                {
//                    //commentCell.avatarView.image=[UIImage imageWithContentsOfFile:path];
//                    [commentCell setNeedsLayout];
//                });
//            } orFailure:^(NSString * message)
//            {
//                NSLog(@"%@",message);
//            }];
//        }
        NSUInteger k=self.cellViews[indexPath.row-3].subviews.count;
        for(NSUInteger i=0;i<k;++i)
        {
            [commentCell.contentView addSubview:[self.cellViews[indexPath.row-3].subviews firstObject]];
        }
        commentCell.backgroundColor=[UIColor SeparatorColor];
        return commentCell;
    }
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.footerView.frame=CGRectMake(self.footerView.frame.origin.x, -self.collectionView.contentOffset.y, self.footerView.frame.size.width, self.footerView.frame.size.height);
}

-(void)addComments:(NSArray<GitHubIssueComment *> *)comments
{
    NSMutableArray * indexPaths=[NSMutableArray array];
    for(NSUInteger i=self.comments.count;i<self.comments.count+comments.count;++i)
    {
        [indexPaths addObject:[NSIndexPath indexPathForItem:i+3 inSection:0]];
    }
    [self.comments addObjectsFromArray:comments];
    
    self.cellViews=[NSMutableArray arrayWithCapacity:self.comments.count];
    self.commentsViews=[NSMutableArray arrayWithCapacity:self.comments.count];
    for(NSUInteger i=0;i<self.comments.count;++i)
    {
        self.commentsViews[i]=[NSMutableArray array];
        self.cellViews[i]=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width , CGFLOAT_MAX)];
        self.cellViews[i].backgroundColor=[UIColor whiteColor];
        UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 50, 50)];
        imageView.layer.cornerRadius=25.0;
        
        UILabel * nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(58, 8, self.view.bounds.size.width-58, 25)];
        nameLabel.font=[UIFont systemFontOfSize:14.0];
        
        UILabel * dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(58, 33.0, self.view.bounds.size.width-58, 25)];
        dateLabel.font=[UIFont systemFontOfSize:14.0];
        
        [self.cellViews[i] addSubview:imageView];
        [self.cellViews[i] addSubview:nameLabel];
        [self.cellViews[i] addSubview:dateLabel];
        
        [self setBody:self.comments[i].body and:self.cellViews[i] and:self.commentsViews[i]];
    }
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

-(NSUInteger)commentsCount
{
    return self.comments.count;
}

-(instancetype)initWithUpdateNotification:(NSString *)notification
{
    if(self=[super init])
    {
        self.notification=notification;
    }
    return self;
}

-(void)setBody:(NSString *)body and:(UIView *)view and:(NSMutableArray *)bodyViews
{
    __block NSUInteger maxCount=0;
    __block NSArray<NSString *> * array;
    __block NSString * maxStr;
    __block CGFloat width;
    AMGitHubCommentParser * parser=[[AMGitHubCommentParser alloc] initWithTokens:[NSArray arrayWithObjects:[[imageToken alloc] init],[[scrollableToken alloc] init], nil]];
    //[self.collectionView registerClass:[self.cellView class] forCellWithReuseIdentifier:@"bodyCell"];
    NSDictionary * tokens= [parser parseString:body];
    NSArray * allkeys=tokens.allKeys;
    NSArray * allValues=tokens.allValues;
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
            UIScrollView * scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(8,view.subviews.lastObject.bounds.origin.y+view.subviews.lastObject.bounds.size.height+8, self.view.bounds.size.width-8, height)];
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
            UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, view.subviews.lastObject.bounds.origin.y+view.subviews.lastObject.bounds.size.height, self.view.bounds.size.width, 300)];
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
            UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(8, view.subviews.lastObject.bounds.origin.y+view.subviews.lastObject.bounds.size.height+8, self.view.bounds.size.width-8, [bodyCollectionViewCell heightByString:allValues[i]])];
            NSLog(@"%@",label);
            label.text=allValues[i];
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor blackColor];
            label.font=[UIFont systemFontOfSize:12.0];
            label.minimumScaleFactor=12;
            label.numberOfLines=0;
            [view addSubview:label];
            [bodyViews addObject:label];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    UIView * upperView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    upperView.backgroundColor=[UIColor GitHubColor];
    
    NSLog(@"%@",self.collectionView.backgroundView);
    self.collectionView.backgroundView=upperView;
    
    self.footerView=[[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bounds.size.height/3.3, self.collectionView.bounds.size.width, [UIScreen mainScreen].bounds.size.height*2)];
    self.footerView.backgroundColor=[UIColor SeparatorColor];
    [upperView addSubview:self.footerView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"defaultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"defaultCell"];
    [self.collectionView registerClass:[bodyCollectionViewCell class] forCellWithReuseIdentifier:@"bodyCell"];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"emptyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"bodyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bodyCell"];
    
    //[self.collectionView registerClass:[commentCollectionViewCell class] forCellWithReuseIdentifier:@"commentCell"];
    //[self.collectionView registerNib:[UINib nibWithNibName:@"commentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"commentCell"];
    self.comments=[NSMutableArray array];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notification object:self];
    
    self.bodyViews=[NSMutableArray array];
    self.cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width , CGFLOAT_MAX)];
    self.cellView.backgroundColor=[UIColor whiteColor];
    [self setBody:self.issue.body and:self.cellView and:self.bodyViews];
    
    CGFloat hieght;
    self.cellView.backgroundColor=[UIColor blueColor];
    for(NSUInteger i=0;i<self.cellView.subviews.count;++i)
    {
        hieght+=self.cellView.subviews[i].bounds.size.height+10;
    }
    self.cellView.bounds=CGRectMake(0, 0, self.view.bounds.size.width, hieght);
//    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
