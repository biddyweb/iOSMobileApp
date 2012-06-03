//
//  LoginDelegate.h
//  EasyPay
//
//  Created by Hank Warren on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Bills;
@class Bill;

@interface LoginDelegate : NSObject <NSXMLParserDelegate> {
    NSMutableString *xmlCharacters;
    BOOL faultDetected;
    NSString *ID;
    Bills *bills;
}
@property(strong,nonatomic) NSString *loginHash;
@property(strong,nonatomic) NSString *customerNumber;
@property(strong,nonatomic) NSString *customerServicePhoneNumber;
@property(strong,nonatomic) NSString *customerServiceEmail;
@property(nonatomic) BOOL errorMessage;
@property(strong,nonatomic) NSString *assistanceMessage;
@property(strong,nonatomic) NSMutableSet *paymentMethodSet;
@property(strong,nonatomic) NSMutableSet *billSet;
@end
