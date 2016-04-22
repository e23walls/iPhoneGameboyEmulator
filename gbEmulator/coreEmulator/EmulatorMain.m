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
    int screenBuffer[ScreenWidth][ScreenHeight];
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
        isRunning = true;
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
        char start[] = {0xce, 0x01, 0x00, 0x50, 0xde, 0x00, 0x60, 0xcd, 0x34, 0x83, 0xdf, 0x04, 0xde, 0xd9, 0x00, 0xf1, 0xee, 0xc1, 0x7f, 0xcd, 0x1d, 0xf3, 0xc1, 0x9c, 0x1d, 0xcd, 0xc1, 0x88, 0x88, 0xc1, 0x03, 0x1f, 0xb8, 0xee, 0xfb, 0xfe, 0xde, 0xef, 0x7f, 0xe5, 0x32, 0x6a, 0xff, 0x32, 0x69, 0xff, 0xec, 0x84, 0x01, 0xcb, 0xdf, 0x0c, 0xee, 0x27, 0xff, 0xf9, 0xf7, 0xe5, 0xec, 0xdd, 0xdc, 0xfa, 0xdf, 0x06, 0xc1, 0xe6, 0x15, 0xef, 0x66, 0xde, 0xd0, 0x66, 0xf1, 0xf3, 0xc2, 0xd7, 0xf7, 0xcd, 0xf2, 0xdf, 0x06, 0xd1, 0xf0, 0xe7, 0x0c, 0x98, 0xc1, 0x9b, 0xa8, 0x1f, 0xbd, 0xc1, 0x6e, 0x1f, 0xbf, 0xfb, 0xe1, 0xfd, 0xf1, 0xf3, 0x0f, 0xbb, 0x01, 0x6f, 0xdf, 0x05, 0xf2, 0xdf, 0x08, 0xe2, 0xdf, 0x0d, 0xf1, 0xec, 0xdb, 0x83, 0xe1, 0x7c, 0x01, 0x9d, 0xd7, 0xf9, 0xe1, 0x3e, 0x01, 0x9b, 0xdf, 0xf9, 0x84, 0x1d, 0xf3, 0xc1, 0x78, 0x1d, 0x0f, 0xbd, 0x6f, 0x1f, 0xbd, 0xea, 0xdf, 0x2d, 0xfa, 0xdf, 0xb0, 0xe9, 0xdf, 0xe7, 0x34, 0xb0, 0xf9, 0xfb, 0x3a, 0x34, 0xee, 0xe8, 0x3e, 0x34, 0xee, 0xe8, 0xfa, 0xdf, 0x0a, 0xdd, 0xdc, 0xdd, 0xdc, 0x36, 0x31, 0x12, 0x99, 0x99, 0x33, 0xf2, 0xff, 0xf4, 0xfc, 0x8c, 0xff, 0x7c, 0xff, 0xf3, 0xff, 0xf2, 0xff, 0xf7, 0xee, 0xe0, 0x77, 0x76, 0xff, 0xf1, 0x23, 0x33, 0x91, 0x19, 0x22, 0x22, 0x26, 0x66, 0x44, 0x44, 0x98, 0x9c, 0x91, 0xf1, 0x13, 0x33, 0x22, 0x23, 0x66, 0x60, 0x44, 0x46, 0xcc, 0xc1, 0xc3, 0xbd, 0x46, 0x5a, 0x46, 0x5a, 0xbd, 0xc3, 0xde, 0xfb, 0xfe, 0xee, 0x57, 0xff, 0xe5, 0xec, 0x41, 0xdf, 0x01, 0xdc, 0x82, 0x01, 0xcb, 0xdf, 0x0a, 0xf9, 0xe6, 0x87, 0x79, 0xdc, 0xfa, 0xdf, 0x04, 0x79, 0xdf, 0x01, 0xc1, 0xfe, 0x1f, 0xaf};
        
        // Load the ROM file into RAM

        FILE * romFileHandler = fopen([self.currentRom.fullPath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
        if (romFileHandler == NULL)
        {
            printf("Some error occurred when opening the ROM.\n");
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
                printf("HIT EOF!\n");
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
            printf("Warning: EOF was reached before RAM was filled.\n");
        }
        else
        {
            printf("As expected, EOF was not reached before end of RAM.\n");
        }
        fclose(romFileHandler);
        NSLog(@"Setting up the ROM initial state...");
        self.currentState = [[RomState alloc] init];
        enableInterrupts(false, self.ram);
        NSLog(@"Loading BIOS into RAM...");
        for (int i = 0; i < biosSize; i++)
        {
            self.ram[i] = start[i] ^ 0xff;
        }
        [self setupRegisters];
    }
    else
    {
        printf("Error! Couldn't allocate memory for emulator.\n");
    }
    return self;
}

- (void) dealloc
{
    free(self.ram);
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
    int spriteWidth = 8;
    int spriteHeight = 8;
    unsigned short windowTileMapDisplaySelectStart = 0x9800;
    unsigned short windowTileMapDisplaySelectEnd = 0x9BFF;
    unsigned short windowTileDataSelectStart = 0x8800;
    unsigned short windowTileDataSelectEnd = 0x97FF;
    unsigned short bgTileMapDisplaySelectStart = 0x9800;
    unsigned short bgTileMapDisplaySelectEnd = 0x9BFF;
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
    }
    if (LCDC[0] & (1 >> 3))
    {
        bgTileMapDisplaySelectStart = 0x9C00;
        bgTileMapDisplaySelectEnd = 0x9FFF;
    }

    int currLine = *LY;
    // Render line "currLine"

    return nil;
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
    while (true)
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
    while (true)
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
    PRINTDBG("\nRunning rom '%s'\n\n", [[self.currentRom romName] cStringUsingEncoding:NSUTF8StringEncoding]);
    interruptsEnabled = 0;
    // This is probably necessary...
    self.ram[interruptFlagAddress] = 0;
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
        printf("Before:\n");
        [self.currentState printState:self.ram];
        PRINTDBG("\nPC = 0x%02x\n", [self.currentState getPC]);
        incrementPC = true;
        if ([self interruptOccurred])
        {
            PRINTDBG("An interrupt has occurred!\n");
            interruptServiceRoutineCaller(self.currentState, self.ram, &incrementPC, &interruptsEnabled);
        }
        executeInstruction(self.currentState, self.ram, &incrementPC, &interruptsEnabled);

        printf("After:\n");
        [self.currentState printState:self.ram];
        printf("Interrupt enable register (0xFFFF) = 0x%02x\n", self.ram[interruptEnableRegister] & 0xff);
        printf("\n\n");
    }
    [timerThread cancel];
}
- (void) setInterruptFlag:(int8_t) bit
{
    assert(bit <= 5 && bit >= 0);
    self.ram[interruptFlagAddress] |= (1 << bit);
    PRINTDBG("Set IF flag bit #%i\n", bit);
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
        printf("buttons[%i] = %i\n", i, self.buttons & (1 << i));
    }
}

@end