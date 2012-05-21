//
//  VendorListDelegate.m
//  EasyPay
//
//  Created by Hank Warren on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VendorListDelegate.h"


@implementation VendorListDelegate
@synthesize vendorListResultString;

-(id)init {
    vendorListResultString = [[NSMutableString alloc] init];
    xmlCharacters = [[NSMutableString alloc] init];
    
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
    //    MyLog( @"didStartElement: %@", elementName );
    //    NSString *key;
    //    for(key in attributeDict){
    //        MyLog(@"Key: %@, Value %@", key, [attributeDict objectForKey: key]);
    //    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    //    MyLog( @"didEndElement: %@", elementName );
    if( [elementName isEqualToString:@"VendorListResult"] ) {
        vendorListResultString = [NSString stringWithString:xmlCharacters];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [xmlCharacters appendString:string];    // only used for the VendorListResult tag
}


@end
