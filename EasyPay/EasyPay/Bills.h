//
//  Bills.h
//  EasyPay
//
//  Created by Hank Warren on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bills : NSObject
@property float maximumContribution;
@property BOOL visibleAccountNumber;
@property BOOL visibleCurrentReading;
@property BOOL visibleAmountToPayEntry;
@property float transactionFeeCreditCard;
@property float transactionFeeEFT;
@property BOOL paymentPending;
@property BOOL visibleCurrentDue;
@property BOOL inCollections;
@property(strong,nonatomic) NSString *accountNumberName;
@property(strong,nonatomic) NSString *latestAllowedScheduleDate;
@property BOOL visibleTotalPaid;
@property BOOL transactionFeeCreditCardPercent;
@property BOOL visibleBillCycle;
@property BOOL visibleBalanceForward;
@property BOOL transactionFeeEFTPercent;
@property BOOL visiblePreviousReading;

@end
