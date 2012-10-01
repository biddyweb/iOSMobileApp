//
//  DefaultPaymentMethodViewController.m
//  EasyPay
//
//  Created by Hank Warren on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DefaultPaymentMethodViewController.h"
#import "LoginDelegate.h"
#import "PaymentMethod.h"


@implementation DefaultPaymentMethodViewController
@synthesize loginDelegate;
@synthesize paymentMethodIndex;


-(IBAction)makeDefaultAction:(id)sender {
    PaymentMethod *meth = [loginDelegate defaultPaymentMethod];
    [meth setDefaultMethod:FALSE];      // clear the previous default
    
    NSMutableArray *array = [loginDelegate paymentMethodArray];
    meth = [array objectAtIndex:paymentMethodIndex];
    [loginDelegate setDefaultPaymentMethod:meth];
    [meth setDefaultMethod:TRUE];       // set the current default
    
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction)cancelAction:(id)sender {
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
