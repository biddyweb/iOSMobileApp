//
//  VendorListDelegate.h
//  EasyPay
//
//  Created by Hank Warren on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VendorListResultDelegate;

@interface VendorListDelegate : NSObject <NSXMLParserDelegate> {
    NSMutableString *xmlCharacters;
    VendorListResultDelegate *vendorListResultDelegate;
}
@property(strong,nonatomic) NSMutableString *vendorListResultString;

@end
