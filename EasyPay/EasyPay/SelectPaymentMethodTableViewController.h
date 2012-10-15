//
//  SelectPaymentMethodTableViewController.h
//  EasyPay
//
//  Created by Henri Warren on 10/14/12.
//
//

#import <UIKit/UIKit.h>
@class LoginDelegate;

@interface SelectPaymentMethodTableViewController : UITableViewController

@property(strong,nonatomic) LoginDelegate *loginDelegate;

@end
