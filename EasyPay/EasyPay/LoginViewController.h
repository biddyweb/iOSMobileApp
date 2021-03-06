//
//  LoginViewController.h
//  EasyPay
//
//  Created by Hank Warren on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ValidateLoginResultDelegate;
@class LoginDelegate;


@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    NSURLConnection *connectionInProgress;
    NSMutableData *xmlData;
    ValidateLoginResultDelegate *validateLoginResultDelegate;
    LoginDelegate *loginDelegate;
}
@property(strong,nonatomic) IBOutlet UILabel *vendorLabel;
@property(strong,nonatomic) IBOutlet UITextField *usernameTextField;
@property(strong,nonatomic) IBOutlet UITextField *passwordTextField;
@property(strong,nonatomic) IBOutlet UILabel *errorLabel;
@property(strong,nonatomic) IBOutlet UILabel *tapLabel;
@property(strong,nonatomic) IBOutlet UIActivityIndicatorView *verifyIndicator;

@property(strong,nonatomic) NSString *vendorString;
@property(strong,nonatomic) NSString *vendorIDString;
@property(strong,nonatomic) NSString *validatedLoginString;

-(void)validateLogin;
@end
