//
//  ContactDetailsTableViewController.m
//  SendHubTest
//
//  Created by Christopher Cassano on 4/16/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import "ContactDetailsTableViewController.h"
#import "ContactObject.h"
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
    
    facts = [[NSArray alloc] initWithObjects:@"Miacis, the primitive ancestor of cats, was a small, tree-living creature of the late Eocene period, some 45 to 50 million years ago.",@"Phoenician cargo ships are thought to have brought the first domesticated cats to Europe in about 900 BC.",@"The first true cats came into existence about 12 million years ago and were the Proailurus.",@"Experts traditionally thought that the Egyptians were the first to domesticate the cat, some 3,600 years ago.  But recent genetic and archaeological discoveries indicate that cat domestication began in the Fertile Crescent, perhaps around 10,000 years ago, when agriculture was getting under way. (per Scientific American, 6/10/2009)",@"Ancient Egyptian family members shaved their eyebrows in mourning when the family cat died.",@"In Siam, the cat was so revered that one rode in a chariot at the head of a parade celebrating the new king.",@"The Pilgrims were the first to introduce cats to North America.",@"The first breeding pair of Siamese cats arrived in England in 1884.",@"The first formal cat show was held in England in 1871; in America, in 1895.",@"The Maine Coon cat is America's only natural breed of domestic feline. It is 4 to 5 times larger than the Singapura, the smallest breed of cat.",@"There are approximately 100 breeds of cat.",@"The life expectancy of cats has nearly doubled since 1930 - from 8 to 16 years.",@"Cats have been domesticated for half as long as dogs have been.",@"Cats respond most readily to names that end in an \"ee\" sound.",@"The female cat reaches sexual maturity within 6 to 10 months; most veterinarians suggest spaying the female at 5 months, before her first heat period. The male cat usually reaches sexual maturity between 9 and 12 months.",@"Female cats are \"polyestrous,\" which means they may have many heat periods over the course of a year. A heat period lasts about 4 to 7 days if the female is bred; if she is not, the heat period lasts longer and recurs at regular intervals.",@"A female cat will be pregnant for approximately 9 weeks - between 62 and 65 days from conception to delivery.",@"Female felines are \"superfecund,\" which means that each of the kittens in her litter can have a different father.",@"Many cats love having their forehead gently stroked.",@"If a cat is frightened, put your hand over its eyes and forehead, or let him bury his head in your armpit to help calm him.",@"A cat will tremble or shiver when it is in extreme pain.",@"Cats should not be fed tuna exclusively, as it lacks taurine, an essential nutrient required for good feline health.  ",@"Purring does not always indicate that a cat is happy and healthy - some cats will purr loudly when they are terrified or in pain.",@"Not every cat gets \"high\" from catnip. If the cat doesn't have a specific gene, it won't react (about 20% do not have the gene). Catnip is non-addictive.",@"Cats must have fat in their diet because they can't produce it on their own.",@"While many cats enjoy milk, it will give some cats diarrhea.",@"A cat will spend nearly 30% of her life grooming herself.",@"When a domestic cat goes after mice, about 1 pounce in 3 results in a catch.",@"Mature cats with no health problems are in deep sleep 15 percent of their lives. They are in light sleep 50 percent of the time. That leaves just 35 percent awake time, or roughly 6-8 hours a day. ",@"Cats come back to full alertness from the sleep state faster than any other creature.",@"A cat can jump 5 times as high as it is tall.",@"Cats can jump up to 7 times their tail length.",@"Spaying a female before her first or second heat will greatly reduce the threat of mammary cancer and uterine disease. A cat does not need to have at least 1 litter to be healthy, nor will they \"miss\" motherhood. A tabby named \"Dusty\" gave birth to 420 documented kittens in her lifetime, while \"Kitty\" gave birth to 2 kittens at the age of 30, having given birth to a documented 218 kittens in her lifetime.",@"Neutering a male cat will, in almost all cases, stop him from spraying (territorial marking), fighting with other males (at least over females), as well as lengthen his life and improve its quality.",@"Declawing a cat is the same as cutting a human's fingers off at the knuckle. There are several alternatives to a complete declawing, including trimming or a less radical (though more involved) surgery to remove the claws. Instead, train your cat to use a scratching post.",@"The average lifespan of an outdoor-only (feral and non-feral) is about 3 years; an indoor-only cat can live 16 years and longer. Some cats have been documented to have a longevity of 34 years.",@"Cats with long, lean bodies are more likely to be outgoing, and more protective and vocal than those with a stocky build.",@"A steady diet of dog food may cause blindness in your cat - it lacks taurine. ",@"An estimated 50% of today's cat owners never take their cats to a veterinarian for health care. Too, because cats tend to keep their problems to themselves, many owners think their cat is perfectly healthy when actually they may be suffering from a life-threatening disease. Therefore, cats, on an average, are much sicker than dogs by the time they are brought to your veterinarian for treatment.  ",@"Never give your cat aspirin unless specifically prescribed by your veterinarian; it can be fatal. Never ever give Tylenol to a cat.  And be sure to keep anti-freeze away from all animals - it's sweet and enticing, but deadly poison.  ",@"Most cats adore sardines.",@"A cat uses its whiskers for measuring distances.  The whiskers of a cat are capable of registering very small changes in air pressure.",@"It has been scientifically proven that stroking a cat can lower one's blood pressure.",@"In 1987, cats overtook dogs as the number one pet in America (about 50 million cats resided in 24 million homes in 1986). About 37% of American homes today have at least one cat.",@"If your cat snores or rolls over on his back to expose his belly, it means he trusts you.",@"Cats respond better to women than to men, probably due to the fact that women's voices have a higher pitch.",@"In an average year, cat owners in the United States spend over $2 billion on cat food.",@"According to a Gallup poll, most American pet owners obtain their cats by adopting strays.",@"When your cats rubs up against you, she is actually marking you as \"hers\" with her scent. If your cat pushes his face against your head, it is a sign of acceptance and affection.",@"Contrary to popular belief, people are not allergic to cat fur, dander, saliva, or urine - they are allergic to \"sebum,\" a fatty substance secreted by the cat's sebaceous glands. More interesting, someone who is allergic to one cat may not be allergic to another cat. Though there isn't (yet) a way of predicting which cat is more likely to cause allergic reactions, it has been proven that male cats shed much greater amounts of allergen than females. A neutered male, however, sheds much less than a non-neutered male.",@"Cat bites are more likely to become infected than dog bites.",@"In just 7 years, one un-spayed female cat and one un-neutered male cat and their offspring can result in 420,000 kittens.",@"Some notable people who disliked cats:  Napoleon Bonaparte, Dwight D. Eisenhower, Hitler.", nil];
    
}

