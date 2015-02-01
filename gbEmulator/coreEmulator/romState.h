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
    unsigned int PC;
    unsigned int SP;
    int8_t A;
    int8_t F; // [Z][N][H][C][0][0][0][0]
    int16_t BC;
    int16_t DE;
    int16_t HL;
}

- (romState *) init;
- (void) setPC:(int)newPC;
- (unsigned int) getPC;
- (void) incrementPC;
- (void) addToPC:(int8_t)offset;
- (void) setSP:(int)newSP;
- (unsigned int) getSP;
- (void) setA:(int8_t) newA;
- (int8_t) getA;
- (void) setF:(int8_t) newF;
- (int8_t) getF;
- (void) setB: (int8_t) newB;
- (int8_t) getB;
- (void) setC: (int8_t) newC;
- (int8_t) getC;
- (void) setD: (int8_t) newD;
- (int8_t) getD;
- (void) setE: (int8_t) newE;
- (int8_t) getE;
- (void) setH: (int8_t) newH;
- (int8_t) getH;
- (void) setL: (int8_t) newL;
- (int8_t) getL;
- (int16_t) getBC_big;
- (void) setBC_big:(int16_t) newBC;
- (int16_t) getBC_little;
- (void) setBC_little:(int16_t) newBC;
- (int16_t) getDE_big;
- (void) setDE_big:(int16_t) newDE;
- (int16_t) getDE_little;
- (void) setDE_little:(int16_t) newDE;
- (int16_t) getHL_big;
- (void) setHL_big:(int16_t) newHL;
- (int16_t) getHL_little;
- (void) setHL_little:(int16_t) newHL;
- (void) setFlags:(bool) Z N:(bool) N H:(bool) H C:(bool) C;
- (bool) getZFlag;
- (bool) getNFlag;
- (bool) getHFlag;
- (bool) getCFlag;

// Keep track of registers, the display, timers, etc.

@end
