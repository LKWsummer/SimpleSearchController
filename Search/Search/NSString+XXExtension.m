//
//  NSString+XXExtension.m
//  test
//
//  Created by luodaji on 2018/1/11.
//  Copyright © 2018年 luodaji. All rights reserved.
//

#import "NSString+XXExtension.h"

@implementation NSString (XXExtension)

-(BOOL)xx_isEmpty
{
    if (self == nil) {
        return YES;
    }else{
        return !self.length || ![self stringByReplacingOccurrencesOfString:@" " withString:@""].length;
    }
}

@end
