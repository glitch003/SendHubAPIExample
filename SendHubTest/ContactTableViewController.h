//
//  ContactTableViewController.h
//  SendHubTest
//
//  Created by Christopher Cassano on 4/16/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface ContactTableViewController : UITableViewController<UIAlertViewDelegate>{
    NSMutableArray *tableContents;
    MBProgressHUD *hud;
    UIAlertView *errorAlert;
}

- (void) loadContacts;

@end
