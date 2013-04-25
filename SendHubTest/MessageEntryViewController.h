//
//  MessageEntryViewController.h
//  SendHubTest
//
//  Created by Christopher Cassano on 4/16/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactObject;

@interface MessageEntryViewController : UIViewController<UITextViewDelegate, UIAlertViewDelegate>{
    UITextView *messageEntryArea;
    NSArray *facts;
}

@property (nonatomic) ContactObject *theContact;


@end
