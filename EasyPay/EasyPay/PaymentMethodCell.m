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
@synthesize otherLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        accountNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [accountNameLabel setText:@"first field"];
        accountDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [accountDescriptionLabel setText:@"second field"];
        otherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [otherLabel setText:@"third field"];
        
        [[self contentView] addSubview:accountNameLabel];
        [[self contentView] addSubview:accountDescriptionLabel];
        [[self contentView] addSubview:otherLabel];
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
    CGRect botFrame = CGRectMake( 5.0, top, w, lineHeight );
    
    [accountNameLabel setFrame:topFrame];
    [accountDescriptionLabel setFrame:midFrame];
    [otherLabel setFrame:botFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
