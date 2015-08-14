//
//  InstructionSet.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-08-13.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#ifndef gbEmulator_InstructionSet_h
#define gbEmulator_InstructionSet_h

@class romState;

extern void (^execute0x00Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x01Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x02Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x03Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x04Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x05Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x06Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x07Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x08Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x09Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x0AInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x0BInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x0CInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x0DInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x0EInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x0FInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0x10Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x11Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x12Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x13Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x14Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x15Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x16Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x17Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x18Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x19Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x1AInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x1BInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x1CInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x1DInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x1EInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x1FInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0x20Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x21Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x22Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x23Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x24Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x25Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x26Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x27Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x28Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x29Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x2AInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x2BInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x2CInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x2DInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x2EInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x2FInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0x30Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x31Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x32Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x33Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x34Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x35Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x36Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x37Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x38Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x39Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x3AInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x3BInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x3CInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x3DInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x3EInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x3FInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0x40Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x41Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x42Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x43Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x44Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x45Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x46Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x47Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x48Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x49Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x4AInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x4BInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x4CInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x4DInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x4EInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x4FInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0x50Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x51Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x52Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x53Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x54Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x55Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x56Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x57Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x58Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x59Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x5AInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x5BInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x5CInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x5DInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x5EInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x5FInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0x60Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x61Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x62Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x63Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x64Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x65Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x66Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x67Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x68Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x69Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x6AInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x6BInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x6CInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x6DInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x6EInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x6FInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0x70Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x71Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x72Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x73Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x74Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x75Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x76Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x77Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x78Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x79Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x7AInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x7BInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x7CInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x7DInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x7EInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x7FInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0x80Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x81Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x82Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x83Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x84Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x85Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x86Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x87Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x88Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x89Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x8AInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x8BInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x8CInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x8DInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x8EInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x8FInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0x90Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x91Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x92Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x93Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x94Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x95Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x96Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x97Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x98Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x99Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x9AInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x9BInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x9CInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x9DInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x9EInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0x9FInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0xA0Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xA1Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xA2Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xA3Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xA4Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xA5Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xA6Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xA7Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xA8Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xA9Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xAAInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xABInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xACInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xADInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xAEInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xAFInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0xB0Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xB1Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xB2Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xB3Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xB4Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xB5Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xB6Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xB7Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xB8Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xB9Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xBAInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xBBInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xBCInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xBDInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xBEInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xBFInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0xC0Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xC1Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xC2Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xC3Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xC4Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xC5Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xC6Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xC7Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xC8Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xC9Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xCAInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xCBInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xCCInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xCDInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xCEInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xCFInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0xD0Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xD1Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xD2Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xD3Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xD4Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xD5Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xD6Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xD7Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xD8Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xD9Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xDAInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xDBInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xDCInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xDDInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xDEInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xDFInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0xE0Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xE1Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xE2Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xE3Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xE4Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xE5Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xE6Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xE7Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xE8Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xE9Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xEAInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xEBInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xECInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xEDInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xEEInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xEFInstruction)(romState *, char *, bool *, int8_t *);

extern void (^execute0xF0Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xF1Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xF2Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xF3Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xF4Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xF5Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xF6Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xF7Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xF8Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xF9Instruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xFAInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xFBInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xFCInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xFDInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xFEInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xFFInstruction)(romState *, char *, bool *, int8_t *);

@interface InstructionDictionary : NSObject
+ (NSDictionary *) getConstDictionary;
@end

#endif
