//
//  PaymentMethodCell.h
//  EasyPay
//
//  Created by Hank Warren on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentMethodCell : UITableViewCell
@property(strong,nonatomic) UILabel *accountNameLabel;
@property(strong,nonatomic) UILabel *accountDescriptionLabel;
@property(strong,nonatomic) UILabel *otherLabel;
@end
