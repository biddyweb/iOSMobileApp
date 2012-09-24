//
//  PaymentTableViewController.m
//  EasyPay
//
//  Created by Hank Warren on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaymentTableViewController.h"
#import "PaymentDateViewController.h"
#import "MakePaymentViewController.h"
#import "DefaultPaymentMethodViewController.h"
#import "ContributionViewController.h"
#import "PaymentMethodCell.h"
#import "PaymentAmountCell.h"
#import "EditablePaymentAmountCell.h"
#import "PaymentDateCell.h"
#import "PaymentButtonCell.h"
#import "LoginDelegate.h"
#import "PaymentMethod.h"
#import "Bill.h"
#import "Bills.h"
#import "util.h"


#define PAYMENT_METHOD 0
#define PAYMENT_AMOUNT 1


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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    switch( section ) {
        case PAYMENT_METHOD: {
            NSMutableArray *array = [loginDelegate paymentMethodArray];
            rows = [array count];
        } break;
        case PAYMENT_AMOUNT: {
            NSMutableArray *array = [loginDelegate billArray];
            rows = [array count];   // plus 1 for the total
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
            MyLog( @"%d rows in PAYMENT_AMOUNT: c: %d tr: %d to: %d", rows, contributionRow, transactionFeeRow, totalRow );
        } break;
    }

    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLog( @"cellForRowAtIndexPath section:%d row:%d", [indexPath section], [indexPath row] );
    UITableViewCell *cell;
    int row = [indexPath row];

    switch( [indexPath section] ) {
        case PAYMENT_METHOD: {
            PaymentMethodCell *pmc;
            pmc = [tv dequeueReusableCellWithIdentifier:@"PaymentMethodCell"];

            if( !pmc ) {
                pmc = [[PaymentMethodCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"PaymentMethodCell"];
            }
            NSMutableArray *array = [loginDelegate paymentMethodArray];
            PaymentMethod *meth = [array objectAtIndex:[indexPath row]];
            if( [meth defaultMethod] == TRUE ) {
                pmc.defaultMethod.text = @"\u2611";
                [loginDelegate setDefaultPaymentMethod:meth];
            } else {
                pmc.defaultMethod.text = @"\u2610";
            }
            pmc.accountNameLabel.text = [meth accountName];
            pmc.accountDescriptionLabel.text = [meth accountDescription];
            //[pmc setAccessoryType:UITableViewCellAccessoryCheckmark];

            return pmc;
        } break;
        case PAYMENT_AMOUNT: {
            NSMutableArray *array = [loginDelegate billArray];
            int count = [array count];
            if( row < count ) {
                PaymentAmountCell *pac = [tv dequeueReusableCellWithIdentifier:@"PaymentAmountCell"];
                if( !pac ) {
                    pac = [[PaymentAmountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"PaymentAmountCell"];
                }

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

                cell = pac;
            } else if( row >= count ) {
                if( row == contributionRow ) {
                    MyLog( @"contributionRow: %d", contributionRow );
                    EditablePaymentAmountCell *epac = [tv dequeueReusableCellWithIdentifier:@"EditablePaymentAmountCell"];
                    if( !epac ) {
                        epac = [[EditablePaymentAmountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"EditablePaymentAmountCell"];
                    }
                    UILabel *label = [epac accountNumberLabel];
                    [label setText:@"Contribution"];
                    
                    label = [epac dueDateLabel];
                    [label setText:@""];
                    
                    UITextField *tf = [epac totalTextField];
                    [tf setText:@"$10.00"];
                    cell = epac;
                } else if( row == transactionFeeRow ) {
                    MyLog( @"transactionFeeRow: %d", transactionFeeRow );
                    PaymentAmountCell *pac = [tv dequeueReusableCellWithIdentifier:@"PaymentAmountCell"];
                    if( !pac ) {
                        pac = [[PaymentAmountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"PaymentAmountCell"];
                    }
                    UILabel *label = [pac accountNumberLabel];
                    [label setText:@"Fee"];
                    
                    label = [pac dueDateLabel];
                    [label setText:@""];
                    
                    label = [pac totalLabel];
                    [label setText:@"$5.00"];
                    cell = pac;
                } else if( row == totalRow ) {
                    MyLog( @"totalRow: %d", totalRow );
                    float total = 0.0;
                    for( Bill *b in array ) {
                        total += [b totalDue];
                    }

                    PaymentAmountCell *pac = [tv dequeueReusableCellWithIdentifier:@"PaymentAmountCell"];
                    if( !pac ) {
                        pac = [[PaymentAmountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:@"PaymentAmountCell"];
                    }
                    UILabel *label = [pac accountNumberLabel];
                    [label setText:@"Total"];
                    
                    [[pac dueDateLabel] setText:@""];
                    
                    label = [pac totalLabel];
                    [label setText:[NSString stringWithFormat:@"$%.2f", total]];
                    cell = pac;
                } else if( row == makePaymentRow ) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"UITableViewCell"];
                    Bills *bills = [loginDelegate bills];
                    if( [bills paymentPending] ) {
                        [[cell textLabel] setText:@"Payment Pending"];
                    } else {
                        [[cell textLabel] setText:@"Make Payment"];
                    }
                } else {
                    MyLog( @"some other row" );
                }
            }
        } break;
    }    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *str;
    switch( section ) {
        case PAYMENT_METHOD: str = @"PaymentMethod"; break;
        case PAYMENT_AMOUNT: str = @"Account    Due Date         Amount"; break;
    }
    return str;
}

#pragma mark - TableView Delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 0.0;
    switch( [indexPath section] ) {
    case PAYMENT_METHOD: h = 88.0; break;
    case PAYMENT_AMOUNT: h = 44.0; break;
    }
    return h;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    NSLog( @"didSelectRowAtIndexPath - section: %d - row: %d", [indexPath section], row );
    if( [indexPath section] == PAYMENT_AMOUNT ) {            
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
                MakePaymentViewController *makePaymentViewController = [[MakePaymentViewController alloc] init];
                [makePaymentViewController setLoginDelegate:loginDelegate];
                [[self navigationController] pushViewController:makePaymentViewController
                                                       animated:YES];
            }
        }
    } else if( [indexPath section] == PAYMENT_METHOD ) {
        DefaultPaymentMethodViewController *defaultPaymentMethodViewController =
        [[DefaultPaymentMethodViewController alloc] init];
        [[self navigationController] pushViewController:defaultPaymentMethodViewController
                                               animated:YES];
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
