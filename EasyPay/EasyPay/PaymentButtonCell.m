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
        paymentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [paymentButton setTitle:@"Make Payment" forState:UIControlStateNormal];
        
        [[self contentView] addSubview:paymentButton];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = [[self contentView] bounds];
    NSLog( @"paymentButtonCell bounds: %f, %f %f X %f", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height );
    [paymentButton setFrame:bounds];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
