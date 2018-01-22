//
//  XXSearchViewController.h
//  test
//
//  Created by luodaji on 2018/1/10.
//  Copyright © 2018年 luodaji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXSearchViewController;

@protocol XXSearchViewControllerDelegate <NSObject>
@optional

/**
 点击了搜索按钮
 */
-(void)searchViewController:(XXSearchViewController *)searchViewController didClickSearchButton:(UISearchBar *)searchBar searchText:(NSString *)searchText;

/**
 点击了热搜

 @param index 热搜词的索引
 @param hotText 热搜词内容
 */
-(void)searchViewController:(XXSearchViewController *)searchViewController didClickHotSearch:(NSInteger)index hotText:(NSString *)hotText;

/**
 点击了搜索历史
 
 @param index 搜索历史的索引
 @param historyText 搜索历史内容
 */
-(void)searchViewController:(XXSearchViewController *)searchViewController didClickSearchHistory:(NSInteger)index historyText:(NSString *)historyText;

/**
 搜索文字改变
 
 @param searchText 搜索文字
 */
-(void)searchViewController:(XXSearchViewController *)searchViewController searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;

/**
 点击了搜索结果
 
 @param index 搜索历史的索引
 @param resultText 搜索历史内容
 */
-(void)searchViewController:(XXSearchViewController *)searchViewController didClickSearchResult:(NSInteger)index resultText:(NSString *)resultText;

@end;

@interface XXSearchViewController : UIViewController
/**代理*/
@property (weak, nonatomic) id<XXSearchViewControllerDelegate> delegate;

/**热门搜索数据源*/
@property (strong, nonatomic) NSArray<NSString *> *hotSearchsArray;

/**搜索结果数据源*/
@property (strong, nonatomic) NSArray<NSString *> *searchResultsArray;

/**搜索框*/
@property (weak, nonatomic) UISearchBar *searchBar;

/**搜索历史记录存放路径 为了防止创建多个对象的时候，每个对象的历史记录都一样 默认为 XXSEARCHHISTORY_CACHE_PATH*/
@property (copy, nonatomic) NSString *searchHistoryCachePath;

/**
 快速创建一个搜索控制器

 @param hotSearchs 热搜数组
 @param placeholder 搜索栏占位词
 @return 搜索控制器
 */
+(instancetype)searchWithHotSearchs:(NSArray<NSString *>*)hotSearchs searchBarPlaceholder:(NSString *)placeholder;
@end
