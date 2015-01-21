//
//  gbTableViewController.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-18.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import <UIKit/UIKit.h>

@class romDataController;

@interface gbTableViewController : UITableViewController

@property (strong, nonatomic) romDataController * rdc;

@end
