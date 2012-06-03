//
//  Bill.h
//  EasyPay
//
//  Created by Hank Warren on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bill : NSObject
@property float balanceForward;
@property float totalPaid;
@property float pay;
@property float totalDue;
@property (strong,nonatomic) NSString *totalPaidDisplay;
@property (strong,nonatomic) NSString *accountNumber;
@property (strong,nonatomic) NSString *accountNumberDisplay;
@property (strong,nonatomic) NSString *billCycle;
@property float currentCharges;
@property (strong,nonatomic) NSString *dueDate;
@property (strong,nonatomic) NSString *customerNumber;
@property (strong,nonatomic) NSString *totalDueDisplay;
@property (strong,nonatomic) NSString *billDate;
@property (strong,nonatomic) NSString *currentReading;
@end
