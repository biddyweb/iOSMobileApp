//
//  PaymentDateViewController.m
//  EasyPay
//
//  Created by Hank Warren on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaymentDateViewController.h"
#import "LoginDelegate.h"
#import "Bill.h"


@implementation PaymentDateViewController
@synthesize dateLabel;
@synthesize datePicker;
@synthesize doneButton;
@synthesize date;
@synthesize dateString;
@synthesize amountTextField;
@synthesize loginDelegate;
@synthesize billIndex;


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    MyLog( @"textFieldShouldReturn:" );
    NSArray *billArray = [loginDelegate billArray];
    Bill *bill = [billArray objectAtIndex:billIndex];
    NSString *str = [amountTextField text];
    [bill setTotalDue:[str floatValue]];
    
    [textField resignFirstResponder];
    return NO;
}

-(IBAction)doneButton:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) dateChanged:(id)sender {
    date = [datePicker date];
    
    MyLog( @"dateChanged %@", [date description] );
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian
                                           components:(NSDayCalendarUnit | NSWeekdayCalendarUnit)
                                           fromDate:date];
    NSInteger weekday = [weekdayComponents weekday];
    
    // Only business days
    if( weekday == 1 || weekday == 7 ) {
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];

        if( weekday == 1 ) {
            [offsetComponents setDay:1];    // forward one day to Monday
        }
        if( weekday == 7 ) {
            [offsetComponents setDay:-1];   // back one day to Friday
        }
        NSDate *newdate = [gregorian dateByAddingComponents:offsetComponents
                                                     toDate:date
                                                    options:0];
        [datePicker setDate:newdate];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *str = [df stringFromDate:[datePicker date]];
    // MyLog( @"setDate: %@", str );
    
    NSArray *billArray = [loginDelegate billArray];
    Bill *bill = [billArray objectAtIndex:billIndex];
    [bill setDueDate:str];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // MyLog( @"date: %@", [date description] );
    [datePicker setDate:date animated:YES];
    [dateLabel setText:dateString];
    NSArray *billArray = [loginDelegate billArray];
    Bill *bill = [billArray objectAtIndex:billIndex];
    [amountTextField setText:[NSString stringWithFormat:@"$%.2f", [bill totalDue]]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [datePicker addTarget:self
                   action:@selector(dateChanged:) 
         forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
