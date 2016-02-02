//
//  AppDelegate.m
//  cutImageIOS
//
//  Created by vk on 15/8/21.
//  Copyright (c) 2015年 Clover. All rights reserved.
//

#import "AppDelegate.h"
#import "CreatNailRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    CreatNailRootViewController *cnc = [[CreatNailRootViewController alloc]init];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:cnc];
    self.window.rootViewController = nc;
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupRootViewControllerForWindow{
    
    UIViewController *vc1 = [CreatNailRootViewController new];
        UINavigationController *navCon1 =  [[UINavigationController alloc]initWithRootViewController:vc1];
        
    //    UIViewController *vc2 = [ViewController new];
//    UINavigationController *navCon2 =
//    [[UINavigationController alloc] initWithRootViewController:vc2];
//    
//    UIViewController *vc3 = [ViewController new];
//    UINavigationController *navCon3 =
//    [[UINavigationController alloc] initWithRootViewController:vc3];
    
   // self.swipeBetweenVC.viewControllers = @[navCon1, navCon2, navCon3];
    //self.swipeBetweenVC.viewControllers = @[navCon1];
    //self.swipeBetweenVC.initialViewControllerIndex = self.swipeBetweenVC.viewControllers.count/2;
    
}



@end
