//
//  ValidateLoginResult.m
//  EasyPay
//
//  Created by Hank Warren on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ValidateLoginResultDelegate.h"

@implementation ValidateLoginResultDelegate
@synthesize validateLoginResultString;
@synthesize errorMessage;

-(BOOL)fault {
    return faultDetected;
}
-(id)init {
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
    if( [elementName isEqualToString:@"soap:Fault"] ) {
        faultDetected = YES;
    } else if( [elementName isEqualToString:@"ErrorMessage"] ) {
        faultDetected = YES;
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if( [elementName isEqualToString:@"ValidateLoginResult"] ) {
        validateLoginResultString = [NSString stringWithString:xmlCharacters];
    } else if( [elementName isEqualToString:@"faultstring"] ) {
        errorMessage = [NSString stringWithString:xmlCharacters];
    } else if( [elementName isEqualToString:@"ErrorMessage"] ) {
        errorMessage = [NSString stringWithString:xmlCharacters];
    }
    [xmlCharacters setString:@""];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [xmlCharacters appendString:string];
}


@end
