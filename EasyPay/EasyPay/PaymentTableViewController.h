//
//  PaymentTableViewController.h
//  EasyPay
//
//  Created by Hank Warren on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginDelegate;
@class PaymentDateViewController;

@interface PaymentTableViewController : UITableViewController <UITextFieldDelegate> {
    BOOL transactionFee;
    BOOL contribution;
    int transactionFeeRow;
    int contributionRow;
    int totalRow;
}
@property(strong,nonatomic) LoginDelegate *loginDelegate;
@end
