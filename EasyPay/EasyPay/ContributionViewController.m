//
//  ContributionViewController.m
//  EasyPay
//
//  Created by Hank Warren on 9/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContributionViewController.h"
#import "LoginDelegate.h"

@implementation ContributionViewController
@synthesize loginDelegate;

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    MyLog( @"got the contribution %@", [textField text] );
    return YES;
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
