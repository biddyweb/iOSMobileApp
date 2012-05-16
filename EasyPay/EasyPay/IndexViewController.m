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
#import "Vendor.h"

@interface IndexViewController ()

@end

@implementation IndexViewController
@synthesize tableView;
@synthesize activityIndicatorView;
@synthesize vendors;
@synthesize connectionInProgress;
@synthesize xmlVendors;
@synthesize webViewController;
@synthesize xmlCharacters;
@synthesize vendorString;
@synthesize vendorList;


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
    NSString *v = [[vendorList objectAtIndex:[indexPath row]] Name];
    // MyLog( @"Vendor: %@", v );
    [[cell textLabel] setText:v];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [vendorList count];
}

#pragma mark - UITableViewDataSource (optional)

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Vendor *v = [vendorList objectAtIndex:[indexPath row]];
    MyLog( @"selected %@", [v Name] );
}

/*
 * The following messages constitute the xml parser call backs; the joy of SAX.
 * I use two instances of the parser, but only one delegate. The second instance is
 * used to parse the embedded message. The tags for the different xml documents
 * are blended here, but hopefully I can keep them separated.
 */
#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
//    MyLog( @"didStartElement: %@", elementName );
//    NSString *key;
//    for(key in attributeDict){
//        MyLog(@"Key: %@, Value %@", key, [attributeDict objectForKey: key]);
//    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
//    MyLog( @"didEndElement: %@", elementName );
    if( [elementName isEqualToString:@"VendorListResult"] ) {
        vendorString = [NSString stringWithString:xmlCharacters];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [xmlCharacters appendString:string];
}

/* The following implement the connection call backs. */

#pragma mark - Connection delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    MyLog( @"didReceiveData" );
    [xmlVendors appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *xmlCheck = [[NSString alloc] initWithData:xmlVendors
                                                encoding:NSUTF8StringEncoding];
//    MyLog( @"xmlCheck = %@", xmlCheck );
    [activityIndicatorView stopAnimating];
    
    NSRange range = [xmlCheck rangeOfString:@"<html>"];
    if( range.length ) {    // maybe this is html - so display it.
        MyLog( @"<html> at %d and %d characters long", range.location, range.length );

        if( !webViewController ) {
            webViewController = [[WebViewController alloc] init];
        }
        [[self navigationController] pushViewController:webViewController
                                               animated:YES];
        [webViewController setPage:xmlCheck];
    }

    // Parse the xml...
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlVendors];
    [parser setDelegate:self];
    [parser parse];
    
//    MyLog( @"vendorString: %@", vendorString );
    
    vendorList = [[VendorListResultDelegate alloc] init];
    parser = [[NSXMLParser alloc] initWithData:[vendorString dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:vendorList];
    [parser parse];
//    [vendorList printArray];
    [tableView reloadData];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    connectionInProgress = nil;
    xmlVendors = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:errorString
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil
                                                     otherButtonTitles:nil];
    [actionSheet showInView:[[self view] window]];
    [activityIndicatorView stopAnimating];
}

/*
 * Setup the connection stuff and start the connection to get the
 * list of vendors.
 */
-(void)loadVendors {
    [vendors removeAllObjects];
    [tableView reloadData];
    NSString *msg =
    @"<?xml version='1.0' encoding='utf-8'?>"
    @"<soap:Envelope "
    @"xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' "
    @"xmlns:xsd='http://www.w3.org/2001/XMLSchema' "
    @"xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>"
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
    xmlVendors = [[NSMutableData alloc] init];

    connectionInProgress = [[NSURLConnection alloc] initWithRequest:req
                                                           delegate:self
                                                   startImmediately:YES];
    MyLog( @"connection started" );
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
        self.navigationItem.title = @"Vendor List";
        
        vendors = [[NSMutableArray alloc] init];
        xmlCharacters = [[NSMutableString alloc] init];
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
