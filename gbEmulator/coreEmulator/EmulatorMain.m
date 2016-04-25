//
//  emulatorMain.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "EmulatorMain.h"
#include <sys/stat.h>
#import <QuartzCore/QuartzCore.h>

#define Clamp255(a) (a>255 ? 255 : a)

const int k = 1024;
const int ramSize = 64 * k; // For readability purposes; an unsigned short spans the same set of integers.
const int switchRomBankEnd = 0x8000;

extern const unsigned short interruptFlagAddress;
extern const unsigned short interruptEnableRegister;

/* ROM Bank 0:             0000 - 3FFF
 * ROM Bank X:             4000 - 7FFF
 * GPU VRAM:               8000 - 9FFF
 * External/cartridge RAM: A000 - BFFF
 * 
 */

const int biosSize = 256;


// At some point, it'd be nice if the print statements didn't sign-extend negative values out to 32-bits.
// To fix this, simply AND the value being printed with 0xFF, if it's one byte, and 0xFFFF if it's two bytes.
// Similarly, printing 2 byte values needs to have 4 hex digits display at once, not just 2.

@interface EmulatorMain ()
{
    bool incrementPC;
    bool isRunning;
    int8_t interruptsEnabled;
    time_t start;
    time_t timer;
    time_t clock_start;
    pthread_mutex_t timerMutex;
    int8_t * WX;
    int8_t * WY;
    int8_t * SCX;
    int8_t * SCY;
    int8_t * LCDC;
    int8_t * STAT;
    int8_t * LY;
    int8_t * LYC;
    int8_t * DMA;
    int8_t * BGP;
    int8_t * OBP0;
    int8_t * OBP1;
    int8_t * TIMA;
    int8_t * TMA;
    int8_t * TAC;
    int8_t * DIV;
    int screenBuffer[BufferWidth][BufferHeight];
}

@property int8_t * ram;
@property Rom * currentRom;
@property RomState * currentState;
@property NSTimer * t;
@property NSMutableArray * observers;

/*
 Keys:
 [Start][Select][B][A][Down][Up][Left][Right]
 */
@property int * keys;
@property int8_t buttons;

@end

void (^executeInstruction)(RomState *, int8_t *, bool *, int8_t *);

extern void (^setKeysInMemory)(int8_t *, int);
extern void (^enableInterrupts)(bool, int8_t *);
extern void (^interruptServiceRoutineCaller)(RomState *, int8_t *, bool *, int8_t *);
extern const unsigned short interruptFlagAddress;
extern const unsigned short interruptEnableRegister;

@implementation EmulatorMain

