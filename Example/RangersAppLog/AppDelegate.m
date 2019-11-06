//
//  AppDelegate.m
//  RangersAppLog
//
//  Created by bob on 2019/9/9.
//  Copyright © 2019 Bytedance. All rights reserved.
//

#import "AppDelegate.h"
#import "BDDemoViewController.h"
#import "BDAdapter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [BDAdapter trackCallback:NSStringFromSelector(_cmd) state:application.applicationState];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BDAdapter trackCallback:NSStringFromSelector(_cmd) state:application.applicationState];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[BDDemoViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {

    [BDAdapter trackCallback:NSStringFromSelector(_cmd) state:application.applicationState];
    NSLog(@"%@",url.absoluteString);

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BDAdapter trackCallback:NSStringFromSelector(_cmd) state:application.applicationState];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BDAdapter trackCallback:NSStringFromSelector(_cmd) state:application.applicationState];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [BDAdapter trackCallback:NSStringFromSelector(_cmd) state:application.applicationState];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [BDAdapter trackCallback:NSStringFromSelector(_cmd) state:application.applicationState];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [BDAdapter trackCallback:NSStringFromSelector(_cmd) state:application.applicationState];
}

/// background fetch 30s
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [BDAdapter trackCallback:NSStringFromSelector(_cmd) state:application.applicationState];

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    NSURL *url = [[NSURL alloc] initWithString:@"https://www.baidu.com"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error) {
            completionHandler(UIBackgroundFetchResultFailed);
            return;
        }

        NSDictionary * jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        NSLog(@"%@",jsonObj);

        BOOL hasNewData = jsonObj == nil;
        if (hasNewData) {
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    }];

    // 开始任务
    [task resume];
}

@end
