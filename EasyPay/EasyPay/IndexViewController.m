//
//  IndexViewController.m
//  EasyPay
//
//  Created by Hank Warren on 5/5/12.
//  Copyright (c) 2012 KGD Software. All rights reserved.
//

#import "IndexViewController.h"
#import "WebViewController.h"
#import "VendorListResultDelegate.h"
#import "VendorListDelegate.h"
#import "LoginViewController.h"
#import "Vendor.h"


@implementation IndexViewController
@synthesize tableView;
@synthesize activityIndicatorView;
@synthesize webViewController;
@synthesize loginViewController;
@synthesize connectionInProgress;

/* The pragmas are used for Xcode navigation. */

/* The UITableViewDataSource and UITableViewDataSource are protocols. The messages implemented
 here are used to fill the table in the opening screen.
 */
#pragma mark - UITableViewDataSource (required)
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"VendorCell"];
    if( !cell ) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"VendorCell"];
    }
    
    // Load the cell with data
    NSString *v = [[vendorListResultDelegate objectAtIndex:[indexPath row]] Name];
    // MyLog( @"Vendor: %@", v );
    [[cell textLabel] setNumberOfLines:2];
    [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
    [[cell textLabel] setText:v];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [vendorListResultDelegate count];
}
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tv rowHeight] * 1.25;
}
#pragma mark - UITableViewDataSource (optional)

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Vendor *v = [vendorListResultDelegate objectAtIndex:[indexPath row]];
    MyLog( @"selected %@", [v Name] );
    if( !loginViewController ) {
        loginViewController = [[LoginViewController alloc] init];
    }
    [loginViewController setVendorString:[v Name]];
    [loginViewController setVendorIDString:[v ID]];
    [[self navigationController] pushViewController:loginViewController
                                           animated:YES];
}

/*
 * Setup the connection stuff and start the connection to get the
 * list of vendors.
 */
-(void)loadVendors {
    NSString *msg =
    @"<?xml version='1.0' encoding='utf-8'?>"
    @"<soap:Envelope"
    @" xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'"
    @" xmlns:xsd='http://www.w3.org/2001/XMLSchema'"
    @" xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>"
    @"<soap:Body>"
    @"<VendorList xmlns='http://autopayments.com/'>"
    @"<appUserName>VqeJpd7OYVsYd0xl4POkmEfLpiHia1gA6rpwCKB0Mss=</appUserName>"
    @"<appPassword>9U2kUdr+OXcG9KKqgDl2ded1xCtprT/F5utk8ly4mjg=</appPassword>"
    @"</VendorList>"
    @"</soap:Body>"
    @"</soap:Envelope>";
    
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
    MyLog( @"didReceiveData" );
    [xmlData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSString *xmlCheck = [[NSString alloc] initWithData:xmlData
//                                               encoding:NSUTF8StringEncoding];
//    MyLog( @"xmlCheck = %@", xmlCheck );
    
    
    
    //    NSRange range = [xmlCheck rangeOfString:@"<html>"];
    //    if( range.length ) {    // maybe this is html - so display it.
    //        MyLog( @"<html> at %d and %d characters long", range.location, range.length );
    //        
    //        if( !webViewController ) {
    //            webViewController = [[WebViewController alloc] init];
    //        }
    //        [[self navigationController] pushViewController:webViewController
    //                                               animated:YES];
    //        [webViewController setPage:xmlCheck];
    //    }

    
    // Parse the xml...
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    vendorListDelegate = [[VendorListDelegate alloc] init];
    [parser setDelegate:vendorListDelegate];
    [parser parse];
    
//    MyLog( @"vendorListResultString: %@", [vendorListDelegate vendorListResultString] );

    // Now parse the vendorListResultString
    parser = [[NSXMLParser alloc]
              initWithData:[[vendorListDelegate vendorListResultString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Use a different parser delegate for this blob of xml
    vendorListResultDelegate = [[VendorListResultDelegate alloc] init];
    [parser setDelegate:vendorListResultDelegate];
    [parser parse];
    //    [vendorList printArray];
    
    [activityIndicatorView stopAnimating];
    if( [vendorListResultDelegate fault] ) {
        MyLog( @"error: %@", [vendorListResultDelegate errorMessage] );
    } else {
        // We now have the list of vendors, so reload the table
        [tableView reloadData];
    }
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

/*
 * the rest is life cycle stuff for this view controller.
 */
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadVendors];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        MyLog( @"initWithNibName %@", nibNameOrNil );
        self.navigationItem.title = @"Easy 2 Pay";
        xmlData = [[NSMutableData alloc] init];
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
