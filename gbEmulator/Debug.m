#import "Debug.h"

@implementation Debug
{
    pthread_mutex_t printMutex;
}

- (Debug *) init
{
    self = [super init];
    if (self)
    {
        pthread_mutex_init(&printMutex, NULL);
    }
    return self;
}

+ (Debug *) sharedInstance
{
    static Debug *sharedDbg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDbg = [[Debug alloc] init];
    });
    return sharedDbg;
}

- (void) acquirePrintLock
{
    pthread_mutex_lock(&printMutex);
}

- (void) releasePrintLock
{
    pthread_mutex_unlock(&printMutex);
}

@end