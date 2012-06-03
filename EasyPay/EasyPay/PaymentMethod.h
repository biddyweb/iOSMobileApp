//
//  PaymentMethod.h
//  EasyPay
//
//  Created by Hank Warren on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentMethod : NSObject
@property(strong,nonatomic) NSString *accountDescription;
@property(nonatomic) BOOL defaultMethod;
@property(nonatomic) BOOL showCCV;
@property(strong,nonatomic) NSString *paymentMethodID;
@property(strong,nonatomic) NSString *accountName;
@end
