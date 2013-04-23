//
//  ContactTableViewController.m
//  SendHubTest
//
//  Created by Christopher Cassano on 4/16/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import "ContactTableViewController.h"
#import "ContactObject.h"
#import "AppDelegate.h"
#import "ContactDetailsTableViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface ContactTableViewController ()

@end

@implementation ContactTableViewController

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
    
    //create the loading HUD
    hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"Please Wait...";
    hud.detailsLabelText = @"Loading Contacts";
    [self.view addSubview:hud];
  
    //initially load the contacts from the server
    [self loadContacts];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ContactDetailSegue"]){
        ContactDetailsTableViewController *newController = (ContactDetailsTableViewController *)segue.destinationViewController;
        if([self.tableView indexPathForSelectedRow] == nil){
            //if the selected row is nil, then they tapped the + button.  Set the contact to nil so that the ContactDetailsTableViewController knows that the user wants to create a new contact
            newController.theContact = nil;
        }else{
            //pass the selected contact to the ContactDetailsTableViewController
            newController.theContact = [tableContents objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        }
    }
}

- (void) loadContacts{
    //Show a loading overlay while we attempt to load the user's contacts
    [hud show:YES];
    
    NSURL *url = [NSURL URLWithString:@"https://api.sendhub.com/v1/contacts/?username=4073610378&api_key=9d051050bd1e27d368cc95cb633dfb8c440e8dc8"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        //allocate the contacts array to be the size returned by the server.
        tableContents = [[NSMutableArray alloc] initWithCapacity:[((NSString*)[[JSON objectForKey:@"meta"] objectForKey:@"total_count" ]) intValue]];
        
        
        /*JSON format:
         {
         "blocked": false,
         "groups": [],
         "id": "1111",
         "name": "John Doe",
         "number": "+15555555555",
         "resource_uri": "/api/v1/contacts/1111/"
         }*/
        
        //store the JSON results in a storage object
        for(NSDictionary *contact in [JSON objectForKey:@"objects"]){
            ContactObject *co = [ContactObject alloc];
            
            co.name = [contact objectForKey:@"name"];
            co.number = [contact objectForKey:@"number"];
            co.blocked = [[contact objectForKey:@"blocked"] boolValue];
            co.contactId = [[contact objectForKey:@"id"] intValue];
            
            
            [tableContents addObject:co];
        }
        
        //reload the table data since it has now changed
        [self.tableView reloadData];
        
        //hide the loading HUD
        [hud hide:YES];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", error);
        
        //hide the loading HUD
        [hud hide:YES];
        
        //alert the user that an error happened
        errorAlert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: error.localizedDescription
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:@"Retry", nil];
        errorAlert.delegate = self;
        [errorAlert show];
    }];
    
    [operation start];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //check that the button pressed was inside the error alertview and not some other alertview
    if([alertView isEqual:errorAlert]){
        if(buttonIndex == 1){
            //retry button was pressed, let's retry loading the contacts
            [self loadContacts];
        }
    }
}

- (void) deleteContact:(NSIndexPath*)indexPath{
    //Show a loading overlay while we attempt to delete the contact
    [hud show:YES];
    
    NSURL *url = [NSURL URLWithString:@"https://api.sendhub.com"];
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:url];
    
    //retrieve the contact object from the table
    ContactObject *co = [tableContents objectAtIndex:[indexPath row]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"https://api.sendhub.com/v1/contacts/%d/?username=4073610378&api_key=9d051050bd1e27d368cc95cb633dfb8c440e8dc8", co.contactId] parameters:Nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        //the deletion was successful, reload the list of contacts.  
        [self loadContacts];
  
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"error: %@", error);
        
        //hide the loading HUD
        [hud hide:YES];
        
        //display the error to the user
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //bounds check just in case
    if([indexPath row] < [tableContents count]){
        //retrieve the contact object from the array of content objects
        ContactObject *co = [tableContents objectAtIndex:[indexPath row]];
        
        //set the UITableViewCell text to the contacts name
        [cell.textLabel setText:co.name];
    }
    
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //deselect the row so that when a user returns to this page, it's not still selected
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//this is needed to support swipe-to-delete functionality.  When the delete button is tapped, this function is called with an editingStyle equal to UITableViewCellEditingStyleDelete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //delete the contact
        [self deleteContact:indexPath];
    }
}

@end
