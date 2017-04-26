//
//  AAViewController.m
//  Automata Alert
//
//  Created by Anson Liu on 7/12/14.
//  Copyright (c) 2014 Apparent Etch. All rights reserved.
//

#import "AAViewController.h"

@interface AAViewController () {
    int numberOfOldAlerts;
}

@end

@implementation AAViewController {
    NSArray<NSLayoutConstraint *> *temporaryAddedConstraints;
}

- (void)refreshAlertList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        while ([[[UIApplication sharedApplication] scheduledLocalNotifications] count] == numberOfOldAlerts) {
            usleep(10000);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [tableViewController refreshAlertArray];
            [self.alertListTableView reloadData];
        });
    });
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
            NSLog(@"Show vertical layout");
            
            [self applyPortraitConstraints];
        } else if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
            NSLog(@"Show horizonal layout");

            [self applyLandscapeConstraints];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
    
    
}

- (void)applyLandscapeConstraints {
    if (temporaryAddedConstraints)
        [self.view removeConstraints:temporaryAddedConstraints];
    temporaryAddedConstraints = [[NSArray alloc] init];
    
    id topGuide = [self topLayoutGuide];
    NSDictionary *bindings = @{ @"dateModificationView" : self.dateModificationView, @"alertTitleTextField" : self.alertTitleTextField, @"alertDatePicker" : self.alertDatePicker, @"alertScheduleButton" : self.alertScheduleButton, @"alertListTableView" : self.alertListTableView, @"topGuide" : topGuide };
    
    temporaryAddedConstraints = [temporaryAddedConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[dateModificationView]-0-|"
                                                                                                                                 options:(NSLayoutFormatOptions)0
                                                                                                                                 metrics:nil views:bindings]];
    temporaryAddedConstraints = [temporaryAddedConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[alertListTableView]-0-|"
                                                                                                                                 options:(NSLayoutFormatOptions)0
                                                                                                                                 metrics:nil views:bindings]];
    
    temporaryAddedConstraints = [temporaryAddedConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[alertListTableView]-0-[dateModificationView]-0-|"
                                                                                                                                 options:(NSLayoutFormatOptions)0
                                                                                                                                 metrics:nil views:bindings]];
    [self.view addConstraints:temporaryAddedConstraints];
}

- (void)applyPortraitConstraints {
    if (temporaryAddedConstraints)
        [self.view removeConstraints:temporaryAddedConstraints];
    temporaryAddedConstraints = [[NSArray alloc] init];
    
    id topGuide = [self topLayoutGuide];
    NSDictionary *bindings = @{ @"dateModificationView" : self.dateModificationView, @"alertTitleTextField" : self.alertTitleTextField, @"alertDatePicker" : self.alertDatePicker, @"alertScheduleButton" : self.alertScheduleButton, @"alertListTableView" : self.alertListTableView, @"topGuide" : topGuide };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        temporaryAddedConstraints = [temporaryAddedConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[dateModificationView(==308)]-0-[alertListTableView]-0-|"
                                                                                                                                 options:(NSLayoutFormatOptions)0
                                                                                                                                 metrics:nil views:bindings]];
    else
        temporaryAddedConstraints = [temporaryAddedConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[dateModificationView]-0-[alertListTableView]-0-|"
                                                                                                                                     options:(NSLayoutFormatOptions)0
                                                                                                                                     metrics:nil views:bindings]];
    
    temporaryAddedConstraints = [temporaryAddedConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[dateModificationView]-0-|"
                                                                                                                                 options:(NSLayoutFormatOptions)0
                                                                                                                                 metrics:nil views:bindings]];
    temporaryAddedConstraints = [temporaryAddedConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[alertListTableView]-0-|"
                                                                                                                                 options:(NSLayoutFormatOptions)0
                                                                                                                                 metrics:nil views:bindings]];
    [self.view addConstraints:temporaryAddedConstraints];
}

- (void)applyPermanentConstraints {
    NSDictionary *bindings = @{ @"alertTitleTextField" : self.alertTitleTextField, @"alertDatePicker" : self.alertDatePicker, @"alertScheduleButton" : self.alertScheduleButton };
    [self.dateModificationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[alertTitleTextField]-[alertDatePicker]-[alertScheduleButton]-|"
                                                                                 options:(NSLayoutFormatOptions)0
                                                                                 metrics:nil views:bindings]];
    [self.dateModificationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[alertTitleTextField]-|"
                                                                                 options:(NSLayoutFormatOptions)0
                                                                                 metrics:nil views:bindings]];
    [self.dateModificationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[alertDatePicker]-|"
                                                                                 options:(NSLayoutFormatOptions)0
                                                                                 metrics:nil views:bindings]];
    [self.dateModificationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[alertScheduleButton]-|"
                                                                                 options:(NSLayoutFormatOptions)0
                                                                                 metrics:nil views:bindings]];
    
    //decrease schedule button content hugging priority so that it will stretch to fill available space
    [self.alertScheduleButton setContentHuggingPriority:100 forAxis:UILayoutConstraintAxisVertical];
    
    [self.alertListTableView setContentHuggingPriority:100 forAxis:UILayoutConstraintAxisVertical];
    [self.alertListTableView setContentHuggingPriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    
    
    [self.dateModificationView setContentCompressionResistancePriority:900 forAxis:UILayoutConstraintAxisVertical];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.alertDatePicker setDate:[NSDate date] animated:YES];
}

