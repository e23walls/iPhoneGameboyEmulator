#ifndef Debug_h
#define Debug_h
#import <pthread.h>

#define MYDEBUG

#ifdef MYDEBUG
// NOTE: DO NOT USE PRINTDBG IF "printMutex" LOCK HAS BEEN ACQUIRED! It will cause a deadlock. USE PRINTDBGNOLOCK!
#define PRINTDBG(...) ; [[Debug sharedInstance] acquirePrintLock]; printf(__VA_ARGS__); [[Debug sharedInstance] releasePrintLock];
#define PRINTDBGNOLOCK(...) ; printf(__VA_ARGS__);
#else
#define PRINTDBG(...) ;
#define PRINTDBGNOLOCK(...) ;
#endif

@interface Debug : NSObject

+ (Debug *) sharedInstance;
- (void) acquirePrintLock;
- (void) releasePrintLock;

@end

#endif /* Debug_h */
