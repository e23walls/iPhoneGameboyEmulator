//
//  romState.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface romState : NSObject
{
    int PC;
    unsigned char A;
    unsigned char F;
    int16_t BC;
    int16_t DE;
    int16_t HL;
}

- (romState *) init;
- (void) setPC:(int)newPC;
- (int) getPC;
- (void) incrementPC;
- (void) setA:(unsigned char) newA;
- (unsigned char) getA;
- (void) setF:(unsigned char) newF;
- (unsigned char) getF;
- (void) setB: (unsigned char) newB;
- (unsigned char) getB;
- (void) setC: (unsigned char) newC;
- (unsigned char) getC;
- (void) setD: (unsigned char) newD;
- (unsigned char) getD;
- (void) setE: (unsigned char) newE;
- (unsigned char) getE;
- (void) setH: (unsigned char) newH;
- (unsigned char) getH;
- (void) setL: (unsigned char) newL;
- (unsigned char) getL;
- (void) setFlags:(bool) Z and:(bool) N and:(bool) H and:(bool) C;

// Keep track of registers, the display, timers, etc.

@end
