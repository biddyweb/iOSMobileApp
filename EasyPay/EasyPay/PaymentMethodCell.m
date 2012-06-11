//
//  PaymentMethodCell.m
//  EasyPay
//
//  Created by Hank Warren on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaymentMethodCell.h"

@implementation PaymentMethodCell
@synthesize accountNameLabel;
@synthesize accountDescriptionLabel;
@synthesize ccvLabel;
@synthesize ccvTextField;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        accountNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [accountNameLabel setText:@"first field"];
        
        accountDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [accountDescriptionLabel setText:@"second field"];
        
        ccvLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [ccvLabel setText:@"CCV"];
        
        ccvTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        [ccvTextField setText:@""];
        [ccvTextField setBorderStyle:UITextBorderStyleBezel];
        [ccvTextField setClearButtonMode:UITextFieldViewModeAlways];
        
        [[self contentView] addSubview:accountNameLabel];
        [[self contentView] addSubview:accountDescriptionLabel];
        [[self contentView] addSubview:ccvLabel];
        [[self contentView] addSubview:ccvTextField];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = [[self contentView] bounds];
    CGFloat top = 2.0;
    
    float w = bounds.size.width;
    
    UIFont *font = [accountNameLabel font];
    CGFloat lineHeight = [font lineHeight];
    CGRect topFrame = CGRectMake( 5.0, top, w, lineHeight );
    
    top += lineHeight + 4;
    CGRect midFrame = CGRectMake( 5.0, top, w, lineHeight );
    
    top += lineHeight + 4;
    CGRect ccvFrame = CGRectMake( 5.0, top, 50.0, lineHeight+5 );
    CGRect ccvTextFrame = CGRectMake( 55.0, top, 80.0, lineHeight+5 );

    [accountNameLabel setFrame:topFrame];
    [accountDescriptionLabel setFrame:midFrame];
    [ccvLabel setFrame:ccvFrame];
    [ccvTextField setFrame:ccvTextFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
