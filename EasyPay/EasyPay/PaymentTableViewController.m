//
//  PaymentTableViewController.m
//  EasyPay
//
//  Created by Hank Warren on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaymentTableViewController.h"
#import "PaymentDateViewController.h"
#import "SelectPaymentMethodTableViewController.h"
#import "ContributionViewController.h"
#import "PaymentAmountCell.h"
#import "LoginDelegate.h"
#import "Bill.h"
#import "Bills.h"
#import "util.h"



@implementation PaymentTableViewController
@synthesize loginDelegate;
@synthesize connectionInProgress;
@synthesize transactionFeeAmount;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        transactionFee = FALSE;
        contribution = FALSE;
        contributionRow = 0;
        transactionFeeRow = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    NSMutableArray *array = [loginDelegate billArray];
    int rows = [array count];   // plus 1 for the total
    Bills *bills = [loginDelegate bills];
    if( [bills maximumContribution] > 0.0 ) {
        contribution = TRUE;
        contributionRow = rows;
        rows++;
    }
    
    if( [bills transactionFeeCreditCard] > 0.0
       || [bills transactionFeeEFT] > 0.0
       || [bills transactionFeeEFTPercent] > 0.0
       || [bills transactionFeeCreditCardPercent] > 0.0 ) {
        transactionFee = TRUE;
        transactionFeeRow = rows;
        rows++;
    }
    totalRow = rows;
    rows++;
    makePaymentRow = rows;
    rows++;
    
//    MyLog( @"%d rows  c: %d tr: %d to: %d", rows, contributionRow, transactionFeeRow, totalRow );
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];

//    MyLog( @"cellForRowAtIndexPath row:%d", row );
    static NSString *cellIdentifier = @"PaymentAmountCell";
    
    if( row == makePaymentRow ) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"UITableViewCell"];
        Bills *bills = [loginDelegate bills];
        if( [bills paymentPending] ) {
            [[cell textLabel] setText:@"Payment Pending"];
        } else {
            [[cell textLabel] setText:@"Make Payment"];
        }
        return cell;
        
    } else {
        PaymentAmountCell *pac;
        pac = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if( !pac ) {
            pac = [[PaymentAmountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cellIdentifier];
        }

        NSMutableArray *array = [loginDelegate billArray];
        int count = [array count];
        if( row < count ) {
            Bill *bill = [array objectAtIndex:[indexPath row]];
        
            UILabel *label = [pac accountNumberLabel];
            [label setText:[bill accountNumberDisplay]];
        
            label = [pac dueDateLabel];
            NSString *str = [bill dueDate];
            NSArray *array = [str componentsSeparatedByString:@" "];
            [label setText:[array objectAtIndex:0]];
        
            label = [pac totalLabel];
            [label setText:[NSString stringWithFormat:@"$%.2f", [bill totalDue]]];
            [pac setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        } else if( row == contributionRow ) {
            Bills *bills = [loginDelegate bills];
            
            UILabel *label = [pac accountNumberLabel];
            [label setText:@"Contribution"];
            
            label = [pac dueDateLabel];
            [label setText:@""];
            
            label = [pac totalLabel];
            NSString *str = [NSString stringWithFormat:@"%.2f", [bills contribution] ];
            [label setText:str];
            [pac setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
        } else if( row == transactionFeeRow ) {
            //Bills *bills = [loginDelegate bills];
            
            UILabel *label = [pac accountNumberLabel];
            [label setText:@"Fee"];
            
            label = [pac dueDateLabel];
            [label setText:@""];
            
            label = [pac totalLabel];
            [label setText:@""];
            
        } else if( row == totalRow ) {
            Bills *bills = [loginDelegate bills];
            
            float total = 0.0;
            for( Bill *b in array ) {
                total += [b totalDue];
            }
            if( contributionRow ) {
                total += [bills contribution];
            }
            if( transactionFeeRow ) {
                total += [bills transactionFee];
            }
            [loginDelegate setPaymentTotal:total];
            
            UILabel *label = [pac accountNumberLabel];
            [label setText:@"Total"];
            
            [[pac dueDateLabel] setText:@""];
            
            label = [pac totalLabel];
            [label setText:[NSString stringWithFormat:@"$%.2f", total]];
            
        } else {
            MyLog( @"some other row" );
        }
        return pac;
    }
}
    
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Account    Due Date         Amount";
}

#pragma mark - TableView Delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PaymentAmountCell cellHeight];
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
//    NSLog( @"didSelectRowAtIndexPath - row: %d", row );
    
    NSArray *array = [loginDelegate billArray];
    if( row < [array count] ) {
        Bill *bill = [array objectAtIndex:row];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
        NSDate *d = [df dateFromString:[bill dueDate]];
        
        PaymentDateViewController *paymentDateViewController = [[PaymentDateViewController alloc] init];
        [paymentDateViewController setLoginDelegate:loginDelegate];
        [paymentDateViewController setDate:d];
        [paymentDateViewController setBillIndex:row];
        [[self navigationController] pushViewController:paymentDateViewController
                                               animated:YES];
    } else if( row == contributionRow ) {
        ContributionViewController *contributionViewController = [[ContributionViewController alloc] init];
        [contributionViewController setLoginDelegate:loginDelegate];
        [[self navigationController] pushViewController:contributionViewController
                                               animated:YES];
    } else if( row == makePaymentRow ) {
        Bills *bills = [loginDelegate bills];
        if( ![bills paymentPending] ) {
            SelectPaymentMethodTableViewController *selectPaymentMethodTableViewController = [[SelectPaymentMethodTableViewController alloc] init];
            [selectPaymentMethodTableViewController setLoginDelegate:loginDelegate];
            [[self navigationController] pushViewController:selectPaymentMethodTableViewController
                                                   animated:YES];
        }
    }
}


