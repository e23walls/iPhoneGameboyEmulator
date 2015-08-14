#import "Rom.h"
#import "RomState.h"

#define MYDEBUG

#ifdef MYDEBUG
#define PRINTDBG(...) printf(__VA_ARGS__)
#else
#define PRINTDBG(...) ;
#endif

enum interruptFlagBitNames
{
    VERTICAL_BLANK,
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

@end
