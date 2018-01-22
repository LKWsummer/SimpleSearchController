# SimpleSearchController
# 直接用类方法初始化即可
````
XXSearchViewController *xx = [XXSearchViewController searchWithHotSearchs:nil searchBarPlaceholder:@"java"];

UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:xx];
[self presentViewController:navi animated:YES completion:nil];
````

# 若想用代理方法，直接继承当前控制器，将代理设置为自己，再实现代理方法即可
````
self.delegate = self;
````