- (EmulatorMain *) initWithRom:(Rom *) theRom
{
    self = [super init];
    if (self != nil)
    {
        isRunning = false;
        incrementPC = true;
        self.buttons = 0b00000000;
        self.observers = [[NSMutableArray alloc] init];
        start = 0;
        timer = 0;
        [self clearScreen];
        clock_start = clock();
        pthread_mutex_init(&timerMutex, NULL);
        self.keys = calloc(8, sizeof(int));
        self.currentRom = theRom;
        self.ram = (int8_t *)calloc(ramSize, sizeof(char));
        char bios[] = {0x31, 0xfe, 0xff, 0xaf, 0x21, 0xff, 0x9f, 0x32, 0xcb, 0x7c, 0x20, 0xfb, 0x21, 0x26, \
            0xff, 0x0e, 0x11, 0x3e, 0x80, 0x32, 0xe2, 0x0c, 0x3e, 0xf3, 0xe2, 0x32, 0x3e, 0x77, 0x77, 0x3e, 0xfc, \
            0xe0, 0x47, 0x11, 0x04, 0x01, 0x21, 0x10, 0x80, 0x1a, 0xcd, 0x95, 0x00, 0xcd, 0x96, 0x00, 0x13, 0x7b, \
            0xfe, 0x34, 0x20, 0xf3, 0x11, 0xd8, 0x00, 0x06, 0x08, 0x1a, 0x13, 0x22, 0x23, 0x05, 0x20, 0xf9, 0x3e, \
            0x19, 0xea, 0x10, 0x99, 0x21, 0x2f, 0x99, 0x0e, 0x0c, 0x3d, 0x28, 0x08, 0x32, 0x0d, 0x20, 0xf9, 0x2e, \
            0x0f, 0x18, 0xf3, 0x67, 0x3e, 0x64, 0x57, 0xe0, 0x42, 0x3e, 0x91, 0xe0, 0x40, 0x04, 0x1e, 0x02, 0x0e, \
            0x0c, 0xf0, 0x44, 0xfe, 0x90, 0x20, 0xfa, 0x0d, 0x20, 0xf7, 0x1d, 0x20, 0xf2, 0x0e, 0x13, 0x24, 0x7c, \
            0x1e, 0x83, 0xfe, 0x62, 0x28, 0x06, 0x1e, 0xc1, 0xfe, 0x64, 0x20, 0x06, 0x7b, 0xe2, 0x0c, 0x3e, 0x87, \
            0xe2, 0xf0, 0x42, 0x90, 0xe0, 0x42, 0x15, 0x20, 0xd2, 0x05, 0x20, 0x4f, 0x16, 0x20, 0x18, 0xcb, 0x4f, \
            0x06, 0x04, 0xc5, 0xcb, 0x11, 0x17, 0xc1, 0xcb, 0x11, 0x17, 0x05, 0x20, 0xf5, 0x22, 0x23, 0x22, 0x23, \
            0xc9, 0xce, 0xed, 0x66, 0x66, 0xcc, 0x0d, 0x00, 0x0b, 0x03, 0x73, 0x00, 0x83, 0x00, 0x0c, 0x00, 0x0d, \
            0x00, 0x08, 0x11, 0x1f, 0x88, 0x89, 0x00, 0x0e, 0xdc, 0xcc, 0x6e, 0xe6, 0xdd, 0xdd, 0xd9, 0x99, 0xbb, \
            0xbb, 0x67, 0x63, 0x6e, 0x0e, 0xec, 0xcc, 0xdd, 0xdc, 0x99, 0x9f, 0xbb, 0xb9, 0x33, 0x3e, 0x3c, 0x42, \
            0xb9, 0xa5, 0xb9, 0xa5, 0x42, 0x3c, 0x21, 0x04, 0x01, 0x11, 0xa8, 0x00, 0x1a, 0x13, 0xbe, 0x20, 0xfe, \
            0x23, 0x7d, 0xfe, 0x34, 0x20, 0xf5, 0x06, 0x19, 0x78, 0x86, 0x23, 0x05, 0x20, 0xfb, 0x86, 0x20, 0xfe, \
            0x3e, 0x01, 0xe0, 0x50};
        
        // Load the ROM file into RAM
        
        FILE * romFileHandler = fopen([self.currentRom.fullPath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
        if (romFileHandler == NULL)
        {
            PRINTDBG("Some error occurred when opening the ROM.\n");
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Could not load ROM!" \
                                            delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
            [alert show];
        }
        NSLog(@"Loading the ROM '%@'\nLocation: %@\n", self.currentRom.romName, self.currentRom.fullPath);
        int ch = 0;
        BOOL hitEOF = NO;
        int counter = 0;
        ch = fgetc(romFileHandler);
        while (counter < switchRomBankEnd)
        {
            if (ch == EOF)
            {
                hitEOF = YES;
                ch = 0;
                PRINTDBG("HIT EOF!\n");
            }
            self.ram[counter] = (int8_t)ch;
            counter++;
            if (hitEOF == NO)
            {
                ch = fgetc(romFileHandler);
            }
        }
        NSLog(@"Byte counter reached value: %i\n", counter);
        if (hitEOF == YES)
        {
            PRINTDBG("Warning: EOF was reached before RAM was filled.\n");
        }
        else
        {
            PRINTDBG("As expected, EOF was not reached before end of RAM.\n");
        }
        fclose(romFileHandler);
        NSLog(@"Setting up the ROM initial state...");
        self.currentState = [[RomState alloc] init];
        enableInterrupts(false, self.ram);
        NSLog(@"Loading BIOS into RAM...");
        for (int i = 0; i < biosSize; i++)
        {
            self.ram[i] = bios[i];
        }
        [self setupRegisters];
    }
    else
    {
        PRINTDBG("Error! Couldn't allocate memory for emulator.\n");
    }
    return self;
}

- (void) dealloc
{
    free(self.ram);
    free(self.keys);
    self.observers = nil;
}

- (void) addObserver:(ViewController *) observer
{
    if (observer != nil)
    {
        [self.observers addObject:observer];
    }
}

- (void) clearScreen
{
    for (int i = 0; i < ScreenWidth; i++)
    {
        for (int j = 0; j < ScreenHeight; j++)
        {
            screenBuffer[i][j] = 0; // Or whatever.
        }
    }
}

- (void) notifyObservers
{
    for (ViewController * obs in self.observers)
    {
        [obs update];
    }
}

- (void) setupRegisters
{
    WX = self.ram + 0x0FF4B;
    WY = self.ram + 0x0FF4A;
    SCX = self.ram + 0x0FF43;
    SCY = self.ram + 0x0FF42;
    LCDC = self.ram + 0x0FF40;
    STAT = self.ram + 0x0FF41;
    LY = self.ram + 0x0FF44;
    *LY = 0;
    LYC = self.ram + 0x0FF45;
    DMA = self.ram + 0x0FF46;
    BGP = self.ram + 0x0FF47;
    *BGP = 0x0fc; // Probably not needed because the BIOS sets it already.
    OBP0 = self.ram + 0x0FF48;
    OBP1 = self.ram + 0x0FF49;
    TIMA = self.ram + 0x0FF05;
    TMA = self.ram + 0x0FF06;
    TAC = self.ram + 0x0FF07;
    DIV = self.ram + 0x0FF04;

    // This is probably necessary...
    self.ram[interruptFlagAddress] = 0;
}

- (UIImage *) getScreen
{
    if (self.currentState != nil)
    {
        return [self.currentState getScreen];
    }
    return nil;
}

- (void) redrawScreen
{
    if ((*LCDC) & (1 << 7))
    {
        // Draw image on screen
    }
    else
    {
        // Draw black screen
    }
}

// Don't worry about bit 7 (LCD on/off) because another method handles it.
- (UIImage *) updateScreen:(UIImage*) image
{
    PRINTDBG("Updating Screen:\n");
    int spriteWidth = 8;
    int spriteHeight = 8;
    unsigned short windowTileMapDisplaySelectStart = 0x9800;
    unsigned short windowTileMapDisplaySelectEnd = 0x9BFF;

    // Tile data select = tile pattern table.
    // Where the tiles are stored.
    // Each 8*8 image occupies 16 bytes; each 2 bytes = 1 line.
    // The second byte contains the 2nd bits of each dot,
    // and the first byte contains the 1st bits of each dot.
    // I.e, if bit 6 in byte 2 is 0, and bit 6 in byte 1 is 1,
    // then the dot has the colour 01.
    // Tiles have signed numbering; sprites (objects) have unsigned numbering.
    //
    // The two tile pattern tables are at 0x8000-0x8FFF, and 0x8800-0x97FF.
    // First one can be used for sprites, background, and window display.
    // Its tiles are numbered 0 to 255.
    //
    // Second one can be used for background and window display.
    // Its tiles are numbered -128 to 127.
    //
    // Window overlays the background.
    // Background wraps around the screen.
    unsigned short windowTileDataSelectStart = 0x8800;
    unsigned short windowTileDataSelectEnd = 0x97FF;
    bool bgMapSigned = true;

    // Background tile map:
    // Each byte contains the number of a tile to display.
    // Tile patterns are taken from windowTileDataSelect.
    unsigned short bgTileMapDisplaySelectStart = 0x9800;
    unsigned short bgTileMapDisplaySelectEnd = 0x9BFF;

    // Object/sprite attribute memory (OAM)
    // 40 blocks, 4 bytes each. Each corresponds to a sprite.
    // Only 10 sprites can be displayed per line.
    unsigned short spriteAttributeTableStart = 0x0FE00;
    unsigned short spriteAttributeTableEnd = 0x0FE9F;

    // Sprite pattern table
    unsigned short spritePatternTableStart = 0x08000;
    unsigned short spritePatternTableEnd = 0x08FFF;

    bool spriteOn = LCDC[0] & (1 >> 1);
    bool bgWindowDisplay = LCDC[0] & 1;

    if (LCDC[0] & (1 >> 2))
    {
        spriteHeight = 16;
    }
    if (LCDC[0] & (1 >> 6))
    {
        windowTileMapDisplaySelectStart = 0x9C00;
        windowTileMapDisplaySelectEnd = 0x9FFF;
    }
    if (LCDC[0] & (1 >> 4))
    {
        windowTileDataSelectStart = 0x8000;
        windowTileDataSelectEnd = 0x8FFF;
        bgMapSigned = false;
    }
    if (LCDC[0] & (1 >> 3))
    {
        bgTileMapDisplaySelectStart = 0x9C00;
        bgTileMapDisplaySelectEnd = 0x9FFF;
    }

    int currLine = *LY & 0xff;
    // Render line "currLine"
    // TODO: Change to only render currLine, not all lines!

    // If BG on:
    if (bgWindowDisplay)
    {
        for (unsigned int i = bgTileMapDisplaySelectStart; i <= bgTileMapDisplaySelectEnd; i += 1)
        {
            // Put data in window buffer array
            unsigned short pixelx = 0;
            unsigned short pixely = 0;
            for (unsigned short offset = bgTileMapDisplaySelectStart; offset <= bgTileMapDisplaySelectEnd; offset++)
            {
                // Double-check these:
                pixelx = (offset - bgTileMapDisplaySelectStart) % 32;
                pixely = (offset - bgTileMapDisplaySelectStart) / 32;
                int8_t index = self.ram[offset];
                // Each tile is 16 bytes.
                unsigned short tileIndex = 0;
                if (bgMapSigned) {
                    tileIndex = index * 16 + 0x09000;
                } else {
                    tileIndex = offset + 16 * index;
                }

                [self setTileOrSprite:tileIndex height:8 width:8 pixelx:pixelx pixely:pixely];
            }

            // ScrollX and ScrollY hold upper left corner to area to display on screen.
        }
    }

    // If OBJ on:
    if (spriteOn)
    {
        // Taken from sprite pattern table, with unsigned indexing.
        // Up to 40 sprites.
        // Sprite pattern table:
        //      - spritePatternTableStart
        // 4-byte blocks in Sprite Attribute Table (OAM):
        //      - spriteAttributeTableStart

        for (unsigned int i = spriteAttributeTableStart; i <= spriteAttributeTableEnd; i += 1)
        {
            unsigned short pixely = self.ram[i] + spritePatternTableStart * 4;
            unsigned short pixelx = self.ram[i+1] + spritePatternTableStart * 4;
            int8_t spriteNumber = self.ram[i+2] + spritePatternTableStart * 4;
            if (spriteHeight == 16) {
                spriteNumber &= 0b01111111;
            }
            int8_t flags = self.ram[i+3] + spritePatternTableStart * 4;
            bool priority = flags & (1 << 7);
            bool y_flip = flags & (1 << 6);
            bool x_flip = flags & (1 << 5);
            int8_t paletteNumber = flags & (1 << 4);

            [self setTileOrSprite:spriteNumber height:spriteHeight width:spriteWidth pixelx:pixelx pixely:pixely];

            // ScrollX and ScrollY hold upper left corner to area to display on screen.
        }

    }

    if (spriteOn || bgWindowDisplay)
    {
        [self printScreenBufferToStandardOut];
    }

    return nil;
}

- (void) setTileOrSprite:(unsigned short)index
                  height:(int8_t)spriteHeight
                   width:(int8_t)spriteWidth
                  pixelx:(unsigned short)pixelx
                  pixely:(unsigned short)pixely
{
    for (unsigned short row = 0; row < spriteHeight; row++) {
        for (unsigned short col = 0; col < spriteWidth; col++) {
            int8_t colour = 0;
            int8_t c0 = self.ram[index + row];
            if (c0 & (1 << (spriteWidth - col))) {
                colour = 1;
            } else {
                colour = 0;
            }
            int8_t c1 = self.ram[index + row + 1];
            if (c1 & (1 << (spriteWidth - col))) {
                colour |= 0b10;
            }
            screenBuffer[pixelx+row][pixely+col] = colour;
        }
    }
}

- (void) printScreenBufferToStandardOut
{
    pthread_mutex_lock(&printMutex);
    printf("Screen Buffer:\n");
    for (int i = 0; i < ScreenWidth; i++) {
        for (int j = 0; j < ScreenHeight; j++) {
            printf("%d", screenBuffer[i][j]);
        }
        printf("\n");
    }
    printf("\n");
    pthread_mutex_unlock(&printMutex);
}

- (UIImage*) fromImage:(UIImage*)source toColourR:(int)colR g:(int)colG b:(int)colB
{
    CGContextRef ctx;
    CGImageRef imageRef = [source CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);

    int byteIndex = 0;
    for (int ii = 0 ; ii < width * height ; ++ii)
    {
        int grey = (rawData[byteIndex] + rawData[byteIndex+1] + rawData[byteIndex+2]) / 3;

        rawData[byteIndex] = Clamp255(colR*grey/256);
        rawData[byteIndex+1] = Clamp255(colG*grey/256);
        rawData[byteIndex+2] = Clamp255(colB*grey/256);

        byteIndex += 4;
    }

    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                bytesPerRow,
                                colorSpace,
                                kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);

    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    CGContextRelease(ctx);
    free(rawData);

    return rawImage;
}

- (time_t) incrementTimerValue
{
    time_t curr = timer + 1;
    pthread_mutex_lock(&timerMutex);
    timer++;
    pthread_mutex_unlock(&timerMutex);
    return curr;
}

- (time_t) getTimerValue
{
    time_t ret = 0;
    pthread_mutex_lock(&timerMutex);
    ret = timer;
    pthread_mutex_unlock(&timerMutex);
    return ret;
}

- (void) clearTimerValue
{
    pthread_mutex_lock(&timerMutex);
    timer = 0;
    DIV[0] = 0;
    DIV[1] = 0;
    pthread_mutex_unlock(&timerMutex);
}

// Timer has frequency of 4.194304 MHz. Top 8 bits have frequency of 16.384 KHz.
- (void) fireTimers
{
    while (isRunning)
    {
        // Busy waiting... Gross
        // Note: TAC bits 0-1 indicate the clock input; bit 2 indicates the timer being on or off.
        // TIMA and TMA store the timer value currently being used. The other counters have their own registers.
        // TMA is loaded when TIMA overflows.
        if (*TAC & 0b0100)
        {
            int8_t counterType = TAC[0] & 0b011;
            /*
             * 00 -> f/2^10
             * 01 -> f/2^4
             * 10 -> f/2^6
             * 11 -> f/2^8
             */
            int8_t shift = 10;
            if (counterType) {
                shift = (counterType + 1) * 2;
            }
            // This has race conditions. :( TODO: Fix!
            short curr = [self incrementTimerValue];
            int8_t value = curr >> (shift-1);
            if (value < (int8_t)(value-1))
            {
                // Overflow!
                self.ram[interruptFlagAddress] |= (1 << TIMER_OVERFLOW);
                PRINTDBG("Timer interrupt occurred! Timer overflowed; %f.\n",
                         (float)(clock() - clock_start) * 1000000000/CLOCKS_PER_SEC);
                clock_start = clock();
            }
            // DIV is a 16-bit register:
            DIV[0] = (curr & 0xff00) >> 2;
            DIV[1] = curr & 0xff;

            *TIMA = value;
            
            sleep(0.000000238418579);
        }
    }
}

// Frequency is 59.7 Hz
- (void) vBlankTimer
{
    // TODO: Does LY continue to increment past 0x90, or does it wait, and the V_BLANK ISR handles it?
    while (isRunning)
    {
        if ((*LY & 0xff) < 0x90)
        {
            *LY = (*LY + 1) & 0xff;
        }
        else if (self.ram[interruptEnableRegister] & (1 >> VERTICAL_BLANK) && (*LY & 0xff) >= 0x90)
        {
            // Generate interrupt
            self.ram[interruptFlagAddress] |= 1 >> VERTICAL_BLANK;

        }
        [self notifyObservers];
        sleep(0.00010875);
    }
}

- (void) runRom
{
    if (self.ram == nil)
    {
        PRINTDBG("Error! ROM is in invalid state! Exiting function.\n");
        return;
    }
    isRunning = true;
    PRINTDBG("\nRunning rom '%s'\n\n", [[self.currentRom romName] cStringUsingEncoding:NSUTF8StringEncoding]);
    interruptsEnabled = 0;
    // AFTER HERE: timer is protected by the "timerMutex" mutex.

    NSThread* timerThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(fireTimers)
                                                   object:nil];
    [timerThread start];
    NSThread* vBlankingThread = [[NSThread alloc] initWithTarget:self
                                                        selector:@selector(vBlankTimer)
                                                          object:nil];
    [vBlankingThread start];


    while ([self.currentState getPC] < ramSize && isRunning)
    {
        // For when enabling interrupts doesn't take effect until after the next instruction.
        // Otherwise, the instruction can directly call the method enableInterrupts
        if (interruptsEnabled == 2)
        {
            enableInterrupts(true, self.ram);
            interruptsEnabled = 0;
        }
        else if (interruptsEnabled == 1)
        {
            interruptsEnabled++;
        }
        else if (interruptsEnabled == -2)
        {
            enableInterrupts(false, self.ram);
            interruptsEnabled = 0;
        }
        else if (interruptsEnabled == -1)
        {
            interruptsEnabled--;
        }
        setKeysInMemory(self.ram, self.buttons);
        [self.currentState incrementPC];
        PRINTDBG("Before:\n");
        [self.currentState printState:self.ram];
        PRINTDBG("\nPC = 0x%02x\n", [self.currentState getPC]);
        incrementPC = true;
        if ([self interruptOccurred])
        {
            PRINTDBG("An interrupt has occurred!\n");
            interruptServiceRoutineCaller(self.currentState, self.ram, &incrementPC, &interruptsEnabled);
        }
        executeInstruction(self.currentState, self.ram, &incrementPC, &interruptsEnabled);

        PRINTDBG("After:\n");
        [self.currentState printState:self.ram];
        PRINTDBG("Interrupt enable register (0xFFFF) = 0x%02x\n", self.ram[interruptEnableRegister] & 0xff);
        PRINTDBG("\n\n");
    }
    [timerThread cancel];
    [vBlankingThread cancel];
}
- (void) setInterruptFlag:(int8_t) bit
{
    assert(bit <= 5 && bit >= 0);
    self.ram[interruptFlagAddress] |= (1 << bit);
    PRINTDBG("Set IF flag bit #%i\n", bit);
}

