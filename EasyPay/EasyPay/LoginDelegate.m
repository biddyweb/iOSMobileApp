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
@synthesize customerServicePhoneNumber;
@synthesize customerNumber;
@synthesize loginHash;
@synthesize customerServiceEmail;
@synthesize assistanceMessage;

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

    if( [elementName isEqualToString:@"Login"] ) {
        for(key in attributeDict) {
            MyLog(@"Key: %@, Value: %@", key, [attributeDict objectForKey: key]);
            if( [key isEqualToString:@"ID"] ) {
                ID = [attributeDict objectForKey:key];
            } else if( [key isEqualToString:@"CustomerServicePhoneNumber"] ) {
                customerServicePhoneNumber = [attributeDict objectForKey:key];
            } else if( [key isEqualToString:@"CustomerNumber"] ) {
                customerNumber = [attributeDict objectForKey:key];
            } else if( [key isEqualToString:@"LoginHash"] ) {
                loginHash = [attributeDict objectForKey:key];
            } else if( [key isEqualToString:@"CustomerServiceEmail"] ) {
                customerServiceEmail = [attributeDict objectForKey:key];
            }
        }

    } else if( [elementName isEqualToString:@"ErrorMessage"] ) {
        errorMessage = TRUE;
        for( key in attributeDict ) {
            MyLog(@"Key: %@, Value: %@", key, [attributeDict objectForKey: key]);

            assistanceMessage = [attributeDict objectForKey:key];
        }
    } else {
        for( key in attributeDict ) {
            MyLog(@"Key: %@, Value: %@", key, [attributeDict objectForKey: key]);            
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    MyLog( @"%@ End **********************************", elementName );

    [xmlCharacters setString:@""];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [xmlCharacters appendString:string];
}

@end
