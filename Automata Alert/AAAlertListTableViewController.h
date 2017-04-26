//
//  AAAlertListTableViewController.h
//  Automata Alert
//
//  Created by Anson Liu on 7/12/14.
//  Copyright (c) 2014 Apparent Etch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ReadWriteData.h"

@interface AAAlertListTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray* alertArray;
    NSArray* pastAlertArray;
}

- (void)refreshAlertArray;

@end
