//
//  romDataController.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "romDataController.h"

#define SIMULATOR

@interface romDataController ()

- (void) getListOfRomsFromFileSystem;

@end

@implementation romDataController

- (romDataController *) init
{
    self = [super init];
    if (self)
    {
        self.roms = [[NSMutableArray alloc] init];
        [self getListOfRomsFromFileSystem];
    }
    return self;
}

void (^displayAlert) (NSString *) = ^(NSString * romDirectory)
{
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"You have no ROMs!" message:[[NSString alloc] initWithFormat:@"Put your GameBoy ROMs (.gb files) in the directory '%@'", romDirectory] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Got it!", nil];
    [av show];
};

- (void) getListOfRomsFromFileSystem
{
    // TODO: Save the ROM data in a different location
    // Make sure these always end in "/"
//    NSString * romDir = @"/User/Media/ROMs/";
//    NSString * romDirFull = @"/User/Media/ROMs/GAMEBOY/";
    NSString * romDirFull = [[@"~/Documents/ROMs" stringByExpandingTildeInPath] stringByAppendingString:@"/"];
#ifdef SIMULATOR
    romDirFull = [[@"/Users/emilywalls/Desktop/Waste of Time/Games/Emulators/GBC Roms" stringByExpandingTildeInPath] stringByAppendingString:@"/"];
#endif
    NSLog(@"ROM directory: %@", romDirFull);
    
    // Get list of files at '/var/mobile/Media/ROMs/GAMEBOY/' and for each one with extension '.gb',
    // create a cell for it, and display it
    NSFileManager * fm = [[NSFileManager alloc] init];
    NSError * e = nil;
    BOOL isDir;
    BOOL dirExists = [fm fileExistsAtPath:romDirFull isDirectory:&isDir];
    if (dirExists)
    {
        if (isDir)
        {
            NSArray * itemsAtPath = [fm contentsOfDirectoryAtPath:romDirFull error:&e];
            if (itemsAtPath == nil)
            {
                NSLog(@"Error getting file list:\n%@\n", e);
            }
            for (NSString * item in itemsAtPath)
            {
                if (item.length > 3)
                {
                    NSString * last3Chars = [[item substringFromIndex:(item.length - 3)] lowercaseString];
                    NSLog(@"Substring = '%@'\n", last3Chars);
                    if ([last3Chars isEqual: @".gb"]) // I.e., is this file a GameBoy ROM?
                    {
                        rom * r = [[rom alloc] init];
                        r.romName = [fm displayNameAtPath:item];
                        r.fullPath = [romDirFull stringByAppendingString:item];
                        [self addRomsObject:r];
                    }
                }
            }
            if ([self numberOfRoms] == 0)
            {
                displayAlert(romDirFull);
            }
        }
        else
        {
            NSLog(@"Something weird happened! '%@' isn't a directory!\n", romDirFull);
        }
    }
    else
    {
        // Sub path doesn't exist -- create it, and tell user to put ROMs here
        [fm createDirectoryAtPath:romDirFull withIntermediateDirectories:NO attributes:nil error:&e];
        if (e != nil)
        {
            NSLog(@"Error creating 'GAMEBOY' subdirectory!\n%@\n", e);
        }
        displayAlert(romDirFull);
    }
}

- (void) addRomsObject:(rom *)romToAdd
{
    [self.roms addObject:romToAdd];
}

- (NSInteger) numberOfRoms
{
    return self.roms.count;
}

- (rom *) objectInRomsAtIndex:(NSUInteger)index
{
    return self.roms[index];
}

- (void) setMasterBirdSightingList:(NSMutableArray *)newList
{
    if (self.roms != newList)
    {
        self.roms = [newList mutableCopy];
    }
}

@end