- (void) viewDidAppear:(BOOL)animated{
    
    //if they are creating a new contact, then make the name field keyboard pop up so they can begin entering a name
    if(_theContact == nil){
        [((UITextField*)textBoxes[0]) becomeFirstResponder];
    }
    
    NSLog(@"Choosing from %d catfacts", [facts count]);
    //load a catfact into the box
    int ind = arc4random() % [facts count];
    
    msgText = [NSString stringWithFormat:@"Catfacts: %@",[facts objectAtIndex:ind]];
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
    //[self performSegueWithIdentifier:@"MessageEntrySegue" sender:self];
    [self sendMessage];
}

/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //pass the currently selected contact to the message entry screen
    if([segue.identifier isEqualToString:@"MessageEntrySegue"]){
        MessageEntryViewController *newController = (MessageEntryViewController *)segue.destinationViewController;
        newController.theContact = _theContact;
    }
}*/

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
        request = [httpClient requestWithMethod:@"POST" path:[NSString stringWithFormat:@"https://api.sendhub.com/v1/contacts/?username=%@&api_key=%@", USERNAME, APIKEY] parameters:Nil];
    }else{
        //save the current contact
        
        //create a parameter object which will be serialized into a JSON object
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%d",_theContact.contactId], @"id",
                                ((UITextField*)textBoxes[0]).text, @"name",
                                ((UITextField*)textBoxes[1]).text, @"number", nil];
        request = [httpClient requestWithMethod:@"PUT" path:[NSString stringWithFormat:@"https://api.sendhub.com/v1/contacts/%d/?username=%@&api_key=%@", _theContact.contactId, USERNAME, APIKEY] parameters:Nil];
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
    //if([alertView isEqual:successAlert]){
        
        //reload the contacts for the contact view controller since we may have modified a contact name
        [((ContactTableViewController*)[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2]) loadContacts];
        
        //return to the contact list so that they can see the change if they made one.  whether or not this needs to happen is debatable and a matter of user experience, but I thought for this little sample app it would be good to see the change if the user just made one
        [self.navigationController popViewControllerAnimated:YES];
    //}
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
                            msgText, @"text", nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/v1/messages/?username=%@&api_key=%@", USERNAME, APIKEY] parameters:Nil];
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:Nil]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [hud hide:YES];
        NSLog(@"response: %@", JSON);
        
        NSString *successMsg;
        
        //check for the acknowledge message
        if([JSON objectForKey:@"acknowledgment"]){
            successMsg = msgText;
        }else{
            successMsg = @"No acknowledgement received from the server.  Your message may or may not have been sent.";
        }
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Success"
                              message: successMsg
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.delegate = self;
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
