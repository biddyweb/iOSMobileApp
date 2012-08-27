//
//  PaymentDateViewController.h
//  EasyPay
//
//  Created by Hank Warren on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentDateViewController : UIViewController <UITextFieldDelegate>
@property(strong, nonatomic) NSDate *date;
@property(strong, nonatomic) NSString *dateString;
@property(strong, nonatomic) IBOutlet UILabel *dateLabel;
@property(strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property(strong, nonatomic) UIButton *doneButton;
@property(strong, nonatomic) IBOutlet UITextField *amountTextField;
@property(nonatomic) float amount;
-(IBAction) doneButton:(id)sender;
@end