/*
 POST /MobileClientRsc/MobileClientRsc.asmx HTTP/1.1
 Host: mobile.autopayments.com
 Content-Type: text/xml; charset=utf-8
 Content-Length: length
 SOAPAction: "http://autopayments.com/CalculateTransactionFee"
 
 <CalculateTransactionFee xmlns="http://autopayments.com/">
 <amountPaid>decimal</amountPaid>
 <contributionAmount>decimal</contributionAmount>
 <discountAmount>decimal</discountAmount>
 <businessId>long</businessId>
 <paymentMethodId>long</paymentMethodId>
 </CalculateTransactionFee>
 */

#pragma mark - CalculateTransactionFee support

-(void)calculateTransactionFeeFor:(float)amountPaid
               contributionAmount:(float)contribAmount
                   discountAmount:(float)discountAmount
                       businessId:(int)businessId
                  paymentMethodId:(int)paymentMethodId {
    NSMutableString *msg = [[NSMutableString alloc] init];
    
    [msg appendString:@"<?xml version='1.0' encoding='utf-8'?>"
     @"<soap:Envelope"
     @" xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'"
     @" xmlns:xsd='http://www.w3.org/2001/XMLSchema'"
     @" xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>"
     @"<soap:Body>"
     @"<CalculateTransactionFee xmlns='http://autopayments.com/'>"];
    [msg appendString:floatField( @"amountPaid", amountPaid ) ];
    [msg appendString:floatField( @"contributionAmount", contribAmount ) ];
    [msg appendString:floatField( @"discountAmount", discountAmount ) ];
    [msg appendString:intField( @"businessId", businessId ) ];
    [msg appendString:intField( @"paymentMethodId", paymentMethodId ) ];
    
    [msg appendString:@"</CalculateTransactionFee>"
     @"</soap:Body>"
     @"</soap:Envelope>"];
    
    NSURL *url = [NSURL URLWithString:
                  @"https://mobile.autopayments.com"
                  @"/MobileClientRsc/MobileClientRsc.asmx"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:30];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [msg length]];
    
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    
    xmlData = [[NSMutableData alloc] init];
    
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
    NSString* newStr = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    MyLog( @"didReceiveData %@", newStr );
    
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
    [parser setDelegate:self];
    [parser parse];
    
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
 * The following messages constitute the xml parser call backs; the joy of SAX.
 */
#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    xmlCharacters = [[NSMutableString alloc] init];
    
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
    if( [elementName isEqualToString:@"CalculateTransactionFeeResult"] ) {
        transactionFee = [xmlCharacters floatValue];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [xmlCharacters appendString:string];    // only used for the VendorListResult tag
}

@end
