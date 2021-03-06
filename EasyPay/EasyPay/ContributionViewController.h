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
@property (strong,nonatomic) IBOutlet UILabel *maximumContributionLabel;
@property (strong,nonatomic) IBOutlet UITextField *contributionTextField;
-(IBAction) doneButton:(id)sender;

@end
