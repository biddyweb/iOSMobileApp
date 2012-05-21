//
//  ValidateLoginResult.h
//  EasyPay
//
//  Created by Hank Warren on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateLoginResultDelegate : NSObject <NSXMLParserDelegate> {
    NSMutableString *xmlCharacters;
    BOOL faultDetected;
}
@property(strong,nonatomic) NSString *errorMessage;
@property(strong,nonatomic) NSString *validateLoginResultString;

-(BOOL)fault;
@end
