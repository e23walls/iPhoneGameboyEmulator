//
//  gbTableViewController.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-18.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "gbTableViewController.h"
#import "ViewController.h"
#import "rom.h"
#import "romDataController.h"

@interface gbTableViewController ()

@end

@implementation gbTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.rdc = [[romDataController alloc] init];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table View

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rdc numberOfRoms];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    rom * romAtIndex = [self.rdc objectInRomsAtIndex:indexPath.row];
    cell.textLabel.text = romAtIndex.romName;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    rom * currRom = [self.rdc objectInRomsAtIndex:[self.tableView indexPathForSelectedRow].row];
    ViewController * detailViewController = [[ViewController alloc] initWithCurrentRom:currRom];
    [self.navigationController pushViewController:detailViewController animated:NO];
    [self.navigationController setNavigationBarHidden:YES];
}

@end
