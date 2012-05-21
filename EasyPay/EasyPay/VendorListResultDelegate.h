//
//  VendorListResultDelegate.h
//  EasyPay
//
//  Created by Hank Warren on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VendorListResultDelegate : NSObject <NSXMLParserDelegate> {
    NSMutableArray *vendorArray;
    NSMutableString *vendorString;
    BOOL fault;
}
@property(strong,nonatomic) NSString *errorMessage;
-(void)printArray;
-(id)objectAtIndex:(int)index;
-(int)count;
-(BOOL)fault;
@end
