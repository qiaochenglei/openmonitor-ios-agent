//
//  ServiceSuggestionViewController.m
//  icm-ios-agent
//
//  Created by shinysky on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ServiceSuggestionViewController.h"

@interface ServiceSuggestionViewController ()

@end

@implementation ServiceSuggestionViewController

@synthesize delegate;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    UIBarButtonItem *cancelButton =
	[[UIBarButtonItem alloc] initWithTitle: @"Cancel"
                                     style: UIBarButtonItemStylePlain
                                    target: self
                                    action: @selector(cancelBtnPressed:)];
    UIBarButtonItem *loginBtn =
	[[UIBarButtonItem alloc] initWithTitle: @"Suggest"
                                     style: UIBarButtonItemStyleDone
                                    target: self
                                    action: @selector(doneBtnPressed:)];
    //loginBtn.tintColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];

    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = loginBtn;
    self.title = @"Service Suggestion";
    
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    footer.text = @"Please input the suggested service infomation.";
    
    footer.backgroundColor = [UIColor clearColor];
    footer.font = [UIFont systemFontOfSize:15];
    footer.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    //footer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    // Automatic word wrap
    footer.lineBreakMode = UILineBreakModeWordWrap;
    footer.textAlignment = UITextAlignmentCenter;
    footer.numberOfLines = 0;
    // Autosize
    [footer sizeToFit];
    
    self.tableView.tableFooterView = footer;
    
    self.tableView.allowsSelection = false;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return true;//(interfaceOrientation == UIInterfaceOrientationPortrait);
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
    if (section == 0) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReuseIdentifier = @"LoginFormCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (cell == nil) {
        UITableViewCellStyle cellStyle = UITableViewCellStyleValue2;
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:ReuseIdentifier];
        // Configure the cell.
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *startDtLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 25)];
        if (indexPath.row == 0) {
            startDtLbl.text = @"Name:";
        } else if (indexPath.row == 1) {
            startDtLbl.text = @"Host:";
        } else if (indexPath.row == 2) {
            startDtLbl.text = @"IP:";
        } else if (indexPath.row == 3) {
            startDtLbl.text = @"Port:";
        }
        
        startDtLbl.backgroundColor = [UIColor clearColor];
        startDtLbl.textAlignment = UITextAlignmentRight;
        
        [cell.contentView addSubview:startDtLbl];
        
        UITextField *inputTF = [[UITextField alloc] initWithFrame:CGRectMake(120, 12, 250, 30)];
        [inputTF setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        if (indexPath.row == 0) {
            nameTF = inputTF;
            nameTF.autocorrectionType = UITextAutocorrectionTypeNo;
            [nameTF becomeFirstResponder];
        } else if (indexPath.row == 1) {
            hostTF = inputTF;
            hostTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
            hostTF.autocorrectionType = UITextAutocorrectionTypeNo;
            hostTF.keyboardType = UIKeyboardTypeURL;
        } else if (indexPath.row == 2) {
            ipTF = inputTF;
            ipTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
            ipTF.autocorrectionType = UITextAutocorrectionTypeNo;
            ipTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        } else if (indexPath.row == 3) {
            portTF = inputTF;
            portTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
            portTF.autocorrectionType = UITextAutocorrectionTypeNo;
            portTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        [cell.contentView addSubview:inputTF];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    if (indexPath.row == 0) {
        [nameTF becomeFirstResponder];
    } else if (indexPath.row == 1) {
        [hostTF becomeFirstResponder];
    } else if (indexPath.row == 2) {
        [ipTF becomeFirstResponder];
    } else if (indexPath.row == 3) {
        [portTF becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark Add Account Dialog

- (IBAction)doneBtnPressed:(id)sender
{
    NSString *name = nameTF.text;
    NSString *host = hostTF.text;
    NSString *ip = ipTF.text;
    NSString *port = portTF.text;

    if (name && [name length] > 0) {
        [self.delegate suggestServiceWithName:name host:host ip:ip port:[port intValue]];
    } else {
        //alert view
    }
}

- (IBAction)cancelBtnPressed:(id)sender
{
    [self.delegate cancel];
}


@end
