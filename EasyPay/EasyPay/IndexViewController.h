//
//  IndexViewController.h
//  EasyPay
//
//  Created by Hank Warren on 5/5/12.
//  Copyright (c) 2012 KGD Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebViewController;
@class VendorListResultDelegate;

@interface IndexViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) NSMutableArray *vendors;
@property (strong, nonatomic) NSMutableData *xmlVendors;
@property (strong, nonatomic) NSURLConnection *connectionInProgress;
@property(strong, nonatomic) WebViewController *webViewController;
@property(strong, nonatomic) NSMutableString *xmlCharacters;
@property(strong, nonatomic) NSMutableString *vendorString;
@property(strong, nonatomic) VendorListResultDelegate *vendorList;
-(void)loadVendors;
@end
