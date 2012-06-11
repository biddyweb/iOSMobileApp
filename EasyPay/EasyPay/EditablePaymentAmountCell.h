//
//  EditablePaymentAmountCell.h
//  EasyPay
//
//  Created by Hank Warren on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditablePaymentAmountCell : UITableViewCell
@property(strong,nonatomic) UILabel *accountNumberLabel;
@property(strong,nonatomic) UILabel *dueDateLabel;
@property(strong,nonatomic) UITextField *totalTextField;
@end
