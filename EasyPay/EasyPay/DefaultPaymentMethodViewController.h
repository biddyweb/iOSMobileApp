//
//  DefaultPaymentMethodViewController.h
//  EasyPay
//
//  Created by Hank Warren on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginDelegate;

@interface DefaultPaymentMethodViewController : UIViewController
@property(strong,nonatomic) LoginDelegate *loginDelegate;
@property(nonatomic) int paymentMethodIndex;

-(IBAction)makeDefaultAction:(id)sender;
-(IBAction)cancelAction:(id)sender;
@end
