//
//  MainViewController.m
//  Watchlets
//
//  Created by Keaton Taylor on 4/29/15.
//  Copyright (c) 2015 iverted. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

/*
 There's no need to implement numberOfSectionsInTableView: because there's only one section and the method defaults to returning 1.
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // First let us allow editing of the tableView by adding a edit button.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // For our webView we need to load the local resource Watchlets.htm to present the user with the necessary developer information.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Watchlets" ofType:@"htm"]]]];
 
    // Set the background of the table view to the same color as the webView.
    [self.tableView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1]];
}


- (IBAction)addButton:(id)sender {
    [self showAlert:@"http://" title:@"Enter a URL" alertTag:200];
}

- (void)showAlert:(NSString*)message title:(NSString*)title alertTag:(NSInteger)tag {
    
    // Lets create an alert that will allow us to input text, so the user can setup URLs
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:@"URL must return JSON conforming to the API guidelines."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    
    // Set the alert view to the right style.
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = tag;
    [alert textFieldAtIndex:0].text = message;
    [alert show];
    
}

// This code needs to be fixed before submission.
- (BOOL)validateUrl:(NSString*)candidate {
    
    if ([NSURL URLWithString:candidate] == nil)
        return false;
    else
        return true;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.URL count];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *inputURL = [[alertView textFieldAtIndex:0] text];
    
    NSURL *url = [NSURL URLWithString:inputURL];
    
    if (url == nil) {
        NSLog(@"URL not propertly formated.");
    }
    else {
        NSLog(@"URL is properly formatted.");
    }
    // Called when the alert view OK button is pressed
    if (buttonIndex == 1) {
        // If we have a nil value for self, the user has never saved any URLs. Create the object.
        if (!self.URL)
            self.URL = [[NSMutableArray alloc] init];
        
        if (alertView.tag == 200) {
            // Grab the URL from the text field, validate it then add it to the row and sharedDefaults, else post error.
            
            if ([self validateUrl:inputURL]) {
                [self.URL insertObject:inputURL atIndex:[self.URL count]];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.URL.count-1 inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.sharedDefaults setObject:self.URL forKey:@"savedURLs"];
            }
            else
                [[[UIAlertView alloc] initWithTitle:@"URL Error" message:@"You've entered an invlaid URL. Please try again."
                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else {
            if ([self validateUrl:inputURL]) {
                [self.URL replaceObjectAtIndex:alertView.tag withObject:inputURL];
                [self.sharedDefaults setObject:self.URL forKey:@"savedURLs"];
                [self.tableView reloadData];
            }
            else
                [[[UIAlertView alloc] initWithTitle:@"URL Error" message:@"You've entered an invlaid URL. Please try again."
                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

- (void)BtnPressed {
    NSLog(@"tocuhed");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    // Set up the cell.
    NSString *URLs = [self.URL objectAtIndex:indexPath.row];
    cell.textLabel.text = URLs;
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove the object from the URL array, delete it from the table view and update the sharedDefaults NSDefaults.
        [self.URL removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.sharedDefaults setObject:self.URL forKey:@"savedURLs"];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showAlert:[self.URL objectAtIndex:indexPath.row] title:@"Edit a URL" alertTag:indexPath.row];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // Save the current String, delete it from current location then move it to the new location, lastly update sharedDefaults
    NSString *stringToMove = [self.URL objectAtIndex:sourceIndexPath.row];
    [self.URL removeObjectAtIndex:sourceIndexPath.row];
    [self.URL insertObject:stringToMove atIndex:destinationIndexPath.row];
    [self.sharedDefaults setObject:self.URL forKey:@"savedURLs"];

}


@end
