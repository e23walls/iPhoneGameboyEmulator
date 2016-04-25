#import "Rom.h"
#import "RomState.h"
#import "ViewController.h"
#import <pthread.h>

@class ViewController;


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
- (void) addObserver:(ViewController *) observer;
- (void) notifyObservers;
- (UIImage *) updateScreen:(UIImage*) image;
- (void) pauseRom;
- (BOOL) isRunning;
- (void) saveState;
- (void) stopRom;

@end
