//
//  IndexViewController.h
//  EasyPay
//
//  Created by Hank Warren on 5/5/12.
//  Copyright (c) 2012 KGD Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebViewController;
@class VendorListDelegate;
@class VendorListResultDelegate;
@class LoginViewController;


@interface IndexViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableData *xmlData;
    VendorListDelegate *vendorListDelegate;
    VendorListResultDelegate *vendorListResultDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSURLConnection *connectionInProgress;

@property(strong, nonatomic) WebViewController *webViewController;
@property(strong, nonatomic) LoginViewController *loginViewController;

-(void)loadVendors;
@end
