//
//  LoginDelegate.m
//  EasyPay
//
//  Created by Hank Warren on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginDelegate.h"

@implementation LoginDelegate
@synthesize errorMessage;

/*
 * The following messages constitute the xml parser call backs; the joy of SAX.
 */
#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    NSString *key;
    MyLog( @"%@ **************************************", elementName );
    for(key in attributeDict) {
        MyLog(@"Key: %@, Value: %@", key, [attributeDict objectForKey: key]);
    }

//    if( [elementName isEqualToString:@"soap:Fault"] ) {
//        faultDetected = YES;
//    } else if( [elementName isEqualToString:@"ErrorMessage"] ) {
//        faultDetected = YES;
//    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
//    if( [elementName isEqualToString:@"ValidateLoginResult"] ) {
//        validateLoginResultString = [NSString stringWithString:xmlCharacters];
//    } else if( [elementName isEqualToString:@"faultstring"] ) {
//        errorMessage = [NSString stringWithString:xmlCharacters];
//    } else if( [elementName isEqualToString:@"ErrorMessage"] ) {
//        errorMessage = [NSString stringWithString:xmlCharacters];
//    }
    [xmlCharacters setString:@""];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [xmlCharacters appendString:string];
}

@end
