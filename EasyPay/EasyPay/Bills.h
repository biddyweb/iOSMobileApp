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
@property BOOL visibleCurrentDue;
@property BOOL visibleTotalPaid;
@property BOOL visibleBillCycle;
@property BOOL visibleBalanceForward;
@property BOOL visiblePreviousReading;

@property float transactionFeeCreditCard;
@property float transactionFeeEFT;
@property BOOL transactionFeeEFTPercent;
@property BOOL transactionFeeCreditCardPercent;

@property BOOL paymentPending;
@property BOOL inCollections;
@property(strong,nonatomic) NSString *accountNumberName;
@property(strong,nonatomic) NSString *latestAllowedScheduleDate;

@end
