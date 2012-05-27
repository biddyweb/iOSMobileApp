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
#import "TextViewController.h"


@implementation LoginViewController
@synthesize vendorLabel;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize vendorString;
@synthesize vendorIDString;
@synthesize validatedLoginString;

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
                     [usernameTextField text],
                     [passwordTextField text]];

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
    MyLog( @"LoginViewController - didReceiveData" );
    [xmlData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSString *xmlCheck = [[NSString alloc] initWithData:xmlData
//                                               encoding:NSUTF8StringEncoding];
//    MyLog( @"LoginViewController - xmlCheck = %@", xmlCheck );

    // Parse the xml...
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    validateLoginResultDelegate = [[ValidateLoginResultDelegate alloc] init];
    [parser setDelegate:validateLoginResultDelegate];
    [parser parse];
    
//    TextViewController *textViewController = [[TextViewController alloc] init];
//    [textViewController setText:[validateLoginResultDelegate validateLoginResultString]];
//    //[[textViewController textView] setText:@"this is a test"];
//    [[self navigationController] pushViewController:textViewController
//                                           animated:YES];
//    MyLog( @"validateLogin: %@", [validateLoginResultDelegate validateLoginResultString] );
    loginDelegate = [[LoginDelegate alloc] init];
    parser = [[NSXMLParser alloc]
              initWithData:[[validateLoginResultDelegate validateLoginResultString]
                            dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:loginDelegate];
    [parser parse];
    
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
        xmlData = [[NSMutableData alloc] init];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [vendorLabel setText:vendorString];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    MyLog( @"LoginViewController - viewDidLoad" );
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
