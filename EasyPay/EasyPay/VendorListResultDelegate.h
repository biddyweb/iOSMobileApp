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
}
-(void)printArray;
-(id)objectAtIndex:(int)index;
-(int)count;
@end
