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

@interface PaymentTableViewController : UITableViewController <NSXMLParserDelegate> {
    float transactionFee;
    BOOL transactionFeeCharged;
    BOOL contribution;
    float contributionAmount;
    int transactionFeeRow;
    int contributionRow;
    int totalRow;
    int makePaymentRow;
    
    NSMutableString *xmlCharacters;
}
@property(strong,nonatomic) LoginDelegate *loginDelegate;
@property(strong, nonatomic) NSURLConnection *connectionInProgress;
@property(nonatomic) float transactionFeeAmount;

-(void)calculateTransactionFeeFor:(float)amountPaid
               contributionAmount:(float)contributionAmount
                   discountAmount:(float)discountAmount
                       businessId:(int)businessId
                  paymentMethodId:(int)paymentMethodId;

@end
