//
//  LoginDelegate.h
//  EasyPay
//
//  Created by Hank Warren on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginDelegate : NSObject <NSXMLParserDelegate> {
    NSMutableString *xmlCharacters;
    BOOL faultDetected;
}
@property(strong,nonatomic) NSString *errorMessage;


@end
