#import "InstructionSet.h"

@implementation InstructionDictionary

+ (NSDictionary *) getConstDictionary {
    static NSDictionary *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                // 0x0X Instructions
        inst = @{@(0x00) : execute0x00Instruction, @(0x01) : execute0x01Instruction,
                 @(0x02) : execute0x02Instruction,
                 @(0x03) : execute0x03Instruction, @(0x04) : execute0x04Instruction,
                 @(0x05) : execute0x05Instruction,
                 @(0x06) : execute0x06Instruction, @(0x07) : execute0x07Instruction,
                 @(0x08) : execute0x08Instruction,
                 @(0x09) : execute0x09Instruction, @(0x0A) : execute0x0AInstruction,
                 @(0x0B) : execute0x0BInstruction,
                 @(0x0C) : execute0x0CInstruction, @(0x0D) : execute0x0DInstruction,
                 @(0x0E) : execute0x0EInstruction, @(0x0F) : execute0x0FInstruction,

                 // 0x1X Instructions
                 @(0x10) : execute0x10Instruction, @(0x11) : execute0x11Instruction,
                 @(0x12) : execute0x12Instruction,
                 @(0x13) : execute0x13Instruction, @(0x14) : execute0x14Instruction,
                 @(0x15) : execute0x15Instruction,
                 @(0x16) : execute0x16Instruction, @(0x17) : execute0x17Instruction,
                 @(0x18) : execute0x18Instruction,
                 @(0x19) : execute0x19Instruction, @(0x1A) : execute0x1AInstruction,
                 @(0x1B) : execute0x1BInstruction,
                 @(0x1C) : execute0x1CInstruction, @(0x1D) : execute0x1DInstruction,
                 @(0x1E) : execute0x1EInstruction, @(0x1F) : execute0x1FInstruction,

                 // 0x2X Instructions
                 @(0x20) : execute0x20Instruction, @(0x21) : execute0x21Instruction,
                 @(0x22) : execute0x22Instruction,
                 @(0x23) : execute0x23Instruction, @(0x24) : execute0x24Instruction,
                 @(0x25) : execute0x25Instruction,
                 @(0x26) : execute0x26Instruction, @(0x27) : execute0x27Instruction,
                 @(0x28) : execute0x28Instruction,
                 @(0x29) : execute0x29Instruction, @(0x2A) : execute0x2AInstruction,
                 @(0x2B) : execute0x2BInstruction,
                 @(0x2C) : execute0x2CInstruction, @(0x2D) : execute0x2DInstruction,
                 @(0x2E) : execute0x2EInstruction, @(0x2F) : execute0x2FInstruction,

                 // 0x3X Instructions
                 @(0x30) : execute0x30Instruction, @(0x31) : execute0x31Instruction,
                 @(0x32) : execute0x32Instruction,
                 @(0x33) : execute0x33Instruction, @(0x34) : execute0x34Instruction,
                 @(0x35) : execute0x35Instruction,
                 @(0x36) : execute0x36Instruction, @(0x37) : execute0x37Instruction,
                 @(0x38) : execute0x38Instruction,
                 @(0x39) : execute0x39Instruction, @(0x3A) : execute0x3AInstruction,
                 @(0x3B) : execute0x3BInstruction,
                 @(0x3C) : execute0x3CInstruction, @(0x3D) : execute0x3DInstruction,
                 @(0x3E) : execute0x3EInstruction, @(0x3F) : execute0x3FInstruction,

                 // 0x4X Instructions
                 @(0x40) : execute0x40Instruction, @(0x41) : execute0x41Instruction,
                 @(0x42) : execute0x42Instruction,
                 @(0x43) : execute0x43Instruction, @(0x44) : execute0x44Instruction,
                 @(0x45) : execute0x45Instruction,
                 @(0x46) : execute0x46Instruction, @(0x47) : execute0x47Instruction,
                 @(0x48) : execute0x48Instruction,
                 @(0x49) : execute0x49Instruction, @(0x4A) : execute0x4AInstruction,
                 @(0x4B) : execute0x4BInstruction,
                 @(0x4C) : execute0x4CInstruction, @(0x4D) : execute0x4DInstruction,
                 @(0x4E) : execute0x4EInstruction, @(0x4F) : execute0x4FInstruction,

                 // 0x5X Instructions
                 @(0x50) : execute0x50Instruction, @(0x51) : execute0x51Instruction,
                 @(0x52) : execute0x52Instruction,
                 @(0x53) : execute0x53Instruction, @(0x54) : execute0x54Instruction,
                 @(0x55) : execute0x55Instruction,
                 @(0x56) : execute0x56Instruction, @(0x57) : execute0x57Instruction,
                 @(0x58) : execute0x58Instruction,
                 @(0x59) : execute0x59Instruction, @(0x5A) : execute0x5AInstruction,
                 @(0x5B) : execute0x5BInstruction,
                 @(0x5C) : execute0x5CInstruction, @(0x5D) : execute0x5DInstruction,
                 @(0x5E) : execute0x5EInstruction, @(0x5F) : execute0x5FInstruction,

                 // 0x6X Instructions
                 @(0x60) : execute0x60Instruction, @(0x61) : execute0x61Instruction,
                 @(0x62) : execute0x62Instruction,
                 @(0x63) : execute0x63Instruction, @(0x64) : execute0x64Instruction,
                 @(0x65) : execute0x65Instruction,
                 @(0x66) : execute0x66Instruction, @(0x67) : execute0x67Instruction,
                 @(0x68) : execute0x68Instruction,
                 @(0x69) : execute0x69Instruction, @(0x6A) : execute0x6AInstruction,
                 @(0x6B) : execute0x6BInstruction,
                 @(0x6C) : execute0x6CInstruction, @(0x6D) : execute0x6DInstruction,
                 @(0x6E) : execute0x6EInstruction, @(0x6F) : execute0x6FInstruction,

                 // 0x7X Instructions
                 @(0x70) : execute0x70Instruction, @(0x71) : execute0x71Instruction,
                 @(0x72) : execute0x72Instruction,
                 @(0x73) : execute0x73Instruction, @(0x74) : execute0x74Instruction,
                 @(0x75) : execute0x75Instruction,
                 @(0x76) : execute0x76Instruction, @(0x77) : execute0x77Instruction,
                 @(0x78) : execute0x78Instruction,
                 @(0x79) : execute0x79Instruction, @(0x7A) : execute0x7AInstruction,
                 @(0x7B) : execute0x7BInstruction,
                 @(0x7C) : execute0x7CInstruction, @(0x7D) : execute0x7DInstruction,
                 @(0x7E) : execute0x7EInstruction, @(0x7F) : execute0x7FInstruction,

                 // 0x8X Instructions
                 @(0x80) : execute0x80Instruction, @(0x81) : execute0x81Instruction,
                 @(0x82) : execute0x82Instruction,
                 @(0x83) : execute0x83Instruction, @(0x84) : execute0x84Instruction,
                 @(0x85) : execute0x85Instruction,
                 @(0x86) : execute0x86Instruction, @(0x87) : execute0x87Instruction,
                 @(0x88) : execute0x88Instruction,
                 @(0x89) : execute0x89Instruction, @(0x8A) : execute0x8AInstruction,
                 @(0x8B) : execute0x8BInstruction,
                 @(0x8C) : execute0x8CInstruction, @(0x8D) : execute0x8DInstruction,
                 @(0x8E) : execute0x8EInstruction, @(0x8F) : execute0x8FInstruction,

                 // 0x9X Instructions
                 @(0x90) : execute0x90Instruction, @(0x91) : execute0x91Instruction,
                 @(0x92) : execute0x92Instruction,
                 @(0x93) : execute0x93Instruction, @(0x94) : execute0x94Instruction,
                 @(0x95) : execute0x95Instruction,
                 @(0x96) : execute0x96Instruction, @(0x97) : execute0x97Instruction,
                 @(0x98) : execute0x98Instruction,
                 @(0x99) : execute0x99Instruction, @(0x9A) : execute0x9AInstruction,
                 @(0x9B) : execute0x9BInstruction,
                 @(0x9C) : execute0x9CInstruction, @(0x9D) : execute0x9DInstruction,
                 @(0x9E) : execute0x9EInstruction, @(0x9F) : execute0x9FInstruction,

                 // 0xAX Instructions
                 @(0xA0) : execute0xA0Instruction, @(0xA1) : execute0xA1Instruction,
                 @(0xA2) : execute0xA2Instruction,
                 @(0xA3) : execute0xA3Instruction, @(0xA4) : execute0xA4Instruction,
                 @(0xA5) : execute0xA5Instruction,
                 @(0xA6) : execute0xA6Instruction, @(0xA7) : execute0xA7Instruction,
                 @(0xA8) : execute0xA8Instruction,
                 @(0xA9) : execute0xA9Instruction, @(0xAA) : execute0xAAInstruction,
                 @(0xAB) : execute0xABInstruction,
                 @(0xAC) : execute0xACInstruction, @(0xAD) : execute0xADInstruction,
                 @(0xAE) : execute0xAEInstruction, @(0xAF) : execute0xAFInstruction,

                 // 0xBX Instructions
                 @(0xB0) : execute0xB0Instruction, @(0xB1) : execute0xB1Instruction,
                 @(0xB2) : execute0xB2Instruction,
                 @(0xB3) : execute0xB3Instruction, @(0xB4) : execute0xB4Instruction,
                 @(0xB5) : execute0xB5Instruction,
                 @(0xB6) : execute0xB6Instruction, @(0xB7) : execute0xB7Instruction,
                 @(0xB8) : execute0xB8Instruction,
                 @(0xB9) : execute0xB9Instruction, @(0xBA) : execute0xBAInstruction,
                 @(0xBB) : execute0xBBInstruction,
                 @(0xBC) : execute0xBCInstruction, @(0xBD) : execute0xBDInstruction,
                 @(0xBE) : execute0xBEInstruction, @(0xBF) : execute0xBFInstruction,

                 // 0xCX Instructions
                 @(0xC0) : execute0xC0Instruction, @(0xC1) : execute0xC1Instruction,
                 @(0xC2) : execute0xC2Instruction,
                 @(0xC3) : execute0xC3Instruction, @(0xC4) : execute0xC4Instruction,
                 @(0xC5) : execute0xC5Instruction,
                 @(0xC6) : execute0xC6Instruction, @(0xC7) : execute0xC7Instruction,
                 @(0xC8) : execute0xC8Instruction,
                 @(0xC9) : execute0xC9Instruction, @(0xCA) : execute0xCAInstruction,
                 @(0xCB) : execute0xCBInstruction,
                 @(0xCC) : execute0xCCInstruction, @(0xCD) : execute0xCDInstruction,
                 @(0xCE) : execute0xCEInstruction, @(0xCF) : execute0xCFInstruction,

                 // 0xDX Instructions
                 @(0xD0) : execute0xD0Instruction, @(0xD1) : execute0xD1Instruction,
                 @(0xD2) : execute0xD2Instruction,
                 @(0xD3) : execute0xD3Instruction, @(0xD4) : execute0xD4Instruction,
                 @(0xD5) : execute0xD5Instruction,
                 @(0xD6) : execute0xD6Instruction, @(0xD7) : execute0xD7Instruction,
                 @(0xD8) : execute0xD8Instruction,
                 @(0xD9) : execute0xD9Instruction, @(0xDA) : execute0xDAInstruction,
                 @(0xDB) : execute0xDBInstruction,
                 @(0xDC) : execute0xDCInstruction, @(0xDD) : execute0xDDInstruction,
                 @(0xDE) : execute0xDEInstruction, @(0xDF) : execute0xDFInstruction,

                 // 0xEX Instructions
                 @(0xE0) : execute0xE0Instruction, @(0xE1) : execute0xE1Instruction,
                 @(0xE2) : execute0xE2Instruction,
                 @(0xE3) : execute0xE3Instruction, @(0xE4) : execute0xE4Instruction,
                 @(0xE5) : execute0xE5Instruction,
                 @(0xE6) : execute0xE6Instruction, @(0xE7) : execute0xE7Instruction,
                 @(0xE8) : execute0xE8Instruction,
                 @(0xE9) : execute0xE9Instruction, @(0xEA) : execute0xEAInstruction,
                 @(0xEB) : execute0xEBInstruction,
                 @(0xEC) : execute0xECInstruction, @(0xED) : execute0xEDInstruction,
                 @(0xEE) : execute0xEEInstruction, @(0xEF) : execute0xEFInstruction,

                 // 0xFX Instructions
                 @(0xF0) : execute0xF0Instruction, @(0xF1) : execute0xF1Instruction,
                 @(0xF2) : execute0xF2Instruction,
                 @(0xF3) : execute0xF3Instruction, @(0xF4) : execute0xF4Instruction,
                 @(0xF5) : execute0xF5Instruction,
                 @(0xF6) : execute0xF6Instruction, @(0xF7) : execute0xF7Instruction,
                 @(0xF8) : execute0xF8Instruction,
                 @(0xF9) : execute0xF9Instruction, @(0xFA) : execute0xFAInstruction,
                 @(0xFB) : execute0xFBInstruction,
                 @(0xFC) : execute0xFCInstruction, @(0xFD) : execute0xFDInstruction,
                 @(0xFE) : execute0xFEInstruction, @(0xFF) : execute0xFFInstruction
                 };
    });
    return inst;
}

@end
