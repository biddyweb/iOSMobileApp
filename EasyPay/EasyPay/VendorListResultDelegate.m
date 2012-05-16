//
//  VendorListResultDelegate.m
//  EasyPay
//
//  Created by Hank Warren on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VendorListResultDelegate.h"
#import "Vendor.h"

@implementation VendorListResultDelegate
-(id)init {
    MyLog( @"VendorListResultDelegate init" );
    self = [super init];
    vendorArray = [[NSMutableArray alloc] init];
    vendorString = [[NSMutableString alloc] init];
    return self;
}
-(int)count {
    return [vendorArray count];
}
-(id)objectAtIndex:(int)index {
    return [vendorArray objectAtIndex:index];
}
-(void)printArray {
    for( id obj in vendorArray ) {
        MyLog( @"Name: %@ ID: %@", [obj Name], [obj ID] );
    }
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    MyLog( @"didStartElement: %@ (%@)", elementName, vendorString );
    if( [elementName isEqualToString:@"Vendor"] ) {
        NSString *key;
        Vendor *vendor = [[Vendor alloc] init];
        for(key in attributeDict) {
            //MyLog(@"Key: %@, Value: %@", key, [attributeDict objectForKey: key]);
            if( [key isEqualToString:@"Name"] ) {
                [vendor setName:[attributeDict objectForKey:key]];
            } else if( [key isEqualToString:@"ID"] ) {
                [vendor setID:[attributeDict objectForKey:key]];
            }
        }
        [vendorArray addObject:vendor];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
//    MyLog( @"didEndElement: %@", elementName );
//    if( [elementName isEqualToString:@"VendorListResult"] ) {
//    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [vendorString appendString:string];
}

@end
