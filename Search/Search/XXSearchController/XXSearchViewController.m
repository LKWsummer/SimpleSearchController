//
//  XXSearchViewController.m
//  test
//
//  Created by luodaji on 2018/1/10.
//  Copyright © 2018年 luodaji. All rights reserved.
//

#import "XXSearchViewController.h"
#import "FlowLayout.h"
#import "XXSearchCell.h"
#import "XXSearchReusableView.h"
#import "NSString+XXExtension.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define XXSEARCHHISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"XXSEARCHHISTORYCACHEPATH.plist"]


@interface XXSearchViewController ()<UISearchBarDelegate,
UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,
UITableViewDelegate,UITableViewDataSource>


/**展示搜索历史和热门搜索的collectionView*/
@property (weak, nonatomic) UICollectionView *historyHotView;

/**热门搜索*/
@property (strong, nonatomic) NSMutableArray *hotArray;

/**历史搜索*/
@property (strong, nonatomic) NSMutableArray *historyArray;

/**展示搜索结果联想的tableview*/
@property (weak, nonatomic) UITableView *searchResultTableView;

/**搜索结果联想数据源*/
@property (strong, nonatomic) NSMutableArray *resultArray;
@end

static NSString *const searchCellIdentifier = @"searchCellIdentifier";
static NSString *const searchHeaderIdentifier = @"searchHeaderIdentifier";
static NSString *const searchResultCellIdentifier = @"searchResultCellIdentifier";

@implementation XXSearchViewController

+(instancetype)searchWithHotSearchs:(NSArray<NSString *> *)hotSearchs searchBarPlaceholder:(NSString *)placeholder
{
    XXSearchViewController *searchVC = [[XXSearchViewController alloc] init];
    searchVC.hotSearchsArray = [NSMutableArray arrayWithArray:hotSearchs];
    searchVC.searchBar.placeholder = placeholder;
    return searchVC;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpCollectionView];
        [self setUpTableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUpCollectionView];
//    [self setUpTableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 因为刚进来的时候，取消是enabled = yes，点了没反映。所以直接变为第一响应者
    [self.searchBar becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

-(void)setUpCollectionView
{
    self.navigationItem.hidesBackButton = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.searchBar becomeFirstResponder];
    // 热搜数组
    self.hotArray = [NSMutableArray arrayWithArray:self.hotSearchsArray];
    // 搜索历史路径
    self.searchHistoryCachePath = XXSEARCHHISTORY_CACHE_PATH;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor grayColor];
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    searchBar.showsCancelButton = YES;
    [searchBar setImage:[UIImage imageNamed:@"close"] forSearchBarIcon:UISearchBarIconResultsList state:UIControlStateNormal];
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    
    // 搜索历史、热词
    CGFloat y = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat w = ScreenWidth;
    CGFloat h = ScreenHeight - y;
    
    FlowLayout *layout = [[FlowLayout alloc] init];
    layout.alignment = FlowAlignmentLeft;
    layout.headerReferenceSize = CGSizeMake(0, 50);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 15, 0);
    
    UICollectionView *historyHotView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, w, h) collectionViewLayout:layout];
    historyHotView.dataSource = self;
    historyHotView.delegate = self;
    historyHotView.backgroundColor = [UIColor clearColor];
    // 始终可以垂直滑动
    historyHotView.alwaysBounceVertical = YES;
    historyHotView.contentInset = UIEdgeInsetsMake(15, 15, 15, 15);
    historyHotView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:historyHotView];
    self.historyHotView = historyHotView;
    // cell
    [historyHotView registerNib:[UINib nibWithNibName:NSStringFromClass([XXSearchCell class]) bundle:nil] forCellWithReuseIdentifier:searchCellIdentifier];
    // 头视图
    [historyHotView registerNib:[UINib nibWithNibName:NSStringFromClass([XXSearchReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:searchHeaderIdentifier];
}

/**
 显示联想结果的tableview
 */
-(void)setUpTableView
{
    CGFloat y = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat w = ScreenWidth;
    CGFloat h = ScreenHeight - y;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, w, h) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableView];
    self.searchResultTableView = tableView;
    self.searchResultTableView.hidden = YES;
    
    [self.searchResultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:searchResultCellIdentifier];
}

