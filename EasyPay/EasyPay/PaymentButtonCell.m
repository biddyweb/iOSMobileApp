//
//  PaymentButtonCell.m
//  EasyPay
//
//  Created by Hank Warren on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaymentButtonCell.h"

@implementation PaymentButtonCell
@synthesize paymentButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog( @"PaymentButtonCell:initWithStyle" );
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        paymentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [paymentButton setFrame:CGRectZero];
        [paymentButton setTitle:@"Make Payment" forState:UIControlStateNormal];
        
        [[self contentView] addSubview:paymentButton];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = [[self contentView] bounds];
    NSLog( @"paymentButtonCell bounds: %f, %f %f X %f", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height );
    bounds.origin.x += 4;
    bounds.origin.y += 2;
    bounds.size.width -= 8;
    bounds.size.height -= 4;
    [paymentButton setFrame:bounds];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
