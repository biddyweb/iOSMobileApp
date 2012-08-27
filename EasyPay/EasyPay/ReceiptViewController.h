//
//  ReceiptViewController.h
//  EasyPay
//
//  Created by Hank Warren on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ReceiptViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property(strong, nonatomic) MFMailComposeViewController *mfMailComposeViewController;
-(IBAction)emailButtonAction:(id)sender;
-(IBAction)doneButtonAction:(id)sender;
@end
