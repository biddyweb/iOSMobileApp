//
//  ReceiptViewController.m
//  EasyPay
//
//  Created by Hank Warren on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReceiptViewController.h"


@implementation ReceiptViewController
@synthesize mfMailComposeViewController;

-(IBAction)emailButtonAction:(id)sender {
    if( [MFMailComposeViewController canSendMail] ) {
        mfMailComposeViewController = [[MFMailComposeViewController alloc] init];
        [mfMailComposeViewController setMailComposeDelegate:self];
        [mfMailComposeViewController setSubject:@"Easy 2 Pay receipt"];
        // setToRecipients
        // setCcRecipients
        // setBcRecipients
        // setMessageBody:isHTML:
        // addAttachmentData:mimeType:fileName:
        [self presentModalViewController:mfMailComposeViewController animated:YES];
    }
}
-(IBAction)doneButtonAction:(id)sender {
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

#pragma mark MFMailComposeViewControllerDelegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error {
	MyLog(@"mailComposeController:didFinishWithResult:error");
	switch (result) {
		case MFMailComposeResultCancelled:
            [[self mfMailComposeViewController] dismissViewControllerAnimated:YES completion:NULL];
			break;
		case MFMailComposeResultSaved:
			// If the email is canceled and the draft is saved.
            [[self mfMailComposeViewController] dismissViewControllerAnimated:YES completion:NULL];
			break;
		case MFMailComposeResultSent:
            MyLog( @"mailComposeController - now dismissModelViewController" );
            [[self mfMailComposeViewController] dismissViewControllerAnimated:YES completion:NULL];

            // exit the app -- all the way back to the beginning
			break;
		case MFMailComposeResultFailed: {
			UIAlertView *failed = [[UIAlertView alloc] initWithTitle:@"Email Failed"
															 message:[error description]
															delegate:nil
												   cancelButtonTitle:@"OK"
												   otherButtonTitles:nil];
			[failed show];
		} break;
		default:
			break;
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
