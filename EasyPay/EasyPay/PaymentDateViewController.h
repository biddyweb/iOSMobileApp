//
//  PaymentDateViewController.h
//  EasyPay
//
//  Created by Hank Warren on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginDelegate;

@interface PaymentDateViewController : UIViewController <UITextFieldDelegate>
@property(strong, nonatomic) NSDate *date;
@property(strong, nonatomic) NSString *dateString;
@property(strong, nonatomic) IBOutlet UILabel *dateLabel;
@property(strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property(strong, nonatomic) UIButton *doneButton;
@property(strong, nonatomic) IBOutlet UITextField *amountTextField;
@property(strong, nonatomic) LoginDelegate *loginDelegate;
@property(nonatomic) int billIndex;

-(IBAction) doneButton:(id)sender;
@end
