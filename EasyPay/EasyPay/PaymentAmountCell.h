//
//  PaymentAmountCell.h
//  EasyPay
//
//  Created by Hank Warren on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentAmountCell : UITableViewCell
@property(strong,nonatomic) UILabel *accountNumberLabel;
@property(strong,nonatomic) UILabel *dueDateLabel;
@property(strong,nonatomic) UILabel *totalLabel;

+ (int)cellHeight;

@end
