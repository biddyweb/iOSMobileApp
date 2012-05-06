//
//  WebViewController.h
//  EasyPay
//
//  Created by Hank Warren on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property(strong, nonatomic) IBOutlet UIWebView *webView;
@property(strong, nonatomic) NSString *page;

-(void)setPage:(NSString *)data;
@end
