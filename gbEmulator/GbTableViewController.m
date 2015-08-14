//
//  gbTableViewController.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-18.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "GbTableViewController.h"
#import "ViewController.h"
#import "Rom.h"
#import "RomDataController.h"

@interface GbTableViewController ()

@end

@implementation GbTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.rdc = [[RomDataController alloc] init];
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

    Rom * romAtIndex = [self.rdc objectInRomsAtIndex:indexPath.row];
    cell.textLabel.text = romAtIndex.romName;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Rom * currRom = [self.rdc objectInRomsAtIndex:[self.tableView indexPathForSelectedRow].row];
    ViewController * detailViewController = [[ViewController alloc] initWithCurrentRom:currRom];
    [self.navigationController pushViewController:detailViewController animated:NO];
    [self.navigationController setNavigationBarHidden:YES];
}

@end
