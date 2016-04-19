//
//  emulatorMain.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "EmulatorMain.h"
#include <sys/stat.h>

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
}

@property int8_t * ram;
@property Rom * currentRom;
@property RomState * currentState;
@property NSTimer * t;
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
        start = 0;
        timer = 0;
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
            self.ram[counter+biosSize] = (int8_t)ch;
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
            self.ram[i] = bios[i];
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

-(void) setupRegisters
{
    WX = self.ram + 0x0FF4B;
    WY = self.ram + 0x0FF4A;
    SCX = self.ram + 0x0FF43;
    SCY = self.ram + 0x0FF42;
    LCDC = self.ram + 0x0FF40;
    STAT = self.ram + 0x0FF41;
    LY = self.ram + 0x0FF44;
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
        // This could be slightly off because we don't know the
        // length of the current instruction at this point. It will
        // always be pointing 1 byte ahead of the current instruction.
        // If the current instruction is 1 byte, it should be correct.
        // ^ That's an old comment...
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
    [self setInterruptFlag:JOYPAD_PRESS];
}
- (void) printKeys
{
    for (int8_t i = 0; i < 8; i++)
    {
        printf("buttons[%i] = %i\n", i, self.buttons & (1 << i));
    }
}

@end
