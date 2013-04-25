//
//  ContactDetailsTableViewController.h
//  SendHubTest
//
//  Created by Christopher Cassano on 4/16/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactObject, AppDelegate;

@interface ContactDetailsTableViewController : UITableViewController<UIAlertViewDelegate, UITextFieldDelegate>{
    UIButton *sendMessageButton;
    UIAlertView *successAlert;
    NSArray *textBoxes, *facts;
    NSString *msgText;
    
}

@property (nonatomic) ContactObject *theContact;


- (IBAction)SaveButtonPress:(UIBarButtonItem *)sender;

@end
