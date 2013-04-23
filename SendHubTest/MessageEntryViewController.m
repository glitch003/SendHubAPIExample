//
//  MessageEntryViewController.m
//  SendHubTest
//
//  Created by Christopher Cassano on 4/16/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import "MessageEntryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "ContactObject.h"

@interface MessageEntryViewController ()

@end

@implementation MessageEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //initialize and style the message entry text box
    messageEntryArea = [[UITextView alloc] init];
    messageEntryArea.layer.borderColor = [[UIColor blackColor] CGColor];
    messageEntryArea.layer.borderWidth = 2.0;
    messageEntryArea.backgroundColor = [UIColor whiteColor];
    messageEntryArea.layer.cornerRadius = 6;
    messageEntryArea.returnKeyType = UIReturnKeySend;
    messageEntryArea.delegate = self;
    [self.view addSubview:messageEntryArea];
}

- (void) viewWillLayoutSubviews{
    
    //I'm using the app delegate as a place to put functions that are used in more than 1 view controller.  This should probably be done with a global include in the SendHubTest-Prefix.pch file instead.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //get current screen dimensions
    CGRect sRect = [appDelegate currentScreenSize];
    
    if(UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        //landscape mode
        messageEntryArea.frame = CGRectMake(20, 20, sRect.size.width - 40, 80);
    }else{
        //portrait mode
        messageEntryArea.frame = CGRectMake(20, 30, sRect.size.width - 40, 145);
    }

    
}

- (void) viewWillAppear:(BOOL)animated{
    //make the keyboard pop up when they come to this page
    [messageEntryArea becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) sendMessage{
    
    //Show a loading overlay while we attempt to send the message
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    hud.labelText = @"Please Wait...";
    hud.detailsLabelText = @"Sending Message";
    [hud show:YES];
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.sendhub.com"];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];

    /*JSON format:
     {
     "contacts": [
     1111
     ],
     "text": "Testing"
     }*/
    
    //create a parameter object which will be serialized into a JSON object
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSArray arrayWithObject:[NSString stringWithFormat:@"%d", _theContact.contactId]], @"contacts",
                             messageEntryArea.text, @"text", nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/v1/messages/?username=4073610378&api_key=9d051050bd1e27d368cc95cb633dfb8c440e8dc8" parameters:Nil];
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:Nil]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [hud hide:YES];
        NSLog(@"response: %@", JSON);
        
        NSString *successMsg;
        
        //check for the acknowledge message
        if([JSON objectForKey:@"acknowledgment"]){
            successMsg = [JSON objectForKey:@"acknowledgment"];
        }else{
            successMsg = @"No acknowledgement received from the server.  Your message may or may not have been sent.";
        }
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Success"
                              message: successMsg
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"error: %@", error);
        
        [hud hide:YES];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: error.localizedDescription
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }];
    
    
    [operation start]; 
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //okay so this is kind of a hack, but it's a quick way to detect the return/send key on a UITextView.  There are delegate methods for UITextField that supply this functionality, but UITextField is single line and the mockup clearly shows a multiline text area which is a UITextView.  The issue here is that this could be triggered if the user pastes a newline, and if this was a real-world app I would certainly come up with a better solution for this.
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self sendMessage];
        return NO;
    }
    
    return YES;
}

@end
