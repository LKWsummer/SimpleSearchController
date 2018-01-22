//
//  XXSearchReusableView.m
//  test
//
//  Created by luodaji on 2018/1/10.
//  Copyright © 2018年 luodaji. All rights reserved.
//

#import "XXSearchReusableView.h"

@interface XXSearchReusableView()
@property (weak, nonatomic) IBOutlet UILabel *sectionTitleL;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@end

@implementation XXSearchReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setHeaderTitle:(NSString *)headerTitle
{
    _headerTitle = [headerTitle copy];
    self.sectionTitleL.text = _headerTitle;
    self.clearBtn.hidden = ![_headerTitle isEqualToString:@"搜索历史"];
}

- (IBAction)clearBtnClick:(UIButton *)sender {
    self.cleanHistory ? self.cleanHistory() : nil;
}


@end
