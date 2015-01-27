//
//  romState.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "romState.h"

@implementation romState

- (romState *) init
{
    self = [super init];
    if (self != nil)
    {
        PC = 0;
        A = 0;
        F = 0;
        BC = 0;
        DE = 0;
        HL = 0;
    }
    return self;
}

#pragma mark - Flag methods
// [Z][N][H][C][0][0][0][0]

- (bool) getZFlag
{
    return (bool)(F & 0b10000000);
}
- (bool) getNFlag
{
    return (bool)(F & 0b01000000);
}
- (bool) getHFlag
{
    return (bool)(F & 0b00100000);
}
- (bool) getCFlag
{
    return (bool)(F & 0b00010000);
}

- (void) setFlags:(bool)Z N:(bool)N H:(bool)H C:(bool)C
{
    F = (Z << 7) | (N << 6) | (H << 5) | (C << 4);
}

#pragma mark - PC methods

- (void) setPC:(int)newPC
{
    PC = newPC;
}
- (int) getPC
{
    return PC;
}
- (void) incrementPC
{
    PC++;
}

#pragma mark - SP methods

- (void) setSP:(int)newSP
{
    SP = newSP;
}

- (int) getSP
{
    return SP;
}

#pragma mark - Regular register methods

- (void) setA:(unsigned char) newA
{
    A = newA;
}
- (unsigned char) getA
{
    return A;
}
- (void) setF:(unsigned char) newF
{
    F = newF;
}
- (unsigned char) getF
{
    return F;
}
- (void) setB: (unsigned char) newB
{
    BC = (int16_t)(newB << 8) | (BC & 0x0F);
}
- (unsigned char) getB
{
    return (unsigned char) (BC >> 8);
}
- (void) setC: (unsigned char) newC
{
    BC = (int16_t) newC | (BC & 0xF0);
}
- (unsigned char) getC
{
    return (unsigned char) (BC & 0x0F);
}
- (void) setD: (unsigned char) newD
{
    DE = (newD << 8) | (DE & 0x0F);
}
- (unsigned char) getD
{
    return (unsigned char) (DE >> 8);
}
- (void) setE: (unsigned char) newE
{
    DE = (int16_t) newE | (DE & 0xF0);
}
- (unsigned char) getE
{
    return (unsigned char) (DE & 0x0F);
}
- (void) setH: (unsigned char) newH
{
    HL = (newH << 8) | (HL & 0x0F);
}
- (unsigned char) getH
{
    return (unsigned char) (HL >> 8);
}
- (void) setL: (unsigned char) newL
{
    HL = (int16_t) newL | (HL & 0xF0);
}
- (unsigned char) getL
{
    return (unsigned char) (HL & 0x0F);
}

#pragma mark - Double register methods (big-endian)

- (int16_t) getBC_big
{
    return BC;
}
- (void) setBC_big:(int16_t) newBC
{
    BC = newBC;
}
- (int16_t) getDE_big
{
    return DE;
}
- (void) setDE_big:(int16_t) newDE
{
    DE = newDE;
}
- (int16_t) getHL_big
{
    return HL;
}
- (void) setHL_big:(int16_t) newHL
{
    HL = newHL;
}

#pragma mark - Double register methods (little-endian)

- (int16_t) getBC_little
{
    return ((BC & 0x0F) << 4) | ((BC & 0xF0) >> 4);
}
- (void) setBC_little:(int16_t) newBC
{
    BC = ((newBC & 0x0F) << 4) | ((newBC & 0xF0) >> 4);
}
- (int16_t) getDE_little
{
    return ((DE & 0x0F) << 4) | ((DE & 0xF0) >> 4);
}
- (void) setDE_little:(int16_t) newDE
{
    DE = ((newDE & 0x0F) << 4) | ((newDE & 0xF0) >> 4);
}
- (int16_t) getHL_little
{
    return ((HL & 0x0F) << 4) | ((HL & 0xF0) >> 4);
}
- (void) setHL_little:(int16_t) newHL
{
    HL = ((newHL & 0x0F) << 4) | ((newHL & 0xF0) >> 4);
}

@end
