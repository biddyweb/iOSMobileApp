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

NSString *stringField( NSString *name, NSString *value ) {
    return [NSString stringWithFormat:@"<%@>%@</%@>",
            name, value, name];
}

NSString *intField( NSString *name, int value ) {
    return [NSString stringWithFormat:@"<%@>%d</%@>",
            name, value, name];
}

NSString *floatField( NSString *name, float value ) {
    return [NSString stringWithFormat:@"<%@>%g</%@>",
            name, value, name];
}
