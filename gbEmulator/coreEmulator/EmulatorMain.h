#import "Rom.h"
#import "RomState.h"
#import <pthread.h>

#define MYDEBUG

#ifdef MYDEBUG
#define PRINTDBG(...) printf(__VA_ARGS__)
#else
#define PRINTDBG(...) ;
#endif

enum interruptFlagBitNames
{
    VERTICAL_BLANK = 0,
    LCD_STATUS_TRIGGERS,
    TIMER_OVERFLOW,
    SERIAL_LINK,
    JOYPAD_PRESS
};

@interface EmulatorMain : NSObject

- (EmulatorMain *) initWithRom: (Rom *) theRom;
- (void) runRom;
- (void) pressedKey:(int8_t)offset;
- (void) printKeys;
- (UIImage *) getScreen;
- (void) fireTimers;
- (time_t) incrementTimerValue;
- (void) clearTimerValue;
- (time_t) getTimerValue;

@end
