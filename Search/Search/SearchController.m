//
//  SearchController.m
//  Search
//
//  Created by luodaji on 2018/1/22.
//  Copyright © 2018年 lkw. All rights reserved.
//

#import "SearchController.h"

@interface SearchController ()<XXSearchViewControllerDelegate>

@end

@implementation SearchController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.hotSearchsArray = @[@"空军一号",@"黑武士",@"史密斯"];
    // 如果不想使用这些代理，直接使用类方法初始化即可
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.searchBar.placeholder = @"PHP是最好的语言";
}

/**
 点击了搜索按钮
 */
-(void)searchViewController:(XXSearchViewController *)searchViewController didClickSearchButton:(UISearchBar *)searchBar searchText:(NSString *)searchText
{
    
}

/**
 点击了热搜
 
 @param index 热搜词的索引
 @param hotText 热搜词内容
 */
-(void)searchViewController:(XXSearchViewController *)searchViewController didClickHotSearch:(NSInteger)index hotText:(NSString *)hotText
{
    
}

/**
 点击了搜索历史
 
 @param index 搜索历史的索引
 @param historyText 搜索历史内容
 */
-(void)searchViewController:(XXSearchViewController *)searchViewController didClickSearchHistory:(NSInteger)index historyText:(NSString *)historyText
{
    
}

/**
 搜索文字改变
 
 @param searchText 搜索文字
 */
-(void)searchViewController:(XXSearchViewController *)searchViewController searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

/**
 点击了搜索结果
 
 @param index 搜索历史的索引
 @param resultText 搜索历史内容
 */
-(void)searchViewController:(XXSearchViewController *)searchViewController didClickSearchResult:(NSInteger)index resultText:(NSString *)resultText
{
    
}

@end
