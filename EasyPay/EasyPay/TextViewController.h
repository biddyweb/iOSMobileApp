//
//  TextViewController.h
//  EasyPay
//
//  Created by Hank Warren on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController {
    IBOutlet UITextView *textView;
}
@property(strong,nonatomic) NSString *text;
@end
