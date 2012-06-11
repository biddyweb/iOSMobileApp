//
//  EditablePaymentAmountCell.m
//  EasyPay
//
//  Created by Hank Warren on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditablePaymentAmountCell.h"

@implementation EditablePaymentAmountCell
@synthesize accountNumberLabel;
@synthesize dueDateLabel;
@synthesize totalTextField;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        accountNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [accountNumberLabel setText:@"ACCT:"];
        dueDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [dueDateLabel setText:@"due date"];
        totalTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        [totalTextField setText:@"total"];
        
        [[self contentView] addSubview:accountNumberLabel];
        [[self contentView] addSubview:dueDateLabel];
        [[self contentView] addSubview:totalTextField];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = [[self contentView] bounds];
    CGFloat top = 2.0;
    CGFloat inset = 5.0;
    
    float w = bounds.size.width;
    
    UIFont *font = [accountNumberLabel font];
    CGFloat left = inset;
    CGFloat lineHeight = [font lineHeight];
    CGRect leftFrame = CGRectMake( left, top, w / 3.0, lineHeight );
    left += w / 3.0;
    CGRect midFrame = CGRectMake( left, top, w / 3, lineHeight );
    
    left += w / 3.0;
    CGRect rightFrame = CGRectMake( left, top, w / 3, lineHeight );
    
    [accountNumberLabel setFrame:leftFrame];
    [dueDateLabel setFrame:midFrame];
    [totalTextField setFrame:rightFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
