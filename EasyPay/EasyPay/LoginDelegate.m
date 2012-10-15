//
//  LoginDelegate.m
//  EasyPay
//
//  Created by Hank Warren on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginDelegate.h"
#import "PaymentMethod.h"
#import "Bills.h"
#import "Bill.h"


@implementation LoginDelegate
@synthesize errorMessage;
@synthesize customerServicePhoneNumber;
@synthesize customerNumber;
@synthesize loginHash;
@synthesize customerServiceEmail;
@synthesize assistanceMessage;
@synthesize paymentMethodArray;
@synthesize paymentMethod;
@synthesize billArray;
@synthesize bills;
@synthesize paymentTotal;


-(id)init {
    self = [super init];
    MyLog( @"LoginDelegate init" );
    
    paymentMethodArray = [[NSMutableArray alloc] init];
    billArray = [[NSMutableArray alloc] init];
    bills = [[Bills alloc] init];
    
    return self;
}

/*
 * The following messages constitute the xml parser call backs; the joy of SAX.
 */
#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    NSString *key;
    MyLog( @"%@ **************************************", elementName );

    if( [elementName isEqualToString:@"Login"] ) {
        for(key in attributeDict) {
            MyLog(@"Key: %@, Value: %@", key, [attributeDict objectForKey: key]);
            if( [key isEqualToString:@"ID"] ) {
                ID = [attributeDict objectForKey:key];
            } else if( [key isEqualToString:@"CustomerServicePhoneNumber"] ) {
                customerServicePhoneNumber = [attributeDict objectForKey:key];
            } else if( [key isEqualToString:@"CustomerNumber"] ) {
                customerNumber = [attributeDict objectForKey:key];
            } else if( [key isEqualToString:@"LoginHash"] ) {
                loginHash = [attributeDict objectForKey:key];
            } else if( [key isEqualToString:@"CustomerServiceEmail"] ) {
                customerServiceEmail = [attributeDict objectForKey:key];
            }
        }

    } else if( [elementName isEqualToString:@"ErrorMessage"] ) {
        errorMessage = TRUE;
        for( key in attributeDict ) {
            MyLog(@"Key: %@, Value: %@", key, [attributeDict objectForKey: key]);
            if( [key isEqualToString:@"AssistanceMessage"] ) {
                assistanceMessage = [attributeDict objectForKey:key];
            }
        }
    } else if( [elementName isEqualToString:@"PaymentMethod"] ) {
        MyLog( @"elementName: %@", elementName );
        PaymentMethod *paymentMethod = [[PaymentMethod alloc] init];
        for( key in attributeDict ) {
            MyLog(@"Key: %@, Value: %@", key, [attributeDict objectForKey: key]);

            if( [key isEqualToString:@"AccountDescription"] ) {
                [paymentMethod setAccountDescription:[attributeDict objectForKey:key]];
            } else if( [key isEqualToString:@"Default"] ) {
                [paymentMethod setDefaultMethod:string2BOOL( [attributeDict objectForKey:key] ) ];
            } else if( [key isEqualToString:@"ShowCCV"] ) {
                [paymentMethod setShowCCV:string2BOOL( [attributeDict objectForKey:key] )];
            } else if( [key isEqualToString:@"isACH"] ) {
                [paymentMethod setIsACH:string2BOOL( [attributeDict objectForKey:key] )];
            } else if( [key isEqualToString:@"PaymentMethodID"] ) {
                [paymentMethod setPaymentMethodID:[attributeDict objectForKey:key]];
            } else if( [key isEqualToString:@"AccountName"] ) {
                [paymentMethod setAccountName:[attributeDict objectForKey:key]];
            }
        }
        [paymentMethodArray addObject:paymentMethod];
        
    } else if( [elementName isEqualToString:@"Bills"] ) {
        MyLog( @"elementName: %@", elementName );
        for( key in attributeDict ) {
            NSString *tmp = [attributeDict objectForKey:key];
            MyLog(@"Key: %@, Value: %@", key, tmp);
            
            if( [key isEqualToString:@"MaximumContribution"] ) {
                [bills setMaximumContribution:[tmp floatValue]];
            } else if( [key isEqualToString:@"VisibleAccountNumber"] ) {
                [bills setVisibleAccountNumber:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"VisibleCurrentReading"] ) {
                [bills setVisibleCurrentReading:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"VisibleAmountToPayEntry"] ) {
                [bills setVisibleAmountToPayEntry:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"VisibleCurrentDue"] ) {
                [bills setVisibleCurrentDue:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"VisibleTotalPaid"] ) {
                [bills setTransactionFeeCreditCardPercent:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"VisibleBillCycle"] ) {
                [bills setVisibleBillCycle:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"VisibleBalanceForward"] ) {
                [bills setVisibleBalanceForward:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"VisiblePreviousReading"] ) {
                [bills setVisiblePreviousReading:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"TransactionFeeCreditCard"] ) {
                [bills setTransactionFeeCreditCard:[tmp floatValue]];
            } else if( [key isEqualToString:@"TransactionFeeEFT"] ) {
                [bills setTransactionFeeEFT:[tmp floatValue]];
            } else if( [key isEqualToString:@"TransactionFeeCreditCardPercent"] ) {
                [bills setTransactionFeeCreditCardPercent:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"TransactionFeeEFTPercent"] ) {
                [bills setTransactionFeeEFTPercent:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"PaymentPending"] ) {
                [bills setPaymentPending:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"InCollections"] ) {
                [bills setInCollections:string2BOOL( tmp )];
            } else if( [key isEqualToString:@"AccountNumberName"] ) {
                [bills setAccountNumberName:tmp];
            } else if( [key isEqualToString:@"LatestAllowedScheduleDate"] ) {
                [bills setLatestAllowedScheduleDate:tmp];
            }
        }
    } else if( [elementName isEqualToString:@"Bill"] ) {
        MyLog( @"elementName: %@", elementName );
        Bill *bill = [[Bill alloc] init];

        for( key in attributeDict ) {
            NSString *str = [attributeDict objectForKey:key];

            MyLog(@"Key: %@, Value: %@", key, str);
            
            if( [key isEqualToString:@"BalanceForward"] ) {

            } else if( [key isEqualToString:@"TotalPaid"] ) {
                [bill setTotalPaid:[str floatValue]];
            } else if( [key isEqualToString:@"Pay"] ) {
                [bill setTotalPaid:[str floatValue]];
            } else if( [key isEqualToString:@"TotalDue"] ) {
                [bill setTotalDue:[str floatValue]];
            } else if( [key isEqualToString:@"TotalPaidDisplay"] ) {
                [bill setTotalPaidDisplay:str];
            } else if( [key isEqualToString:@"AccountNumber"] ) {
                [bill setAccountNumber:str];
            } else if( [key isEqualToString:@"AccountNumberDisplay"] ) {
                [bill setAccountNumberDisplay:str];
            } else if( [key isEqualToString:@"BillCycle"] ) {
                
            } else if( [key isEqualToString:@"CurrentCharges"] ) {
                [bill setCurrentCharges:[str floatValue]];
            } else if( [key isEqualToString:@"DueDate"] ) {
                [bill setDueDate:str];
            } else if( [key isEqualToString:@"CustomerNumber"] ) {
                [bill setCustomerNumber:str];
            } else if( [key isEqualToString:@"TotalDueDisplay"] ) {
                [bill setTotalDueDisplay:str];
            } else if( [key isEqualToString:@"BillDate"] ) {
                [bill setBillDate:str];
            } else if( [key isEqualToString:@"CurrentReading"] ) {
                [bill setCurrentReading:str];
            }
        }
        [billArray addObject:bill];
    } else {
        for( key in attributeDict ) {
            MyLog(@"Key: %@, Value: %@", key, [attributeDict objectForKey: key]);            
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    MyLog( @"%@ End **********************************", elementName );

    [xmlCharacters setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [xmlCharacters appendString:string];
}

@end
