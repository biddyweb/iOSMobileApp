//
//  PaymentDateViewController.m
//  EasyPay
//
//  Created by Hank Warren on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaymentDateViewController.h"

@interface PaymentDateViewController ()

@end

@implementation PaymentDateViewController
@synthesize dateLabel;
@synthesize datePicker;
@synthesize doneButton;
@synthesize date;
@synthesize dateString;
@synthesize amountTextField;
@synthesize amount;


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)setDate:(NSDate *)d {
    date = d;
}
-(IBAction)doneButton:(id)sender {
    NSLog( @"date Picker done" );
    [[self navigationController] popViewControllerAnimated:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MyLog( @"date: %@", [date description] );
    [datePicker setDate:date animated:YES];
    [dateLabel setText:dateString];
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
