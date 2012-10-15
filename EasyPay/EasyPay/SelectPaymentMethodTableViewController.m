//
//  SelectPaymentMethodTableViewController.m
//  EasyPay
//
//  Created by Henri Warren on 10/14/12.
//
//

#import "SelectPaymentMethodTableViewController.h"
#import "MakePaymentViewController.h"
#import "LoginDelegate.h"
#import "PaymentMethodCell.h"
#import "PaymentMethod.h"


@implementation SelectPaymentMethodTableViewController
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = [loginDelegate paymentMethodArray];

    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PaymentMethodCell";

    PaymentMethodCell *pmc;
    pmc = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( !pmc ) {
        pmc = [[PaymentMethodCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier];
    }
    
    NSMutableArray *array = [loginDelegate paymentMethodArray];
    PaymentMethod *meth = [array objectAtIndex:[indexPath row]];
    if( [meth defaultMethod] == TRUE ) {
        pmc.defaultMethod.text = @"\u2611";
    } else {
        pmc.defaultMethod.text = @"\u2610";
    }
    pmc.accountNameLabel.text = [meth accountName];
    pmc.accountDescriptionLabel.text = [meth accountDescription];
    [pmc setAccessoryType:UITableViewCellAccessoryCheckmark];

    return pmc;
}

#pragma mark - TableView Delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PaymentMethodCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [loginDelegate paymentMethodArray];
    [loginDelegate setPaymentMethod:[array objectAtIndex:[indexPath row]]];

    MakePaymentViewController *makePaymentViewController = [[MakePaymentViewController alloc] init];
    [makePaymentViewController setLoginDelegate:loginDelegate];
    [[self navigationController] pushViewController:makePaymentViewController
                                           animated:YES];
}

@end
