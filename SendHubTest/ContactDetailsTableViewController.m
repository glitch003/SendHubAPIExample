//
//  ContactDetailsTableViewController.m
//  SendHubTest
//
//  Created by Christopher Cassano on 4/16/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import "ContactDetailsTableViewController.h"
#import "ContactObject.h"
#import "MessageEntryViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ContactTableViewController.h"

@interface ContactDetailsTableViewController ()

@end

@implementation ContactDetailsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //I'm using the app delegate as a place to put functions that are used in more than 1 view controller
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    //set navigation controller title to the contact name
    self.title = _theContact.name;
    
    //create an array with the text boxes.  position[0] is the contact name, position[1] is the contact number
    textBoxes = [[NSArray alloc] initWithObjects:[self createStyledTextField], [self createStyledTextField], nil];
    
    //put the contact name in the "name" field and make the return key into the next key
    [((UITextField*)textBoxes[0]) setText:_theContact.name];
    ((UITextField*)textBoxes[0]).returnKeyType = UIReturnKeyNext;
    
    //put the contact number in the "number" field and make the return key into the done key
    [((UITextField*)textBoxes[1]) setText:_theContact.number];
    ((UITextField*)textBoxes[1]).returnKeyType = UIReturnKeyDone;
    
    //get the current screen dimensions
    CGRect sRect = [appDelegate currentScreenSize];
    
    //create the send button, set the image for it, set the event target method and add it to the main view.
    sendMessageButton = [[UIButton alloc] initWithFrame:CGRectMake((sRect.size.width - 414) / 2.0, 150, 414, 69)];
    [sendMessageButton setImage:[UIImage imageNamed:@"SendButton.png"] forState:UIControlStateNormal];
    [sendMessageButton addTarget:self action:@selector(SendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:sendMessageButton];
    
    //disable scrolling on this tableview since it really shouldn't scroll
    self.tableView.scrollEnabled = NO;
}

