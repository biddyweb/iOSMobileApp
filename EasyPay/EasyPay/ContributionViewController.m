//
//  ContributionViewController.m
//  EasyPay
//
//  Created by Hank Warren on 9/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContributionViewController.h"
#import "LoginDelegate.h"
#import "Bills.h"

@implementation ContributionViewController
@synthesize loginDelegate;
@synthesize maximumContributionLabel;
@synthesize contributionTextField;

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *str = [textField text];
    
    Bills *bills = [loginDelegate bills];
    float checkContribution = [str floatValue];
    if( checkContribution < [bills maximumContribution] ) {
        [bills setContribution:[str floatValue] ];
        str = [NSString stringWithFormat:@"$%.2f", [bills contribution] ];
        [textField setText:str];
        [textField resignFirstResponder];
        return YES;
    }
    [textField setText:@""];
    return NO;
}


-(IBAction)doneButton:(id)sender {
    MyLog( @"doneButton" );
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
    Bills *bills = [loginDelegate bills];
    
    NSString *str = [NSString stringWithFormat:@"%.2f", [bills maximumContribution] ];
    [maximumContributionLabel setText:str];

    str = [NSString stringWithFormat:@"%.2F", [bills contribution] ];
    [contributionTextField setText:str];
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
