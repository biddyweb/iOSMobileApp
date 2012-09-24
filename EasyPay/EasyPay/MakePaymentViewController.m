//
//  MakePaymentViewController.m
//  EasyPay
//
//  Created by Hank Warren on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MakePaymentViewController.h"
#import "ReceiptViewController.h"
#import "LoginDelegate.h"
#import "Bills.h"
#import "Bill.h"
#import "util.h"


@implementation MakePaymentViewController
@synthesize connectionInProgress;
@synthesize loginDelegate;
@synthesize accountNameLabel;
@synthesize paymentAmountLabel;
@synthesize ccvTextField;

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    MyLog( @"got the ccv %@", [textField text] );
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)confirmButtonAction:(id)sender {
    xmlData = [[NSMutableData alloc] init];\
//    POST /MobileClientRsc/MobileClientRsc.asmx HTTP/1.1
//Host: mobile.autopayments.com
//    Content-Type: text/xml; charset=utf-8
//    Content-Length: length
//SOAPAction: "http://autopayments.com/InitiatePayment"
    NSMutableString *msg = [[NSMutableString alloc] init];
    [msg appendString:
     @"<?xml version'1.0' encoding='utf-8'?>"
     @"<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'"
     @" xmlns:xsd='http://www.w3.org/2001/XMLSchema'"
     @" xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>"
     @"<soap:Body>"
     @"<InitiatePayment xmlns='http://autopayments.com/'>" ];
    [msg appendString:stringField( @"authenticationHash", @"hashisgood" ) ]; // string
    [msg appendString:stringField( @"businessId", @"business id" ) ];        //long
    [msg appendString:stringField( @"customerNumber", @"5678" ) ];    // string
    
    [msg appendString:@"<accountPaymentArray>"];
    Bills *bills = [loginDelegate bills];
    NSArray *billArray = [loginDelegate billArray];
    int count = [billArray count];
    for( int i = 0; i < count; i++ ) {
        Bill *bill = [billArray objectAtIndex:i];
        
        [msg appendString:@"<AccountPayment>"];
        [msg appendString:stringField( @"AccountNumber", @"1234" ) ];     //string
        [msg appendString:floatField( @"AmountDue", 1000000.0 ) ];         // decimal
        [msg appendString:floatField( @"AmountDueCurrent", 2000000.0 ) ];  // decimal
        [msg appendString:floatField( @"AmountDuePrevious", 3000000.0 ) ]; // decimal
        [msg appendString:floatField( @"AmountDueLate", 0.0 ) ];     // decimal
        [msg appendString:stringField( @"DueDate", [bill dueDate] ) ];           // dateTime
        [msg appendString:floatField( @"AmountPaid", [bill totalDue]) ];        // decimal
        [msg appendString:@"</AccountPayment>"];
    }
    [msg appendString:@"</accountPaymentArray>"];
    
    [msg appendString:floatField( @"contributionAmount", [bills contribution] ) ];//decimal
//    [msg appendString:stringField( @"paymentDate", ) ];       // dateTime
//    [msg appendString:stringField( @"paymentMethodId", ) ];   // long
    [msg appendString:stringField( @"ccv2", [ccvTextField text] ) ];                // string
    [msg appendString:
     @"</InitiatePayment>"
     @"</soap:Body"
     @"</soap:Envelope>"];
    
    /*
     NSURL *url = [NSURL URLWithString:
     @"https://mobile.autopayments.com/"
     @"MobileClientRsc/MobileClientRsc.asmx"
     @"?WSDL"];
     */
    NSURL *url = [NSURL URLWithString:
                  @"https://mobile.autopayments.com/"
                  @"MobileClientRsc/MobileClientRsc.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:30];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [msg length]];
    
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    
    if( connectionInProgress ) {
        [connectionInProgress cancel];
    }
    connectionInProgress = [[NSURLConnection alloc] initWithRequest:req
                                                           delegate:self
                                                   startImmediately:YES];
    MyLog( @"connection started" );

}


/* The following implement the connection call backs. */

#pragma mark - Connection delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //    NSString* newStr = [[NSString alloc] initWithData:data
    //                                             encoding:NSUTF8StringEncoding];
    //    MyLog( @"didReceiveData %@", newStr );
    [xmlData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *xmlCheck = [[NSString alloc] initWithData:xmlData
                                               encoding:NSUTF8StringEncoding];
    MyLog( @"xmlCheck = %@", xmlCheck );
    
    ReceiptViewController *receiptViewController = [[ReceiptViewController alloc] init];
    [[self navigationController] pushViewController:receiptViewController
                                           animated:YES];

//    // Parse the xml...
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
//    vendorListDelegate = [[VendorListDelegate alloc] init];
//    [parser setDelegate:vendorListDelegate];
//    [parser parse];
//    
//    //    MyLog( @"vendorListResultString: %@", [vendorListDelegate vendorListResultString] );
//    
//    // Now parse the vendorListResultString
//    parser = [[NSXMLParser alloc]
//              initWithData:[[vendorListDelegate vendorListResultString] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // Use a different parser delegate for this blob of xml
//    vendorListResultDelegate = [[VendorListResultDelegate alloc] init];
//    [parser setDelegate:vendorListResultDelegate];
//    [parser parse];
//    //    [vendorList printArray];
//    
//    [activityIndicatorView stopAnimating];
//    if( [vendorListResultDelegate fault] ) {
//        MyLog( @"error: %@", [vendorListResultDelegate errorMessage] );
//    } else {
//        // We now have the list of vendors, so reload the table
//        [tableView reloadData];
//    }
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Bills *bills = [loginDelegate bills];
    [accountNameLabel setText:[bills accountNumberName]];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
