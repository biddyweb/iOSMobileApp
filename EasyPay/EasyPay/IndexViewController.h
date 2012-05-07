//
//  IndexViewController.h
//  EasyPay
//
//  Created by Hank Warren on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebViewController;

@interface IndexViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) NSMutableArray *vendors;
@property (strong, nonatomic) NSMutableData *xmlVendors;
@property (strong, nonatomic) NSURLConnection *connectionInProgress;
@property(strong, nonatomic) WebViewController *webViewController;

-(void)loadVendors;
@end