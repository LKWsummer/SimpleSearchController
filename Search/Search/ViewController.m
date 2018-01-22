//
//  ViewController.m
//  Search
//
//  Created by luodaji on 2018/1/22.
//  Copyright © 2018年 lkw. All rights reserved.
//

#import "ViewController.h"
#import "SearchController.h"
#import "XXSearchViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)pushToSearchVC:(UIButton *)sender {
    
    XXSearchViewController *xx = [XXSearchViewController searchWithHotSearchs:nil searchBarPlaceholder:@"java"];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[SearchController new]];
    [self presentViewController:navi animated:YES completion:nil];
}


@end
