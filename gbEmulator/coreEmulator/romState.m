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
    else
    {
        printf("Error! Couldn't allocate memory for ROM state\n");
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
- (unsigned int) getPC
{
    return PC;
}
- (void) incrementPC
{
    PC++;
}
- (void) addToPC:(int8_t)offset
{
    PC += offset;
}

#pragma mark - SP methods

- (void) setSP:(int)newSP
{
    SP = newSP;
}

- (unsigned int) getSP
{
    return SP;
}

#pragma mark - Regular register methods

- (void) setA:(int8_t) newA
{
    A = newA;
}
- (int8_t) getA
{
    return A;
}
- (void) setF:(int8_t) newF
{
    F = newF;
}
- (int8_t) getF
{
    return F;
}
- (void) setB: (int8_t) newB
{
    BC = (int16_t)((newB << 8) | (BC & 0x0F));
}
- (int8_t) getB
{
    return (int8_t) (BC >> 8);
}
- (void) setC: (int8_t) newC
{
    BC = (int16_t) (newC | (BC & 0xF0));
}
- (int8_t) getC
{
    return (int8_t) (BC & 0x0F);
}
- (void) setD: (int8_t) newD
{
    DE = (int16_t)((newD << 8) | (DE & 0x0F));
}
- (int8_t) getD
{
    return (int8_t) (DE >> 8);
}
- (void) setE: (int8_t) newE
{
    DE = (int16_t) newE | (DE & 0xF0);
}
- (int8_t) getE
{
    return (int8_t) (DE & 0x0F);
}
- (void) setH: (int8_t) newH
{
    HL = (int16_t)((newH << 8) | (HL & 0x0F));
}
- (int8_t) getH
{
    return (int8_t) (HL >> 8);
}
- (void) setL: (int8_t) newL
{
    HL = (int16_t)( newL | (HL & 0xF0));
}
- (int8_t) getL
{
    return (int8_t) (HL & 0x0F);
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
