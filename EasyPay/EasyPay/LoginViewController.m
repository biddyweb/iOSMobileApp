//
//  KGDViewController.m
//  EasyPay
//
//  Created by Hank Warren on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "ValidateLoginResultDelegate.h"
#import "LoginDelegate.h"
#import "PaymentTableViewController.h"
#import "TextViewController.h"


@implementation LoginViewController
@synthesize vendorLabel;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize vendorString;
@synthesize vendorIDString;
@synthesize validatedLoginString;
@synthesize errorLabel;

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if( textField == usernameTextField ) {
        MyLog( @"got the username" );
    } else if( textField == passwordTextField ) {
        MyLog( @"validate username/password" );
        [textField resignFirstResponder];
        [self validateLogin];
    }
    return YES;
}

#pragma mark - Notification handlers
-(void)scrollForKeyboardLayout:(NSNotification *)notification {
    UIScrollView *sc = (UIScrollView *)self.view;
    float y = self.vendorLabel.frame.origin.y + self.vendorLabel.frame.size.height;
    CGPoint top = CGPointMake( 0, y );
    [sc setContentOffset:top animated:YES];
}

-(void)returnToNormalLayout:(NSNotification *)notification {
    UIScrollView *sc = (UIScrollView *)self.view;
    [sc setContentOffset:CGPointZero animated:YES];
}


-(void)validateLogin {
    NSString *usernameString = [usernameTextField text];
    NSString *passwordString = [passwordTextField text];
    if( [usernameString length] == 0 || [passwordString length] == 0 ) {
        NSMutableString *msg = [[NSMutableString alloc] init];
        [msg appendString:@"Login failed; "];
        [msg appendString:@"username and/or password are blank"];

        [errorLabel setText:msg];
        [errorLabel setHidden:NO];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:
                     @"<?xml version='1.0' encoding='utf-8'?>\n"
                     @"<soap:Envelope"
                     @" xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'"
                     @" xmlns:xsd='http://www.w3.org/2001/XMLSchema'"
                     @" xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>\n"
                     @"<soap:Body>"
                     @"<ValidateLogin xmlns='http://autopayments.com/'>"
                     @"<vendorId>%@</vendorId>"
                     @"<userName>%@</userName>"
                     @"<password>%@</password>"
                     @"<applicationVersion>3.0.0</applicationVersion>"
                     @"</ValidateLogin>"
                     @"</soap:Body>"
                     @"</soap:Envelope>", vendorIDString,
                     usernameString,
                     passwordString];

    NSURL *url = [NSURL URLWithString:
                  @"https://mobile.autopayments.com/"
                  @"MobileClientRsc/MobileClientRsc.asmx"
                  @"?op=ValidateLogin"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:30];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [msg length]];
    
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req addValue:@"http://autopayments.com/ValidateLogin" forHTTPHeaderField:@"SOAPAction"];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[msg dataUsingEncoding:NSUTF8StringEncoding]];

    MyLog( @"validateLogin: %@", msg );
    xmlData = NULL;
    xmlData = [[NSMutableData alloc] init];

    if( connectionInProgress ) {
        [connectionInProgress cancel];
    }
    connectionInProgress = [[NSURLConnection alloc] initWithRequest:req
                                                           delegate:self
                                                   startImmediately:YES];
    MyLog( @"validateLogin - connection started" );
}
/* The following implement the connection call backs. */

#pragma mark - Connection delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //MyLog( @"LoginViewController - didReceiveData" );
    [xmlData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSString *xmlCheck = [[NSString alloc] initWithData:xmlData
//                                               encoding:NSUTF8StringEncoding];
//    MyLog( @"LoginViewController - xmlCheck = %@", xmlCheck );

    // The message comes in 2 parts. The first XML document is a wrapper for a
    // second XML document.
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    validateLoginResultDelegate = [[ValidateLoginResultDelegate alloc] init];
    [parser setDelegate:validateLoginResultDelegate];
    [parser parse];
    
    // Now parse the second XML document. This one has the actual login information.
    loginDelegate = [[LoginDelegate alloc] init];
    NSString *str = [validateLoginResultDelegate validateLoginResultString];
    MyLog( @"***********************" );
    MyLog( @"validataLoginResultString: %@", str );
    parser = [[NSXMLParser alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:loginDelegate];
    [parser parse];
    
    NSString *lh = [loginDelegate loginHash];

    if( [lh length] == 0 ) {
        NSMutableString *msg = [[NSMutableString alloc] init];
        if( [loginDelegate errorMessage] ) {
            [msg appendString:@"Login failed; "];
            [msg appendString:loginDelegate.assistanceMessage];
            [msg appendString:@"\n"];
            if( [loginDelegate.customerServicePhoneNumber length] > 0 ) {
                [msg appendString:@"Customer Service Phone Number:\n"];
                [msg appendString:loginDelegate.customerServicePhoneNumber];
            }
        } else {
            [msg appendString:@"Login failed: You are on your own."];
        }
        [errorLabel setText:msg];
        [errorLabel setHidden:NO];
        
        // Login failed, so we can expect another poke at the the password field.
        // leave the username alone, although it might be wrong too.
        [passwordTextField setText:@""];
    } else {
        [errorLabel setHidden:YES];

        //MyLog( @"login was successful" );
        PaymentTableViewController *paymentTableViewController = [[PaymentTableViewController alloc] init];
        [paymentTableViewController setLoginDelegate:loginDelegate];
        [[self navigationController] pushViewController:paymentTableViewController
                                               animated:YES];
        //MyLog( @"validateLogin: %@", [validateLoginResultDelegate validateLoginResultString] );
    }
    
    //    [activityIndicatorView stopAnimating];
//    
//    // We now have the list of vendors, so reload the table
//    [tableView reloadData];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    connectionInProgress = nil;
    xmlData = nil;
    
    //    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
    //                             [error localizedDescription]];
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:errorString
    //                                                             delegate:nil
    //                                                    cancelButtonTitle:@"OK"
    //                                               destructiveButtonTitle:nil
    //                                                    otherButtonTitles:nil];
    //    [actionSheet showInView:[[self view] window]];
    //    [activityIndicatorView stopAnimating];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [vendorLabel setText:vendorString];
    [usernameTextField setText:@""];
    [passwordTextField setText:@""];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    MyLog( @"LoginViewController - viewDidLoad" );
    UIScrollView *sc = (UIScrollView *)self.view;
    float width = sc.bounds.size.width;
    float height = self.passwordTextField.frame.origin.y + self.passwordTextField.frame.size.height + 20.0;
    sc.contentSize = CGSizeMake( width, height );
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollForKeyboardLayout:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(returnToNormalLayout:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
