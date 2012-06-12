//
//  PaymentTableViewController.m
//  EasyPay
//
//  Created by Hank Warren on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaymentTableViewController.h"
#import "PaymentMethodCell.h"
#import "PaymentAmountCell.h"
#import "EditablePaymentAmountCell.h"
#import "PaymentDateCell.h"
#import "LoginDelegate.h"
#import "PaymentMethod.h"
#import "Bill.h"


#define PAYMENT_METHOD 0
#define PAYMENT_AMOUNT 1
#define PAYMENT_DATE 2


@implementation PaymentTableViewController
@synthesize loginDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
            rows = [array count] + 3;
        } break;
        case PAYMENT_DATE: {
            rows = 1;
        } break;
    }

    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // MyLog( @"cellForRowAtIndexPath section:%d row:%d", [indexPath section], [indexPath row] );
    UITableViewCell *cell;
    
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
            pmc.accountNameLabel.text = [meth accountName];
            pmc.accountDescriptionLabel.text = [meth accountDescription];
            [[pmc ccvTextField] setDelegate:self];
            return pmc;
        } break;
        case PAYMENT_AMOUNT: {
            NSMutableArray *array = [loginDelegate billArray];
            int row = [indexPath row];
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
                [label setText:[bill totalDueDisplay]];
                cell = pac;
            } else if( row == count ) {
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
            } else if( row == count+1 ) {
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
            } else if( row == count+2 ) {
                PaymentAmountCell *pac = [tv dequeueReusableCellWithIdentifier:@"PaymentAmountCell"];
                if( !pac ) {
                    pac = [[PaymentAmountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"PaymentAmountCell"];
                }
                UILabel *label = [pac accountNumberLabel];
                [label setText:@"Total"];
                
                [[pac dueDateLabel] setText:@""];
                
                label = [pac totalLabel];
                [label setText:@"$50.00"];
                cell = pac;
            }
        } break;
        case PAYMENT_DATE: {
            PaymentDateCell *pdc = [tv dequeueReusableCellWithIdentifier:@"PaymentDateCell"];

            if( !cell ) {
                pdc = [[PaymentDateCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"PaymentDateCell"];
            }
            return pdc;
        } break;
    }    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *str;
    switch( section ) {
        case PAYMENT_METHOD: str = @"PaymentMethod"; break;
        case PAYMENT_AMOUNT: str = @"Account     Due Date     Amount"; break;
        case PAYMENT_DATE: str = @"Payment Date"; break;
    }
    return str;
}

#pragma mark - TableView Delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 0.0;
    switch( [indexPath section] ) {
        case PAYMENT_METHOD: h = 88.0; break;
        case PAYMENT_AMOUNT: h = 30.0; break;
        case PAYMENT_DATE: h = 216.0; break;
    }
    return h;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

// handle the CCV UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
