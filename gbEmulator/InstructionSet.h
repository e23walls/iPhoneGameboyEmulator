//
//  InstructionSet.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-08-13.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#ifndef gbEmulator_InstructionSet_h
#define gbEmulator_InstructionSet_h

@class RomState;

extern void (^execute0x00Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x01Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x02Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x03Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x04Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x05Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x06Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x07Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x08Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x09Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x0AInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x0BInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x0CInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x0DInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x0EInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x0FInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0x10Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x11Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x12Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x13Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x14Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x15Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x16Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x17Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x18Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x19Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x1AInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x1BInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x1CInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x1DInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x1EInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x1FInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0x20Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x21Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x22Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x23Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x24Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x25Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x26Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x27Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x28Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x29Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x2AInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x2BInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x2CInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x2DInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x2EInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x2FInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0x30Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x31Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x32Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x33Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x34Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x35Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x36Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x37Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x38Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x39Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x3AInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x3BInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x3CInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x3DInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x3EInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x3FInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0x40Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x41Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x42Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x43Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x44Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x45Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x46Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x47Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x48Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x49Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x4AInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x4BInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x4CInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x4DInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x4EInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x4FInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0x50Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x51Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x52Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x53Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x54Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x55Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x56Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x57Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x58Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x59Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x5AInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x5BInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x5CInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x5DInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x5EInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x5FInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0x60Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x61Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x62Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x63Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x64Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x65Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x66Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x67Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x68Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x69Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x6AInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x6BInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x6CInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x6DInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x6EInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x6FInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0x70Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x71Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x72Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x73Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x74Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x75Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x76Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x77Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x78Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x79Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x7AInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x7BInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x7CInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x7DInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x7EInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x7FInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0x80Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x81Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x82Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x83Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x84Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x85Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x86Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x87Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x88Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x89Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x8AInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x8BInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x8CInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x8DInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x8EInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x8FInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0x90Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x91Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x92Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x93Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x94Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x95Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x96Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x97Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x98Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x99Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x9AInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x9BInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x9CInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x9DInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x9EInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0x9FInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0xA0Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xA1Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xA2Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xA3Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xA4Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xA5Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xA6Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xA7Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xA8Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xA9Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xAAInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xABInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xACInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xADInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xAEInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xAFInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0xB0Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xB1Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xB2Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xB3Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xB4Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xB5Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xB6Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xB7Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xB8Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xB9Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xBAInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xBBInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xBCInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xBDInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xBEInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xBFInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0xC0Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xC1Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xC2Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xC3Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xC4Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xC5Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xC6Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xC7Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xC8Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xC9Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xCAInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xCBInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xCCInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xCDInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xCEInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xCFInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0xD0Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xD1Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xD2Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xD3Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xD4Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xD5Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xD6Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xD7Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xD8Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xD9Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xDAInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xDBInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xDCInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xDDInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xDEInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xDFInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0xE0Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xE1Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xE2Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xE3Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xE4Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xE5Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xE6Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xE7Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xE8Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xE9Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xEAInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xEBInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xECInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xEDInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xEEInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xEFInstruction)(RomState *, char *, bool *, int8_t *);

extern void (^execute0xF0Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xF1Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xF2Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xF3Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xF4Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xF5Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xF6Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xF7Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xF8Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xF9Instruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xFAInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xFBInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xFCInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xFDInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xFEInstruction)(RomState *, char *, bool *, int8_t *);
extern void (^execute0xFFInstruction)(RomState *, char *, bool *, int8_t *);

@interface InstructionDictionary : NSObject
+ (NSDictionary *) getConstDictionary;
@end

#endif
