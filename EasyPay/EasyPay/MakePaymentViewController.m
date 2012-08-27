//
//  MakePaymentViewController.m
//  EasyPay
//
//  Created by Hank Warren on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MakePaymentViewController.h"
#import "ReceiptViewController.h"


@interface MakePaymentViewController ()

@end

@implementation MakePaymentViewController

-(IBAction)confirmButtonAction:(id)sender {
    ReceiptViewController *receiptViewController = [[ReceiptViewController alloc] init];
    [[self navigationController] pushViewController:receiptViewController
                                           animated:YES];
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