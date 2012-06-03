//
//  util.m
//  EasyPay
//
//  Created by Hank Warren on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>

BOOL string2BOOL( NSString *str ) {
    if( [str isEqualToString:@"True"] ) {
        return TRUE;
    }
    return FALSE;
}