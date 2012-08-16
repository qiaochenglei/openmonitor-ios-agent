//
//  ICMServiceTableViewController.m
//  icm-ios-agent
//
//  Created by shinysky on 11-2-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "QuartzCore/QuartzCore.h"
#import "ICMServiceTableViewController.h"
#import "ICMService.h"
#import "ICMAppDelegate.h"
#import "ICMUpdater.h"

@implementation ICMServiceTableViewController

@synthesize managedObjectContext;

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        self.managedObjectContext = [ICMAppDelegate GetContext];
		self.titleKey = @"name";
		self.subtitleKey = nil;
		//self.searchKey = nil;//@"text";
        selectedIndex = -1;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Service";
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self performFetchAndReload];
}

- (void)viewDidUnload {
    refreshBtn = nil;
}

- (void)dealloc {
    
    self.managedObjectContext = nil;
}

- (void)performFetchAndReload
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ICMService" inManagedObjectContext:self.managedObjectContext];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:YES
                                                                                      selector:nil]];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"(tags CONTAINS %@)", tag];
    request.fetchBatchSize = 20;
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                       initWithFetchRequest:request
                                       managedObjectContext:self.managedObjectContext
                                       sectionNameKeyPath:nil
                                       cacheName:@"ServiceCache"];
    
    request = nil;
    
    self.fetchedResultsController = frc;
    frc = nil;
    
    // fetch and reload
    [self performFetchForTableView:self.tableView];
    
    NSArray* services = [self.fetchedResultsController fetchedObjects];
    if ([services count] <= 0) {
        // init database
        
        ICMService* service = [NSEntityDescription insertNewObjectForEntityForName:@"ICMService"
                                                      inManagedObjectContext:managedObjectContext];
        [service initWithHost:@"203.135.62.113" port:443 name:@"HTTPS" enabled:YES uid:@"2001"];
        
        service = [NSEntityDescription insertNewObjectForEntityForName:@"ICMService"
                                             inManagedObjectContext:managedObjectContext];
        [service initWithHost:@"www.google.com" port:80 name:@"HTTP" enabled:YES uid:@"2002"];
        
        service = [NSEntityDescription insertNewObjectForEntityForName:@"ICMService"
                                             inManagedObjectContext:managedObjectContext];
        [service initWithHost:@"ftp.secureftp-test.com" port:21 name:@"FTP" enabled:YES uid:@"2003"];
        
        service = [NSEntityDescription insertNewObjectForEntityForName:@"ICMService"
                                             inManagedObjectContext:managedObjectContext];
        [service initWithHost:@"pop.gmail.com" port:995 name:@"POP3" enabled:YES uid:@"2004"];
        
        service = [NSEntityDescription insertNewObjectForEntityForName:@"ICMService"
                                             inManagedObjectContext:managedObjectContext];
        [service initWithHost:@"imap.gmail.com" port:993 name:@"IMAP" enabled:YES uid:@"2005"];
        
        service = [NSEntityDescription insertNewObjectForEntityForName:@"ICMService"
                                             inManagedObjectContext:managedObjectContext];
        [service initWithHost:@"messenger.hotmail.com" port:1863 name:@"MSN" enabled:YES uid:@"2006"];
        
        service = [NSEntityDescription insertNewObjectForEntityForName:@"ICMService"
                                             inManagedObjectContext:managedObjectContext];
        [service initWithHost:@"talk.google.com" port:5222 name:@"GTalk" enabled:YES uid:@"2007"];
        service = [NSEntityDescription insertNewObjectForEntityForName:@"ICMService"
                                                inManagedObjectContext:managedObjectContext];
        [service initWithHost:@"localhost" port:5222 name:@"Localhost" enabled:YES uid:@"2008"];
        
        [ICMAppDelegate SaveContext];
    }
}

- (UIImage *)statusImageForManagedObject:(NSManagedObject *)managedObject
{
    ICMWebsite* website = (ICMWebsite*)managedObject;
    if ([website.status intValue] == kStatusNormal
        || [website.status intValue] == kStatusContentChanged) {
        return [UIImage imageNamed:@"pinhead-green"];
    }
    return [UIImage imageNamed:@"pinhead-red"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForManagedObject:(NSManagedObject *)managedObject atIndex:(NSIndexPath *)indexPath
{
    //do customizing here
    static NSString *ReuseIdentifier = @"CoreDataTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:ReuseIdentifier] autorelease];
        
        UITableViewCellStyle cellStyle = UITableViewCellStyleSubtitle;//self.subtitleKey ? UITableViewCellStyleSubtitle : UITableViewCellStyleDefault;
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:ReuseIdentifier];
        cell.textLabel.backgroundColor = [UIColor clearColor];
		//cell.textLabel.textColor = [UIColor lightGrayColor];
        
        //cell.contentView.backgroundColor = [UIColor blackColor];
    }
    if (self.titleKey) cell.textLabel.text = [managedObject valueForKey:self.titleKey];
    if (selectedIndex == indexPath.row) {
        cell.detailTextLabel.textColor = [UIColor darkTextColor];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.detailTextLabel.numberOfLines = 4;
        ICMService* service = (ICMService*)managedObject;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Host: %@\nPort: %d\nStatus: %@\nDate: %@", service.host, [service.port intValue], service.status, [service.lastcheck descriptionWithLocale:[NSLocale currentLocale]]];
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    UIImage *statusImage = [self statusImageForManagedObject:managedObject];
    if (statusImage) cell.imageView.image = statusImage;//?
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICMService *service = (ICMService *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"selected service with host: %@", service.host);
    
    //The user is selecting the cell which is currently expanded
    //we want to minimize it back
    if(selectedIndex == indexPath.row)
    {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIndex == indexPath.row) {
        return 120;
    } else {
        return 40;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma -
#pragma events handler

- (IBAction)refreshBtnTapped:(UIBarButtonItem *)sender {
    
    [ICMUpdater fireServiceTester];
}


@end