#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // 暂时只有‘热搜’和‘搜索历史’，所以，直接写死两个section
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 如果热搜没有数据，就不显示‘热门搜索’，搜索历史也一样
    return section == 0 ? self.hotArray.count : self.historyArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XXSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:searchCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {// 热搜
       cell.title = self.hotArray[indexPath.row];
    }else{// 搜索历史
        cell.title = self.historyArray[indexPath.row];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XXSearchReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:searchHeaderIdentifier forIndexPath:indexPath];
    header.cleanHistory = ^{// 清空搜索历史，直接归档一个空数组
        [self.historyArray removeAllObjects];
        [NSKeyedArchiver archiveRootObject:self.historyArray toFile:self.searchHistoryCachePath];
        [self.historyHotView reloadData];
    };
    header.headerTitle = indexPath.section == 0 ? @"热门搜索" : @"搜索历史";
    return header;
}

#pragma mark - <UIScrollViewDelegate>
// 这个方法是为了让searchbar的cancel button始终处于enable = yes状态
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
    UIButton * button = [self.searchBar valueForKey:@"cancelButton"];
    button.enabled = YES;
}

#pragma mark - <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[UIViewController new] animated:YES];
    if (indexPath.section == 0) {// 点击了‘热搜’的item的代理
        if ([self.delegate respondsToSelector:@selector(searchViewController:didClickHotSearch:hotText:)]) {
            [self.delegate searchViewController:self didClickHotSearch:indexPath.item hotText:self.hotArray[indexPath.item]];
        }
    }else{// 点击了‘搜索历史’的item的代理
        if ([self.delegate respondsToSelector:@selector(searchViewController:didClickSearchHistory:historyText:)]) {
            [self.delegate searchViewController:self didClickSearchHistory:indexPath.item historyText:self.historyArray[indexPath.item]];
        }
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
// item的宽度等于文字的宽度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *hot = self.hotArray[indexPath.row];
        CGSize size = [hot boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        CGFloat width = size.width > ScreenWidth ? ScreenWidth : size.width + 20;
        return CGSizeMake(width, size.height + 10);
    }else{
        NSString *history = self.historyArray[indexPath.row];
        CGSize size = [history boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        CGFloat width = size.width > ScreenWidth ? ScreenWidth : size.width + 20;
        return CGSizeMake(width, size.height + 10);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {// 如果‘热搜’没有数据，就不显示热搜头视图，‘搜索历史’也一样
        return self.hotArray.count ? CGSizeMake(0, 50) : CGSizeZero ;
    }else{
        return self.historyArray.count ? CGSizeMake(0, 50) : CGSizeZero ;
    }
}


#pragma mark - <UISearchBarDelegate>
// 取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //
    [self.searchBar resignFirstResponder];
    
    if (self.presentingViewController) {// 判断当前控制器是modal出来的，还是push出来的
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"];
//    cancelBtn.enabled = YES;
//    cancelBtn.userInteractionEnabled = YES;
    if (![searchBar.text xx_isEmpty]) {// 如果不为空（空格不算），就添加到搜索历史
        
        [self.historyArray addObject:searchBar.text];
        // 每次点击完搜索，就把搜索历史保存到沙盒
        [NSKeyedArchiver archiveRootObject:self.historyArray toFile:self.searchHistoryCachePath];
        [self.historyHotView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(searchViewController:didClickSearchButton:searchText:)]) {
            [self.delegate searchViewController:self didClickSearchButton:searchBar searchText:searchBar.text];
        }
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.delegate respondsToSelector:@selector(searchViewController:searchBar:textDidChange:)]) {
        [self.delegate searchViewController:self searchBar:searchBar textDidChange:searchText];
    }
}

#pragma mark - <UITableViewDataSource>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellIdentifier];
    cell.textLabel.text = self.resultArray[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(searchViewController:didClickSearchResult:resultText:)]) {
        [self.delegate searchViewController:self didClickSearchResult:indexPath.row resultText:self.searchResultsArray[indexPath.row]];
    }
}

#pragma mark - <setter>

-(void)setSearchResultsArray:(NSArray<NSString *> *)searchResultsArray
{
    _searchResultsArray = searchResultsArray;
    self.resultArray = [NSMutableArray arrayWithArray:searchResultsArray];
    [self.searchResultTableView reloadData];
    // 有搜索结果就显示，否则隐藏
    self.searchResultTableView.hidden = !self.searchResultsArray.count;
}

-(void)setHotSearchsArray:(NSArray<NSString *> *)hotSearchsArray
{
    _hotSearchsArray = hotSearchsArray;
    self.hotArray = [NSMutableArray arrayWithArray:hotSearchsArray];
}


#pragma mark - <懒加载>
-(NSMutableArray *)hotArray
{
    if (_hotArray == nil) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}

-(NSMutableArray *)historyArray
{
    if (_historyArray == nil) {
        _historyArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoryCachePath]];
    }
    return _historyArray;
}

-(NSMutableArray *)resultArray
{
    if (_resultArray == nil) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

@end
