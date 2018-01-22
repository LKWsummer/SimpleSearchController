//
//  XXSearchReusableView.h
//  test
//
//  Created by luodaji on 2018/1/10.
//  Copyright © 2018年 luodaji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXSearchReusableView : UICollectionReusableView
/**头视图标题*/
@property (copy, nonatomic) NSString *headerTitle;

/**点击清空搜索历史的block*/
@property (copy, nonatomic) dispatch_block_t cleanHistory;

@end
