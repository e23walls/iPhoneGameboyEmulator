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
    unsigned char F; // [Z][N][H][C][0][0][0][0]
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