- (void)willEnterForeground:(id)sender {
    [self refreshAlertList];
    [self.alertDatePicker setDate:[NSDate date] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.myViewController = self;
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didlocalNotificationReceived:) name:@"localNotificationReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAlertList) name:@"refreshAlertList" object:nil];
    
    [self.alertScheduleButton setEnabled:NO];
    
    tableViewController = [[AAAlertListTableViewController alloc] init];
    
    [self.alertListTableView setDataSource:tableViewController];
    [self.alertListTableView setDelegate:tableViewController];
    
    [self applyPermanentConstraints];
    [self applyPortraitConstraints];
}

- (void)didlocalNotificationReceived:(NSNotification *)notification
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    
    UILocalNotification *theNotification = notification.object;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[dateFormatter stringFromDate:theNotification.fireDate] message:[NSString stringWithFormat:@"%@", [theNotification.userInfo objectForKey:alertBodyKey]] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] - 1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return NO; // We do not want UITextField to insert line-breaks.
}

- (IBAction)alertDatePickerValueChanged:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)alertTitleTextFieldEdittingfChanged:(id)sender {
    if ([[sender text] length] > 0) {
        [self.alertScheduleButton setEnabled:YES];
    } else {
        [self.alertScheduleButton setEnabled:NO];
    }
}

- (IBAction)alertScheduleButtonClicked:(id)sender {
    [self.view endEditing:YES];
    
    if ([[[UIApplication sharedApplication] scheduledLocalNotifications] count] == 64) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Maximum Alert Count Reached" message:@"iOS only supports 64 scheduled notifications per app.\nYou must delete a scheduled alert in order to add a new one." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    } else {
        
        
        if ([UIMutableUserNotificationAction class] && [UIMutableUserNotificationCategory class]) {
            UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
            acceptAction.identifier = @"VIEW_IDENTIFIER";
            acceptAction.title = @"View";
            
            // Given seconds, not minutes, to run in the background
            acceptAction.activationMode = UIUserNotificationActivationModeForeground;
            
            // If YES the action is red
            acceptAction.destructive = NO;
            
            // If YES requires passcode, but does not unlock the device
            acceptAction.authenticationRequired = YES;
            
            UIMutableUserNotificationAction *laterAction = [[UIMutableUserNotificationAction alloc] init];
            laterAction.identifier = @"SNOOZE_IDENTIFIER";
            laterAction.title = @"Snooze";
            
            // Given seconds, not minutes, to run in the background
            laterAction.activationMode = UIUserNotificationActivationModeBackground;
            
            // If YES the action is red
            laterAction.destructive = NO;
            
            // If YES requires passcode, but does not unlock the device
            laterAction.authenticationRequired = NO;
            
            UIMutableUserNotificationCategory *notifyCategory = [[UIMutableUserNotificationCategory alloc] init];
            notifyCategory.identifier = @"NOTIFY_CATEGORY";
            
            // You can define up to 4 actions in the 'default' context
            // On the lock screen, only the first two will be shown
            // If you want to specify which two actions get used on the lockscreen, use UIUserNotificationActionContextMinimal
            [notifyCategory setActions:@[acceptAction, laterAction] forContext:UIUserNotificationActionContextMinimal];
            
            // These would get set on the lock screen specifically
            // [inviteCategory setActions:@[declineAction, acceptAction] forContext:UIUserNotificationActionContextMinimal];
            
            
            NSSet *categories = [NSSet setWithObjects:notifyCategory, nil];
            
            UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            } else {
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            }
        }

        
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        if (localNotification == nil)
            return;
        
        localNotification.fireDate = [self.alertDatePicker date];
        localNotification.alertBody = [self.alertTitleTextField text];
        localNotification.alertAction = @"View";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = [NSDictionary dictionaryWithObject:[self.alertTitleTextField text] forKey:alertBodyKey];
        
        /*if ([localNotification respondsToSelector:@selector(alertTitle)])
            localNotification.alertTitle = @"Hey!";*/
        if ([UIMutableUserNotificationCategory class])
            localNotification.category = @"NOTIFY_CATEGORY";

        
        numberOfOldAlerts = (int)[[[UIApplication sharedApplication] scheduledLocalNotifications] count];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        
        
        [self refreshAlertList];
        
        //save alert to list of previous alerts
        NSArray* alerts = nil;
        
        if ([ReadWriteData doesFileExist:alertListFilename]) {
            NSMutableArray* tmp = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[ReadWriteData readFile:alertListFilename]]];
            [tmp addObject:localNotification];
            alerts = tmp;
            
        } else {
            [alerts arrayByAddingObject:localNotification];
        }
        
        [ReadWriteData saveFile:[NSKeyedArchiver archivedDataWithRootObject:alerts] withFilename:alertListFilename];
    }
}
@end
