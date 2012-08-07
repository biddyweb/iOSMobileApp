//
//  PaymentDateViewController.h
//  EasyPay
//
//  Created by Hank Warren on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentDateViewController : UIViewController
@property(strong, nonatomic) NSDate *date;
@property(strong, nonatomic) NSString *dateString;
@property(strong, nonatomic) IBOutlet UILabel *dateLabel;
@property(strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property(strong, nonatomic) UIButton *doneButton;
-(IBAction) doneButton:(id)sender;
-(void)setDate:(NSDate *)d;
@end
