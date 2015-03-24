//
//  romState.m
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import "romState.h"

@interface romState ()

@property (nonatomic) unsigned short PC;
@property (nonatomic) unsigned short SP;
@property (nonatomic) int8_t A;
@property (nonatomic) int8_t F; // [Z][N][H][C][0][0][0][0]
@property (nonatomic) int16_t BC;
@property (nonatomic) int16_t DE;
@property (nonatomic) int16_t HL;

@end

@implementation romState

- (romState *) init
{
    self = [super init];
    if (self != nil)
    {
        self.PC = 0;
        self.A = 0;
        self.F = 0;
        self.BC = 0;
        self.DE = 0;
        self.HL = 0;
        self.SP = 0xFFFE; // Highest word location in RAM
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
    return (bool)(self.F & 0b10000000);
}
- (bool) getNFlag
{
    return (bool)(self.F & 0b01000000);
}
- (bool) getHFlag
{
    return (bool)(self.F & 0b00100000);
}
- (bool) getCFlag
{
    return (bool)(self.F & 0b00010000);
}
- (void) printFlags
{
    printf("Z = %i, N = %i, H = %i, C = %i\n",
           [self getZFlag], [self getNFlag],
           [self getHFlag], [self getCFlag]);
}
- (void) setFlags:(bool)Z N:(bool)N H:(bool)H C:(bool)C
{
    // Maybe paranoid; does 'bool x = 4;' get changed to 1?
    self.F = ((Z & 1) << 7) | ((N & 1) << 6) | ((H & 1) << 5) | ((C & 1) << 4);
    [self printFlags];
}

#pragma mark - PC methods

- (void) setPC:(unsigned short)newPC
{
    self.PC = newPC;
}
- (unsigned short) getPC
{
    return self.PC;
}
- (void) incrementPC
{
    self.PC++;
}
- (void) doubleIncPC
{
    self.PC += 2;
}
- (void) addToPC:(int8_t)offset
{
    self.PC += offset;
}

#pragma mark - SP methods

- (void) setSP:(unsigned short)newSP
{
    self.SP = newSP;
}

- (unsigned short) getSP
{
    return self.SP;
}

- (void) addToSP:(int8_t)offset
{
    self.SP += offset;
}

#pragma mark - Regular register methods

- (void) setA:(int8_t) newA
{
    self.A = newA;
}
- (int8_t) getA
{
    return self.A;
}
- (void) setF:(int8_t) newF
{
    self.F = newF;
}
- (int8_t) getF
{
    return self.F;
}
- (void) setB: (int8_t) newB
{
    self.BC = (int16_t)((newB << 8) | (self.BC & 0x0FF));
}
- (int8_t) getB
{
    return (int8_t) (self.BC >> 8);
}
- (void) setC: (int8_t) newC
{
    self.BC = (int16_t) (newC | (self.BC & 0xFF00));
}
- (int8_t) getC
{
    return (int8_t) (self.BC & 0x00FF);
}
- (void) setD: (int8_t) newD
{
    self.DE = (int16_t)((newD << 8) | (self.DE & 0x00FF));
}
- (int8_t) getD
{
    return (int8_t) (self.DE >> 8);
}
- (void) setE: (int8_t) newE
{
    self.DE = (int16_t) (newE | (self.DE & 0xFF00));
}
- (int8_t) getE
{
    return (int8_t) (self.DE & 0x00FF);
}
- (void) setH: (int8_t) newH
{
    self.HL = (int16_t)((newH << 8) | (self.HL & 0x0FF));
}
- (int8_t) getH
{
    return (int8_t) ((self.HL & 0xFF00) >> 8);
}
- (void) setL: (int8_t) newL
{
    self.HL = (int16_t)(newL | ((self.HL & 0xFF00)));
}
- (int8_t) getL
{
    return (int8_t) (self.HL & 0x00FF);
}

#pragma mark - Double register methods (big-endian)

- (int16_t) getAF_big
{
    return (self.A << 8) | self.F;
}
- (int16_t) getAF_little
{
    return (self.F << 8) | self.A;
}

- (int16_t) getBC_big
{
    return self.BC;
}
- (void) setBC_big:(int16_t) newBC
{
    self.BC = newBC;
}
- (int16_t) getDE_big
{
    return self.DE;
}
- (void) setDE_big:(int16_t) newDE
{
    self.DE = newDE;
}
- (int16_t) getHL_big
{
    return self.HL;
}
- (void) setHL_big:(int16_t) newHL
{
    self.HL = newHL;
}

#pragma mark - Double register methods (little-endian)

- (int16_t) getBC_little
{
    return ((self.BC & 0x00FF) << 8) | ((self.BC & 0xFF00) >> 8);
}
- (void) setBC_little:(int16_t) newBC
{
    self.BC = ((newBC & 0x00FF) << 8) | ((newBC & 0xFF00) >> 8);
}
- (int16_t) getDE_little
{
    return ((self.DE & 0x00FF) << 8) | ((self.DE & 0xFF00) >> 8);
}
- (void) setDE_little:(int16_t) newDE
{
    self.DE = ((newDE & 0x00FF) << 8) | ((newDE & 0xFF00) >> 8);
}
- (int16_t) getHL_little
{
    return ((self.HL & 0x00FF) << 8) | ((self.HL & 0xFF00) >> 8);
}
- (void) setHL_little:(int16_t) newHL
{
    self.HL = ((newHL & 0x00FF) << 8) | ((newHL & 0xFF00) >> 8);
}
- (void) printState:(char *)ram
{
    printf("*****************************\n");
    printf("  A = 0x%02x; F = 0x%02x\n", self.A & 0xff, self.F & 0xff);
    printf("  B = 0x%02x; C = 0x%02x\n", ((self.BC & 0xff00) >> 8) & 0xff, self.BC & 0xff);
    printf("  D = 0x%02x; E = 0x%02x\n", ((self.DE & 0xff00) >> 8) & 0xff, self.DE & 0xff);
    printf("  H = 0x%02x; L = 0x%02x\n", ((self.HL & 0xff00) >> 8) & 0xff, self.HL & 0xff);
    [self printFlags];
    printf("  PC = 0x%04x; SP = 0x%04x\n", self.PC & 0xffff, self.SP & 0xffff);
    printf("  Words on stack = %i\n", (0xfffe - self.SP)/2);
    if (ram)
    {
        printf("  [PC] = 0x%02x; [SP] = 0x%02x\n", ram[self.PC] & 0xff, ram[self.SP] & 0xff);
        printf("  [HL] = 0x%02x\n", ram[(unsigned short)self.HL] & 0xff);
    }
    printf("******************************\n");
}


@end
