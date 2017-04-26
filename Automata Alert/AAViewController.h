//
//  AAViewController.h
//  Automata Alert
//
//  Created by Anson Liu on 7/12/14.
//  Copyright (c) 2014 Apparent Etch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AAAlertListTableViewController.h"
#import "AAAppDelegate.h"

@interface AAViewController : UIViewController <UITableViewDelegate> {
    AAAlertListTableViewController  *tableViewController;
    
    NSMutableArray *layoutConstraintsPortrait;
    NSMutableArray *layoutConstraintsLandscape;
}

@property (weak, nonatomic) IBOutlet UITextField *alertTitleTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *alertDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *alertScheduleButton;
@property (weak, nonatomic) IBOutlet UITableView *alertListTableView;
@property (weak, nonatomic) IBOutlet UIView *dateModificationView;

- (IBAction)alertTitleTextFieldEdittingfChanged:(id)sender;
- (IBAction)alertDatePickerValueChanged:(id)sender;
- (IBAction)alertScheduleButtonClicked:(id)sender;

- (void)refreshAlertList;
@end
