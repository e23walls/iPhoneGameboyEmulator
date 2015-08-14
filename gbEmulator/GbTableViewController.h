//
//  gbTableViewController.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-18.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RomDataController;

@interface GbTableViewController : UITableViewController

@property (strong, nonatomic) RomDataController * rdc;

@end
