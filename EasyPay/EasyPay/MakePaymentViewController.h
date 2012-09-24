//
//  MakePaymentViewController.h
//  EasyPay
//
//  Created by Hank Warren on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginDelegate;

@interface MakePaymentViewController : UIViewController <UITextFieldDelegate> {
    NSMutableData *xmlData;
}
@property(strong, nonatomic) NSURLConnection *connectionInProgress;
@property(strong,nonatomic) LoginDelegate *loginDelegate;
@property(strong,nonatomic) IBOutlet UILabel *accountNameLabel;
@property(strong,nonatomic) IBOutlet UILabel *paymentAmountLabel;
@property(strong,nonatomic) IBOutlet UITextField *ccvTextField;

-(IBAction)confirmButtonAction:(id)sender;

@end
