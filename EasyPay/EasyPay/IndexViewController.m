//
//  IndexViewController.m
//  EasyPay
//
//  Created by Hank Warren on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IndexViewController.h"
#import "WebViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController
@synthesize tableView;
@synthesize activityIndicatorView;
@synthesize vendors;
@synthesize connectionInProgress;
@synthesize xmlVendors;
@synthesize webViewController;

#pragma mark - UITableViewDataSource (required)
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"VendorCell"];
    if( !cell ) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"VendorCell"];
    }
    
    // Load the cell with data
    [[cell textLabel] setText:@"stuff"];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

#pragma mark - UITableViewDataSource (optional)

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - Connection delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    MyLog( @"didReceiveData" );
    [xmlVendors appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *xmlCheck = [[NSString alloc] initWithData:xmlVendors
                                                encoding:NSUTF8StringEncoding];
//    MyLog( @"xmlCheck = %@", xmlCheck );
    [activityIndicatorView stopAnimating];
    
    NSRange range = [xmlCheck rangeOfString:@"<html>"];
    MyLog( @"<html> at %d and %d characters long", range.location, range.length );
    if( range.length ) {    // maybe this is html - so display it.
        if( !webViewController ) {
            webViewController = [[WebViewController alloc] init];
        }
        [[self navigationController] pushViewController:webViewController
                                               animated:YES];
        [webViewController setPage:xmlCheck];
    }
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
-(void)loadVendors {
    [vendors removeAllObjects];
    [tableView reloadData];
    
    NSURL *url = [NSURL URLWithString:
                  @"https://mobile.autopayments.com/"
                  @"MobileClientRsc/MobileClientRsc.asmx"
                  @"?op=VendorList"
                  @"&Function=VendorList"
                  @"&UserName=9U2kUdr+OXcG9KKqgDl2ded1xCtprT/F5utk8ly4mjg="
                  @"&Password=VqeJpd7OYVsYd0xl4POkmEfLpiHia1gA6rpwCKB0Mss="];
    NSURLRequest *req = [NSURLRequest requestWithURL:url
                                         cachePolicy:NSURLRequestReloadIgnoringCacheData
                                     timeoutInterval:30];
    if( connectionInProgress ) {
        [connectionInProgress cancel];
    }
    xmlVendors = [[NSMutableData alloc] init];

    connectionInProgress = [[NSURLConnection alloc] initWithRequest:req
                                                           delegate:self
                                                   startImmediately:YES];
    MyLog( @"connection started" );
}

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