- (void) viewDidAppear:(BOOL)animated{
    
    //if they are creating a new contact, then make the name field keyboard pop up so they can begin entering a name
    if(_theContact == nil){
        [((UITextField*)textBoxes[0]) becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews{
    //I'm using the app delegate as a place to put functions that are used in more than 1 view controller.  This should probably be done with a global include in the SendHubTest-Prefix.pch file instead.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //get the current screen dimensions
    CGRect sRect = [appDelegate currentScreenSize];
    
    //set frame on button so that it stays centered in landscape and portrait mode
    sendMessageButton.frame = CGRectMake((sRect.size.width - 414) / 2.0, 120, 414, 69);

    //set frame on the text fields so that they stay the right size in landscape and portrait mode
    ((UITextField*)textBoxes[0]).frame = CGRectMake(75, 10, sRect.size.width - 95, 30);
    ((UITextField*)textBoxes[1]).frame = CGRectMake(145, 10, sRect.size.width - 165, 30);
    
}

//this function creates a styled text field and returns it
- (UITextField*) createStyledTextField{
    UITextField *textEntryField = [[UITextField alloc] init];

    textEntryField.backgroundColor = [UIColor clearColor];
    textEntryField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    textEntryField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    textEntryField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    textEntryField.textColor = [UIColor blackColor];
    textEntryField.adjustsFontSizeToFitWidth = YES;
    textEntryField.textAlignment = NSTextAlignmentRight;
    textEntryField.delegate = self;
    
    return textEntryField;
}

//this function is called when the send button is pressed
- (void) SendButtonPressed:(UIButton*)sender{
    //when the user presses the send button, we should advance them to the message entry screen
    [self performSegueWithIdentifier:@"MessageEntrySegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //pass the currently selected contact to the message entry screen
    if([segue.identifier isEqualToString:@"MessageEntrySegue"]){
        MessageEntryViewController *newController = (MessageEntryViewController *)segue.destinationViewController;
        newController.theContact = _theContact;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    if([indexPath row] == 0){
        //set the contact name
        [cell.textLabel setText:@"Name"];
        [cell addSubview:((UITextField*)textBoxes[0])];
        
    }else if([indexPath row] == 1){
        //set the contact number
        [cell.textLabel setText:@"Phone Number"];
        [cell addSubview:((UITextField*)textBoxes[1])];
    }
    
    //turn off cell selection so that when they tap on a cell it doesn't turn blue
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if they tap on a row, we should make the text box that is inside that row become the first responder so they can edit the thing they just tapped
    if([indexPath row] < [textBoxes count]){
        [((UITextField*)textBoxes[[indexPath row]]) becomeFirstResponder];
    }
}

- (IBAction)SaveButtonPress:(UIBarButtonItem *)sender {
    
    //first, let's make sure they have a valid phone number
    if(![self checkPhoneNumber:((UITextField*)textBoxes[1]).text]){
        
        //if the number is invalid, show an alert informing the user
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: @"Invalid phone number"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    //hide the keyboard so that the loading HUD doesn't end up under it
    for(UITextField* tf in textBoxes){
        [tf resignFirstResponder];
    }
    
    //Show a loading overlay while we attempt to save the contact
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"Please Wait...";
    hud.detailsLabelText = @"Saving Contact";
    [self.view addSubview:hud];
    [hud show:YES];
    
    NSURL *url = [NSURL URLWithString:@"https://api.sendhub.com"];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];
    
    
    
    NSDictionary *params;
    NSMutableURLRequest *request;
    if(_theContact == nil){
        //the contact is empty, we should add a new contact.
        
        //create a parameter object which will be serialized into a JSON object
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  ((UITextField*)textBoxes[0]).text, @"name",
                  ((UITextField*)textBoxes[1]).text, @"number", nil];
        request = [httpClient requestWithMethod:@"POST" path:@"https://api.sendhub.com/v1/contacts/?username=4073610378&api_key=9d051050bd1e27d368cc95cb633dfb8c440e8dc8" parameters:Nil];
    }else{
        //save the current contact
        
        //create a parameter object which will be serialized into a JSON object
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%d",_theContact.contactId], @"id",
                                ((UITextField*)textBoxes[0]).text, @"name",
                                ((UITextField*)textBoxes[1]).text, @"number", nil];
        request = [httpClient requestWithMethod:@"PUT" path:[NSString stringWithFormat:@"https://api.sendhub.com/v1/contacts/%d/?username=4073610378&api_key=9d051050bd1e27d368cc95cb633dfb8c440e8dc8", _theContact.contactId] parameters:Nil];
    }
    
    


    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:Nil]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [hud hide:YES];
        
        NSLog(@"response: %@", JSON);
        
        //inform the user that the contact was saved successfully
        successAlert = [[UIAlertView alloc]
                              initWithTitle: @"Success"
                              message: @"Contact saved"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        successAlert.delegate = self;
        [successAlert show];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"error: %@", error);
        
        [hud hide:YES];
        
        NSString *errMsg = nil;
        
        //grab the error message from the response
        if([[JSON objectForKey:@"number"] count] > 0){
            errMsg = [[JSON objectForKey:@"number"] objectAtIndex:0];
            
            //pop the keyboard back up in the number field since the error was with the number and they will probably want to edit the number
            [((UITextField*)textBoxes[1]) becomeFirstResponder];
            
        }else if([[JSON objectForKey:@"name"] count] > 0){
            errMsg = [[JSON objectForKey:@"name"] objectAtIndex:0];
            
            //pop the keyboard back up in the number field since the error was with the name and they will probably want to edit the name
            [((UITextField*)textBoxes[0]) becomeFirstResponder];
        }
        
        //if the error message hasn't been set by the response, set it to the localized description of the error.
        if(!errMsg){
            errMsg = error.localizedDescription; 
        }
           
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: errMsg
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }];
    
    
    [operation start]; 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //check if it's the alertview we want.  we don't want this to be triggered if the user is hitting 'ok' on an error message
    if([alertView isEqual:successAlert]){
        
        //reload the contacts for the contact view controller since we may have modified a contact name
        [((ContactTableViewController*)[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2]) loadContacts];
        
        //return to the contact list so that they can see the change if they made one.  whether or not this needs to happen is debatable and a matter of user experience, but I thought for this little sample app it would be good to see the change if the user just made one
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{              // called when 'return' key pressed. return NO to ignore.
    if([textField isEqual:textBoxes[0]]){
        //the name field, advance the cursor/keyboard to the next field
        [((UITextField*)textBoxes[1]) becomeFirstResponder];
    }else if([textField isEqual:textBoxes[1]]){
        //the number field, collapse the keyboard so that the user can see the "send message" button which is hidden behind the keyboard in landscape mode
        [((UITextField*)textBoxes[1]) resignFirstResponder];
    }
    
    return YES;
}

//this function checks if the phone number is valid using Apple's built in NSTextCheckingTypePhoneNumber
- (BOOL) checkPhoneNumber: (NSString*) number{
    NSError *error;
    
    if(number == nil){
        return NO;
    }
    
    //even though there's a warning here, it's perfectly safe.  the warning is because NSDataDetector expects a type of "NSTextCheckingTypes" but we're passing in "NSTextCheckingType".  it's safe and okay because "NSTextCheckingType" is an enum whose value represents a power of 2.  "NSTextCheckingTypes" simply ORs multiple "NSTextCheckingType" objects to represent more than 1 allowable "NSTextCheckingType"
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [number length]);
    NSArray *matches = [detector matchesInString:number options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0) {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        // it matched the whole string
        return YES;
    }
    else {
        // it only matched partial string
        return NO;
    }
}

@end
