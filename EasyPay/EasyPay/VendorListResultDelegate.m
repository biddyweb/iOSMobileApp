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
@synthesize errorMessage;

-(id)init {
    self = [super init];
    vendorArray = [[NSMutableArray alloc] init];
    vendorString = [[NSMutableString alloc] init];
    return self;
}
-(BOOL)fault {
    return fault;
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

// The data for the Vendor tag is in the attrubtes
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    //MyLog( @"didStartElement: %@", elementName );
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
    } else if( [elementName isEqualToString:@"Error"] ) {
        NSString *key, *error;
        for( key in attributeDict ) {
            error = [attributeDict objectForKey: key];
            MyLog( @"Key: %@, Value: %@", key, error );
            if( [error isEqualToString:@"Message 01"] ) {
                errorMessage = @"username/password combination is incorrect.";
            } else if( [error isEqualToString:@"Message 02"] ) {
                errorMessage = @"No vendors were returned from the query.";
            }
        }
        fault = YES;
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
//    MyLog( @"didEndElement: %@", elementName );
//    if( [elementName isEqualToString:@"VendorListResult"] ) {
//    }
}
// The tags are all empty
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [vendorString appendString:string];
}

@end
