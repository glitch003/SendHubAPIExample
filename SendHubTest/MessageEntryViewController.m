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
    facts = [[NSArray alloc] initWithObjects:@"Miacis, the primitive ancestor of cats, was a small, tree-living creature of the late Eocene period, some 45 to 50 million years ago.",@"Phoenician cargo ships are thought to have brought the first domesticated cats to Europe in about 900 BC.",@"The first true cats came into existence about 12 million years ago and were the Proailurus.",@"Experts traditionally thought that the Egyptians were the first to domesticate the cat, some 3,600 years ago.  But recent genetic and archaeological discoveries indicate that cat domestication began in the Fertile Crescent, perhaps around 10,000 years ago, when agriculture was getting under way. (per Scientific American, 6/10/2009)",@"Ancient Egyptian family members shaved their eyebrows in mourning when the family cat died.",@"In Siam, the cat was so revered that one rode in a chariot at the head of a parade celebrating the new king.",@"The Pilgrims were the first to introduce cats to North America.",@"The first breeding pair of Siamese cats arrived in England in 1884.",@"The first formal cat show was held in England in 1871; in America, in 1895.",@"The Maine Coon cat is America's only natural breed of domestic feline. It is 4 to 5 times larger than the Singapura, the smallest breed of cat.",@"There are approximately 100 breeds of cat.",@"The life expectancy of cats has nearly doubled since 1930 - from 8 to 16 years.",@"Cats have been domesticated for half as long as dogs have been.",@"Cats respond most readily to names that end in an \"ee\" sound.",@"The female cat reaches sexual maturity within 6 to 10 months; most veterinarians suggest spaying the female at 5 months, before her first heat period. The male cat usually reaches sexual maturity between 9 and 12 months.",@"Female cats are \"polyestrous,\" which means they may have many heat periods over the course of a year. A heat period lasts about 4 to 7 days if the female is bred; if she is not, the heat period lasts longer and recurs at regular intervals.",@"A female cat will be pregnant for approximately 9 weeks - between 62 and 65 days from conception to delivery.",@"Female felines are \"superfecund,\" which means that each of the kittens in her litter can have a different father.",@"Many cats love having their forehead gently stroked.",@"If a cat is frightened, put your hand over its eyes and forehead, or let him bury his head in your armpit to help calm him.",@"A cat will tremble or shiver when it is in extreme pain.",@"Cats should not be fed tuna exclusively, as it lacks taurine, an essential nutrient required for good feline health.  ",@"Purring does not always indicate that a cat is happy and healthy - some cats will purr loudly when they are terrified or in pain.",@"Not every cat gets \"high\" from catnip. If the cat doesn't have a specific gene, it won't react (about 20% do not have the gene). Catnip is non-addictive.",@"Cats must have fat in their diet because they can't produce it on their own.",@"While many cats enjoy milk, it will give some cats diarrhea.",@"A cat will spend nearly 30% of her life grooming herself.",@"When a domestic cat goes after mice, about 1 pounce in 3 results in a catch.",@"Mature cats with no health problems are in deep sleep 15 percent of their lives. They are in light sleep 50 percent of the time. That leaves just 35 percent awake time, or roughly 6-8 hours a day. ",@"Cats come back to full alertness from the sleep state faster than any other creature.",@"A cat can jump 5 times as high as it is tall.",@"Cats can jump up to 7 times their tail length.",@"Spaying a female before her first or second heat will greatly reduce the threat of mammary cancer and uterine disease. A cat does not need to have at least 1 litter to be healthy, nor will they \"miss\" motherhood. A tabby named \"Dusty\" gave birth to 420 documented kittens in her lifetime, while \"Kitty\" gave birth to 2 kittens at the age of 30, having given birth to a documented 218 kittens in her lifetime.",@"Neutering a male cat will, in almost all cases, stop him from spraying (territorial marking), fighting with other males (at least over females), as well as lengthen his life and improve its quality.",@"Declawing a cat is the same as cutting a human's fingers off at the knuckle. There are several alternatives to a complete declawing, including trimming or a less radical (though more involved) surgery to remove the claws. Instead, train your cat to use a scratching post.",@"The average lifespan of an outdoor-only (feral and non-feral) is about 3 years; an indoor-only cat can live 16 years and longer. Some cats have been documented to have a longevity of 34 years.",@"Cats with long, lean bodies are more likely to be outgoing, and more protective and vocal than those with a stocky build.",@"A steady diet of dog food may cause blindness in your cat - it lacks taurine. ",@"An estimated 50% of today's cat owners never take their cats to a veterinarian for health care. Too, because cats tend to keep their problems to themselves, many owners think their cat is perfectly healthy when actually they may be suffering from a life-threatening disease. Therefore, cats, on an average, are much sicker than dogs by the time they are brought to your veterinarian for treatment.  ",@"Never give your cat aspirin unless specifically prescribed by your veterinarian; it can be fatal. Never ever give Tylenol to a cat.  And be sure to keep anti-freeze away from all animals - it's sweet and enticing, but deadly poison.  ",@"Most cats adore sardines.",@"A cat uses its whiskers for measuring distances.  The whiskers of a cat are capable of registering very small changes in air pressure.",@"It has been scientifically proven that stroking a cat can lower one's blood pressure.",@"In 1987, cats overtook dogs as the number one pet in America (about 50 million cats resided in 24 million homes in 1986). About 37% of American homes today have at least one cat.",@"If your cat snores or rolls over on his back to expose his belly, it means he trusts you.",@"Cats respond better to women than to men, probably due to the fact that women's voices have a higher pitch.",@"In an average year, cat owners in the United States spend over $2 billion on cat food.",@"According to a Gallup poll, most American pet owners obtain their cats by adopting strays.",@"When your cats rubs up against you, she is actually marking you as \"hers\" with her scent. If your cat pushes his face against your head, it is a sign of acceptance and affection.",@"Contrary to popular belief, people are not allergic to cat fur, dander, saliva, or urine - they are allergic to \"sebum,\" a fatty substance secreted by the cat's sebaceous glands. More interesting, someone who is allergic to one cat may not be allergic to another cat. Though there isn't (yet) a way of predicting which cat is more likely to cause allergic reactions, it has been proven that male cats shed much greater amounts of allergen than females. A neutered male, however, sheds much less than a non-neutered male.",@"Cat bites are more likely to become infected than dog bites.",@"In just 7 years, one un-spayed female cat and one un-neutered male cat and their offspring can result in 420,000 kittens.",@"Some notable people who disliked cats:  Napoleon Bonaparte, Dwight D. Eisenhower, Hitler.", nil];
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
    
    NSLog(@"Choosing from %d catfacts", [facts count]);
    //load a catfact into the box
    int ind = arc4random() % [facts count];
    
    messageEntryArea.text = [facts objectAtIndex:ind];
    
    
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //okay so this is kind of a hack, but it's a quick way to detect the return/send key on a UITextView.  There are delegate methods for UITextField that supply this functionality, but UITextField is single line and the mockup clearly shows a multiline text area which is a UITextView.  The issue here is that this could be triggered if the user pastes a newline, and if this was a real-world app I would certainly come up with a better solution for this.
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self sendMessage];
        return NO;
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
