//
//  PaymentTableViewController.m
//  EasyPay
//
//  Created by Hank Warren on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaymentTableViewController.h"
#import "PaymentMethodCell.h"
#import "LoginDelegate.h"
#import "PaymentMethod.h"


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
            rows = [array count];
        } break;
        case PAYMENT_DATE: {
            rows = 2;
        } break;
    }

    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLog( @"cellForRowAtIndexPath section:%d row:%d", [indexPath section], [indexPath row] );
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
            return pmc;
        } break;
        case PAYMENT_AMOUNT: {
            cell = [tv dequeueReusableCellWithIdentifier:@"Cell"];

            if( !cell ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"Cell"];
            }
            [[cell textLabel] setText:@"Payment amount"];
        } break;
        case PAYMENT_DATE: {
            cell = [tv dequeueReusableCellWithIdentifier:@"Cell"];

            if( !cell ) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"Cell"];
            }
            [[cell textLabel] setText:@"Payment date"];
        } break;
    }    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *str;
    switch( section ) {
        case PAYMENT_METHOD: str = @"PaymentMethod"; break;
        case PAYMENT_AMOUNT: str = @"Paymount Amount"; break;
        case PAYMENT_DATE: str = @"Payment Date"; break;
    }
    return str;
}

#pragma mark - TableView Delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 0.0;
    switch( [indexPath section] ) {
        case PAYMENT_METHOD: h = 88.0; break;
        case PAYMENT_AMOUNT: h = 66.0; break;
        case PAYMENT_DATE: h = 44.0; break;
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

@end