- (void) pauseRom
{
    isRunning = false;
}

- (BOOL) isRunning
{
    return (BOOL)isRunning;
}

- (void) saveState
{
    PRINTDBG("Saving ROM state -- this needs to be implemented!\n");
}

- (void) stopRom
{
    free(self.ram);
    self.ram = NULL;
    free(self.keys);
    self.keys = NULL;
    self.observers = nil;
}

- (bool) interruptOccurred
{
    return (bool)(self.ram[interruptEnableRegister] & self.ram[interruptFlagAddress]);
}
// Toggle bit corresponding to the specified key press, and write 1
// to corresponding interrupt flag (bit 4)
- (void) pressedKey:(int8_t)offset
{
    assert(offset >= 0 && offset <= 7);
    self.buttons ^= 1 << offset;
    // Only set the flag if interrupts are enabled for joypad input.
    if (self.ram[interruptFlagAddress] & (1 >> JOYPAD_PRESS))
    {
        [self setInterruptFlag:JOYPAD_PRESS];
        PRINTDBG("Triggered JOYPAD_PRESS interrupt.\n");
    }
}
- (void) printKeys
{
    for (int8_t i = 0; i < 8; i++)
    {
        PRINTDBG("buttons[%i] = %i\n", i, self.buttons & (1 << i));
    }
}

@end
