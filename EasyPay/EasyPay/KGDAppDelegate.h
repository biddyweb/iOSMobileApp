//
//  KGDAppDelegate.h
//  EasyPay
//
//  Created by Hank Warren on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndexViewController;

@interface KGDAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IndexViewController *indexViewController;
@property (strong, nonatomic) UINavigationController *navController;
@end
