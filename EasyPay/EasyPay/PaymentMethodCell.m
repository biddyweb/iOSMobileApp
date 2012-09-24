//
//  PaymentMethodCell.m
//  EasyPay
//
//  Created by Hank Warren on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaymentMethodCell.h"

@implementation PaymentMethodCell
@synthesize defaultMethod;
@synthesize accountNameLabel;
@synthesize accountDescriptionLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        defaultMethod = [[UILabel alloc] init];
        
        accountNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [accountNameLabel setText:@"first field"];
        
        accountDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [accountDescriptionLabel setText:@"second field"];
                
        [[self contentView] addSubview:defaultMethod];
        [[self contentView] addSubview:accountNameLabel];
        [[self contentView] addSubview:accountDescriptionLabel];
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
    CGRect topFrame = CGRectMake( 35.0, top, w-30.0, lineHeight );
    CGRect topLeftFrame = CGRectMake( 5.0, top, 30.0, lineHeight );
    
    top += lineHeight + 4;
    CGRect midFrame = CGRectMake( 5.0, top, w, lineHeight );
    
    [defaultMethod setFrame:topLeftFrame];
    [accountNameLabel setFrame:topFrame];
    [accountDescriptionLabel setFrame:midFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
