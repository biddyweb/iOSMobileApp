//
//  util.h
//  EasyPay
//
//  Created by Hank Warren on 9/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef EasyPay_util_h
#define EasyPay_util_h

BOOL string2BOOL( NSString *str );

NSString *intField( NSString *name, int value );
NSString *floatField( NSString *name, float value );
NSString *stringField( NSString *name, NSString *value );

#endif
