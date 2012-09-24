//
//  ContributionViewController.h
//  EasyPay
//
//  Created by Hank Warren on 9/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginDelegate;

@interface ContributionViewController : UIViewController <UITextFieldDelegate>
@property (strong,nonatomic) LoginDelegate *loginDelegate;

-(IBAction) doneButton:(id)sender;

@end
