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
- (void) setFlags:(bool)Z and:(bool)N and:(bool)H and:(bool)C
{
    F = (Z << 7) | (N << 6) | (H << 5) | (C << 4);
}
- (void) setPC:(int)newPC
{
    PC = newPC;
}
- (int) getPC
{
    return PC;
}
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

@end
