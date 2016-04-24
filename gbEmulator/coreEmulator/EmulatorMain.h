#import "Rom.h"
#import "RomState.h"
#import "ViewController.h"
#import <pthread.h>

@class ViewController;

#define MYDEBUG

#ifdef MYDEBUG
// NOTE: DO NOT USE PRINTDBG IF "printMutex" LOCK HAS BEEN ACQUIRED! It will cause a deadlock. USE PRINTDBGNOLOCK!
#define PRINTDBG(...) ; pthread_mutex_lock(&printMutex); printf(__VA_ARGS__); pthread_mutex_unlock(&printMutex);
#define PRINTDBGNOLOCK(...) ; printf(__VA_ARGS__);
#else
#define PRINTDBG(...) ;
#define PRINTDBGNOLOCK(...) ;
#endif

#define ScreenWidth 160
#define ScreenHeight 144
#define BufferWidth 256
#define BufferHeight 256

// Change where this is so that it doesn't get used before being initialized.
pthread_mutex_t printMutex;

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
