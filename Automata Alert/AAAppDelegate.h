//
//  AAAppDelegate.h
//  Automata Alert
//
//  Created by Anson Liu on 7/12/14.
//  Copyright (c) 2014 Apparent Etch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAViewController.h"

@class AAViewController;

@interface AAAppDelegate : UIResponder <UIApplicationDelegate>

@property (weak, nonatomic) AAViewController *myViewController;
@property (strong, nonatomic) UIWindow *window;

@end
