//
//  AAAlertListTableViewController.m
//  Automata Alert
//
//  Created by Anson Liu on 7/12/14.
//  Copyright (c) 2014 Apparent Etch. All rights reserved.
//

#import "AAAlertListTableViewController.h"

@interface AAAlertListTableViewController ()

@end

@implementation AAAlertListTableViewController

- (void)refreshAlertArray {
    alertArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    
    NSArray* savedAlertArray = [NSKeyedUnarchiver unarchiveObjectWithData:[ReadWriteData readFile:alertListFilename]];
    NSMutableArray* tmp = [NSMutableArray arrayWithArray:savedAlertArray];
    for (UILocalNotification* obj in savedAlertArray) {
        if ([obj.fireDate earlierDate:[NSDate date]] != obj.fireDate) {
            [tmp removeObject:obj];
        }
    }
    pastAlertArray = tmp;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self refreshAlertArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Queued";
    else if (section == 1)
        return @"Past";
    else if (section == 2)
        return [NSString stringWithFormat:@"Automata Alert v%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    else
        return @"Uh oh";
}

/*
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        if ([alertArray count] == 0) {
            return 0;
        } else {
            return [alertArray count];
        }
    } else if (section == 1) {
        return [pastAlertArray count];
    } else if (section == 2) {
        return 0;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alertCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if ([indexPath section] == 0) {
        if ([alertArray count] == 0) {
            [cell.textLabel setText:@"No scheduled alerts."];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } else {
            [cell.textLabel setText:((UILocalNotification*)[alertArray objectAtIndex:[indexPath row]]).alertBody];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE\tMM/dd\thh:mm a"];
            [cell.detailTextLabel setText:[dateFormatter stringFromDate:((UILocalNotification*)[alertArray objectAtIndex:[indexPath row]]).fireDate]];
            
            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        }
    } else if ([indexPath section] == 1) {
        if ([pastAlertArray count] == 0) {
            [cell.textLabel setText:@"No past alerts."];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } else {
            [cell.textLabel setText:((UILocalNotification*)[pastAlertArray objectAtIndex:[indexPath row]]).alertBody];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE MM/dd/yyyy hh:mm a"];
            [cell.detailTextLabel setText:[dateFormatter stringFromDate:((UILocalNotification*)[pastAlertArray objectAtIndex:[indexPath row]]).fireDate]];
            
            [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        }
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if ([indexPath section] == 0) {
            [[UIApplication sharedApplication] cancelLocalNotification:[alertArray objectAtIndex:[indexPath row]]];
            
        } else if ([indexPath section] == 1) {
            NSMutableArray* tmp = [NSMutableArray arrayWithArray:pastAlertArray];
            [tmp removeObject:[pastAlertArray objectAtIndex:[indexPath row]]];
            [ReadWriteData saveFile:[NSKeyedArchiver archivedDataWithRootObject:tmp] withFilename:alertListFilename];
        }
        
        
        [self refreshAlertArray];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
