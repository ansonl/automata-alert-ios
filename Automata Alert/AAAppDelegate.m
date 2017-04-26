//
//  AAAppDelegate.m
//  Automata Alert
//
//  Created by Anson Liu on 7/12/14.
//  Copyright (c) 2014 Apparent Etch. All rights reserved.
//

#import "AAAppDelegate.h"
#import <Crashlytics/Crashlytics.h>

@implementation AAAppDelegate

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"localNotificationReceived" object:notification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAlertList" object:notification];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //From http://herzbube.ch/blog/2016/08/how-hide-fabric-api-key-and-build-secret-open-source-project and https://twittercommunity.com/t/should-apikey-be-kept-secret/52644/6
    //Get API key from fabric.apikey file in mainBundle
    NSURL* resourceURL = [[NSBundle mainBundle] URLForResource:@"fabric.apikey" withExtension:nil];
    NSStringEncoding usedEncoding;
    NSString* fabricAPIKey = [NSString stringWithContentsOfURL:resourceURL usedEncoding:&usedEncoding error:NULL];
    
    // The string that results from reading the bundle resource contains a trailing
    // newline character, which we must remove now because Fabric/Crashlytics
    // can't handle extraneous whitespace.
    NSCharacterSet* whitespaceToTrim = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString* fabricAPIKeyTrimmed = [fabricAPIKey stringByTrimmingCharactersInSet:whitespaceToTrim];
    
    [Crashlytics startWithAPIKey:fabricAPIKeyTrimmed];
    
    
    
    Class cls = NSClassFromString(@"UILocalNotification");
	if (cls) {
		UILocalNotification *notification = [launchOptions objectForKey:
                                             UIApplicationLaunchOptionsLocalNotificationKey];
		
		if (notification) {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
            
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[dateFormatter stringFromDate:notification.fireDate] message:[NSString stringWithFormat:@"%@", [notification.userInfo objectForKey:alertBodyKey]] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
		}
	}
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] - 1];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
    if ([identifier isEqualToString:@"VIEW_IDENTIFIER"]) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[dateFormatter stringFromDate:notification.fireDate] message:[NSString stringWithFormat:@"%@", [notification.userInfo objectForKey:alertBodyKey]] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAlertList" object:notification];
    } else if ([identifier isEqualToString:@"SNOOZE_IDENTIFIER"]) {
        
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

        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60];
        localNotification.alertBody = [notification.userInfo objectForKey:alertBodyKey];
        localNotification.alertAction = @"View";
        if ([localNotification respondsToSelector:@selector(alertTitle)])
            localNotification.alertTitle = @"Un-Snoozed!";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        if ([UIMutableUserNotificationCategory class])
            localNotification.category = @"NOTIFY_CATEGORY";
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
    }
    
    // Call this when you're finished
    completionHandler();
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
