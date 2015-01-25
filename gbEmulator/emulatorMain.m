//
//  emulatorMain.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "emulatorMain.h"
#define K 1024
#define RAMSIZE (2 * 8 * 8 * K) // 8K each, one for main RAM, one for VRAM

@interface emulatorMain ()

@property char * ram;
@property rom * currentRom;
@property romState * currentState;

@end

@implementation emulatorMain

- (emulatorMain *) initWithRom:(rom *) theRom
{
    self = [super init];
    self.keys = calloc(8, sizeof(int));
    self.currentRom = theRom;
    self.ram = (char *)malloc(RAMSIZE * sizeof(unsigned char));
    
    // Load the ROM file into RAM
    
    FILE * romFileHandler = fopen([self.currentRom.fullPath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    if (romFileHandler == NULL)
    {
        printf("Some error occurred when opening the ROM.\n");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Could not load ROM!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
    }
    NSLog(@"Loading the ROM '%@'\nLocation: %@\n", self.currentRom.romName, self.currentRom.fullPath);
    int ch;
    BOOL hitEOF = NO;
    int counter = 0;
    ch = fgetc(romFileHandler);
    while (counter < RAMSIZE)
    {
        if (ch == EOF)
        {
            hitEOF = YES;
            ch = 0;
            printf("HIT EOF!\n");
        }
        self.ram[counter] = (unsigned char)ch;
        counter++;
        printf("%i: Read: %x\n", counter, (unsigned char)ch);
        if (hitEOF == NO)
        {
            ch = fgetc(romFileHandler); // Only write the ROM data if it exists, else, write a series of 0s
        }
    }
    NSLog(@"Byte counter reached value: %i\n", counter);
    
    fclose(romFileHandler);
    
    return self;
}

- (void) runRom
{
    
}

@end

