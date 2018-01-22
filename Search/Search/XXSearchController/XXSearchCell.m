//
//  XXSearchCell.m
//  test
//
//  Created by luodaji on 2018/1/10.
//  Copyright © 2018年 luodaji. All rights reserved.
//

#import "XXSearchCell.h"

@interface XXSearchCell()
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

@implementation XXSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.titleL.text = _title;
}

@end
