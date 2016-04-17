#import "InstructionSet.h"

@implementation InstructionDictionary

+ (NSDictionary *) getConstDictionary {
    static NSDictionary *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
                 @(0xFE) : execute0xFEInstruction, @(0xFF) : execute0xFFInstruction,

                 // CB Instructions:
                 // 0x0X Instructions
                 @(0xcb00) : execute0xcb00Instruction,
                 @(0xcb01) : execute0xcb01Instruction,
                 @(0xcb02) : execute0xcb02Instruction,
                 @(0xcb03) : execute0xcb03Instruction,
                 @(0xcb04) : execute0xcb04Instruction,
                 @(0xcb05) : execute0xcb05Instruction,
                 @(0xcb06) : execute0xcb06Instruction,
                 @(0xcb07) : execute0xcb07Instruction,
                 @(0xcb08) : execute0xcb08Instruction,
                 @(0xcb09) : execute0xcb09Instruction,
                 @(0xcb0A) : execute0xcb0AInstruction,
                 @(0xcb0B) : execute0xcb0BInstruction,
                 @(0xcb0C) : execute0xcb0CInstruction,
                 @(0xcb0D) : execute0xcb0DInstruction,
                 @(0xcb0E) : execute0xcb0EInstruction,
                 @(0xcb0F) : execute0xcb0FInstruction,

                 // 0xcb1X Instructions
                 @(0xcb10) : execute0xcb10Instruction,
                 @(0xcb11) : execute0xcb11Instruction,
                 @(0xcb12) : execute0xcb12Instruction,
                 @(0xcb13) : execute0xcb13Instruction,
                 @(0xcb14) : execute0xcb14Instruction,
                 @(0xcb15) : execute0xcb15Instruction,
                 @(0xcb16) : execute0xcb16Instruction,
                 @(0xcb17) : execute0xcb17Instruction,
                 @(0xcb18) : execute0xcb18Instruction,
                 @(0xcb19) : execute0xcb19Instruction,
                 @(0xcb1A) : execute0xcb1AInstruction,
                 @(0xcb1B) : execute0xcb1BInstruction,
                 @(0xcb1C) : execute0xcb1CInstruction,
                 @(0xcb1D) : execute0xcb1DInstruction,
                 @(0xcb1E) : execute0xcb1EInstruction,
                 @(0xcb1F) : execute0xcb1FInstruction,

                 // 0xcb2X Instructions
                 @(0xcb20) : execute0xcb20Instruction,
                 @(0xcb21) : execute0xcb21Instruction,
                 @(0xcb22) : execute0xcb22Instruction,
                 @(0xcb23) : execute0xcb23Instruction,
                 @(0xcb24) : execute0xcb24Instruction,
                 @(0xcb25) : execute0xcb25Instruction,
                 @(0xcb26) : execute0xcb26Instruction,
                 @(0xcb27) : execute0xcb27Instruction,
                 @(0xcb28) : execute0xcb28Instruction,
                 @(0xcb29) : execute0xcb29Instruction,
                 @(0xcb2A) : execute0xcb2AInstruction,
                 @(0xcb2B) : execute0xcb2BInstruction,
                 @(0xcb2C) : execute0xcb2CInstruction,
                 @(0xcb2D) : execute0xcb2DInstruction,
                 @(0xcb2E) : execute0xcb2EInstruction,
                 @(0xcb2F) : execute0xcb2FInstruction,

                 // 0xcb3X Instructions
                 @(0xcb30) : execute0xcb30Instruction, @(0xcb31) : execute0xcb31Instruction,
                 @(0xcb32) : execute0xcb32Instruction,
                 @(0xcb33) : execute0xcb33Instruction, @(0xcb34) : execute0xcb34Instruction,
                 @(0xcb35) : execute0xcb35Instruction,
                 @(0xcb36) : execute0xcb36Instruction, @(0xcb37) : execute0xcb37Instruction,
                 @(0xcb38) : execute0xcb38Instruction,
                 @(0xcb39) : execute0xcb39Instruction, @(0xcb3A) : execute0xcb3AInstruction,
                 @(0xcb3B) : execute0xcb3BInstruction,
                 @(0xcb3C) : execute0xcb3CInstruction, @(0xcb3D) : execute0xcb3DInstruction,
                 @(0xcb3E) : execute0xcb3EInstruction, @(0xcb3F) : execute0xcb3FInstruction,

                 // 0xcb4X Instructions
                 @(0xcb40) : execute0x40Instruction, @(0xcb41) : execute0xcb41Instruction,
                 @(0xcb42) : execute0x42Instruction,
                 @(0xcb43) : execute0x43Instruction, @(0xcb44) : execute0xcb44Instruction,
                 @(0xcb45) : execute0x45Instruction,
                 @(0xcb46) : execute0x46Instruction, @(0xcb47) : execute0xcb47Instruction,
                 @(0xcb48) : execute0x48Instruction,
                 @(0xcb49) : execute0x49Instruction, @(0xcb4A) : execute0xcb4AInstruction,
                 @(0xcb4B) : execute0x4BInstruction,
                 @(0xcb4C) : execute0x4CInstruction, @(0xcb4D) : execute0xcb4DInstruction,
                 @(0xcb4E) : execute0x4EInstruction, @(0xcb4F) : execute0xcb4FInstruction,

                 // 0xcb5X Instructions
                 @(0xcb50) : execute0xcb50Instruction, @(0xcb51) : execute0xcb51Instruction,
                 @(0xcb52) : execute0xcb52Instruction,
                 @(0xcb53) : execute0xcb53Instruction, @(0xcb54) : execute0xcb54Instruction,
                 @(0xcb55) : execute0xcb55Instruction,
                 @(0xcb56) : execute0xcb56Instruction, @(0xcb57) : execute0xcb57Instruction,
                 @(0xcb58) : execute0xcb58Instruction,
                 @(0xcb59) : execute0xcb59Instruction, @(0xcb5A) : execute0xcb5AInstruction,
                 @(0xcb5B) : execute0xcb5BInstruction,
                 @(0xcb5C) : execute0xcb5CInstruction, @(0xcb5D) : execute0xcb5DInstruction,
                 @(0xcb5E) : execute0xcb5EInstruction, @(0xcb5F) : execute0xcb5FInstruction,

                 // 0xcb6X Instructions
                 @(0xcb60) : execute0xcb60Instruction, @(0xcb61) : execute0xcb61Instruction,
                 @(0xcb62) : execute0xcb62Instruction,
                 @(0xcb63) : execute0xcb63Instruction, @(0xcb64) : execute0xcb64Instruction,
                 @(0xcb65) : execute0xcb65Instruction,
                 @(0xcb66) : execute0xcb66Instruction, @(0xcb67) : execute0xcb67Instruction,
                 @(0xcb68) : execute0xcb68Instruction,
                 @(0xcb69) : execute0xcb69Instruction, @(0xcb6A) : execute0xcb6AInstruction,
                 @(0xcb6B) : execute0xcb6BInstruction,
                 @(0xcb6C) : execute0xcb6CInstruction, @(0xcb6D) : execute0xcb6DInstruction,
                 @(0xcb6E) : execute0xcb6EInstruction, @(0xcb6F) : execute0xcb6FInstruction,

                 // 0xcb7X Instructions
                 @(0xcb70) : execute0xcb70Instruction, @(0xcb71) : execute0xcb71Instruction,
                 @(0xcb72) : execute0xcb72Instruction,
                 @(0xcb73) : execute0xcb73Instruction, @(0xcb74) : execute0xcb74Instruction,
                 @(0xcb75) : execute0xcb75Instruction,
                 @(0xcb76) : execute0xcb76Instruction, @(0xcb77) : execute0xcb77Instruction,
                 @(0xcb78) : execute0xcb78Instruction,
                 @(0xcb79) : execute0xcb79Instruction, @(0xcb7A) : execute0xcb7AInstruction,
                 @(0xcb7B) : execute0xcb7BInstruction,
                 @(0xcb7C) : execute0xcb7CInstruction, @(0xcb7D) : execute0xcb7DInstruction,
                 @(0xcb7E) : execute0xcb7EInstruction, @(0xcb7F) : execute0xcb7FInstruction,

                 // 0xcb8X Instructions
                 @(0xcb80) : execute0xcb80Instruction, @(0xcb81) : execute0xcb81Instruction,
                 @(0xcb82) : execute0xcb82Instruction,
                 @(0xcb83) : execute0xcb83Instruction, @(0xcb84) : execute0xcb84Instruction,
                 @(0xcb85) : execute0xcb85Instruction,
                 @(0xcb86) : execute0xcb86Instruction, @(0xcb87) : execute0xcb87Instruction,
                 @(0xcb88) : execute0xcb88Instruction,
                 @(0xcb89) : execute0xcb89Instruction, @(0xcb8A) : execute0xcb8AInstruction,
                 @(0xcb8B) : execute0xcb8BInstruction,
                 @(0xcb8C) : execute0xcb8CInstruction, @(0xcb8D) : execute0xcb8DInstruction,
                 @(0xcb8E) : execute0xcb8EInstruction, @(0xcb8F) : execute0xcb8FInstruction,

                 // 0xcb9X Instructions
                 @(0xcb90) : execute0xcb90Instruction, @(0xcb91) : execute0xcb91Instruction,
                 @(0xcb92) : execute0xcb92Instruction,
                 @(0xcb93) : execute0xcb93Instruction, @(0xcb94) : execute0xcb94Instruction,
                 @(0xcb95) : execute0xcb95Instruction,
                 @(0xcb96) : execute0xcb96Instruction, @(0xcb97) : execute0xcb97Instruction,
                 @(0xcb98) : execute0xcb98Instruction,
                 @(0xcb99) : execute0xcb99Instruction, @(0xcb9A) : execute0xcb9AInstruction,
                 @(0xcb9B) : execute0xcb9BInstruction,
                 @(0xcb9C) : execute0xcb9CInstruction, @(0xcb9D) : execute0xcb9DInstruction,
                 @(0xcb9E) : execute0xcb9EInstruction, @(0xcb9F) : execute0xcb9FInstruction,

                 // 0xcbAX Instructions
                 @(0xcbA0) : execute0xcbA0Instruction, @(0xcbA1) : execute0xcbA1Instruction,
                 @(0xcbA2) : execute0xcbA2Instruction,
                 @(0xcbA3) : execute0xcbA3Instruction, @(0xcbA4) : execute0xcbA4Instruction,
                 @(0xcbA5) : execute0xcbA5Instruction,
                 @(0xcbA6) : execute0xcbA6Instruction, @(0xcbA7) : execute0xcbA7Instruction,
                 @(0xcbA8) : execute0xcbA8Instruction,
                 @(0xcbA9) : execute0xcbA9Instruction, @(0xcbAA) : execute0xcbAAInstruction,
                 @(0xcbAB) : execute0xcbABInstruction,
                 @(0xcbAC) : execute0xcbACInstruction, @(0xcbAD) : execute0xcbADInstruction,
                 @(0xcbAE) : execute0xcbAEInstruction, @(0xcbAF) : execute0xcbAFInstruction,

                 // 0xcbBX Instructions
                 @(0xcbB0) : execute0xcbB0Instruction, @(0xcbB1) : execute0xcbB1Instruction,
                 @(0xcbB2) : execute0xcbB2Instruction,
                 @(0xcbB3) : execute0xcbB3Instruction, @(0xcbB4) : execute0xcbB4Instruction,
                 @(0xcbB5) : execute0xcbB5Instruction,
                 @(0xcbB6) : execute0xcbB6Instruction, @(0xcbB7) : execute0xcbB7Instruction,
                 @(0xcbB8) : execute0xcbB8Instruction,
                 @(0xcbB9) : execute0xcbB9Instruction, @(0xcbBA) : execute0xcbBAInstruction,
                 @(0xcbBB) : execute0xcbBBInstruction,
                 @(0xcbBC) : execute0xcbBCInstruction, @(0xcbBD) : execute0xcbBDInstruction,
                 @(0xcbBE) : execute0xcbBEInstruction, @(0xcbBF) : execute0xcbBFInstruction,

                 // 0xcbCX Instructions
                 @(0xcbC0) : execute0xcbC0Instruction, @(0xcbC1) : execute0xcbC1Instruction,
                 @(0xcbC2) : execute0xcbC2Instruction,
                 @(0xcbC3) : execute0xcbC3Instruction, @(0xcbC4) : execute0xcbC4Instruction,
                 @(0xcbC5) : execute0xcbC5Instruction,
                 @(0xcbC6) : execute0xcbC6Instruction, @(0xcbC7) : execute0xcbC7Instruction,
                 @(0xcbC8) : execute0xcbC8Instruction,
                 @(0xcbC9) : execute0xcbC9Instruction, @(0xcbCA) : execute0xcbCAInstruction,
                 @(0xcbCB) : execute0xcbCBInstruction,
                 @(0xcbCC) : execute0xcbCCInstruction, @(0xcbCD) : execute0xcbCDInstruction,
                 @(0xcbCE) : execute0xcbCEInstruction, @(0xcbCF) : execute0xcbCFInstruction,

                 // 0xcbDX Instructions
                 @(0xcbD0) : execute0xcbD0Instruction, @(0xcbD1) : execute0xcbD1Instruction,
                 @(0xcbD2) : execute0xcbD2Instruction,
                 @(0xcbD3) : execute0xcbD3Instruction, @(0xcbD4) : execute0xcbD4Instruction,
                 @(0xcbD5) : execute0xcbD5Instruction,
                 @(0xcbD6) : execute0xcbD6Instruction, @(0xcbD7) : execute0xcbD7Instruction,
                 @(0xcbD8) : execute0xcbD8Instruction,
                 @(0xcbD9) : execute0xcbD9Instruction, @(0xcbDA) : execute0xcbDAInstruction,
                 @(0xcbDB) : execute0xcbDBInstruction,
                 @(0xcbDC) : execute0xcbDCInstruction, @(0xcbDD) : execute0xcbDDInstruction,
                 @(0xcbDE) : execute0xcbDEInstruction, @(0xcbDF) : execute0xcbDFInstruction,

                 // 0xcbEX Instructions
                 @(0xcbE0) : execute0xcbE0Instruction, @(0xcbE1) : execute0xcbE1Instruction,
                 @(0xcbE2) : execute0xcbE2Instruction,
                 @(0xcbE3) : execute0xcbE3Instruction, @(0xcbE4) : execute0xcbE4Instruction,
                 @(0xcbE5) : execute0xcbE5Instruction,
                 @(0xcbE6) : execute0xcbE6Instruction, @(0xcbE7) : execute0xcbE7Instruction,
                 @(0xcbE8) : execute0xcbE8Instruction,
                 @(0xcbE9) : execute0xcbE9Instruction, @(0xcbEA) : execute0xcbEAInstruction,
                 @(0xcbEB) : execute0xcbEBInstruction,
                 @(0xcbEC) : execute0xcbECInstruction, @(0xcbED) : execute0xcbEDInstruction,
                 @(0xcbEE) : execute0xcbEEInstruction, @(0xcbEF) : execute0xcbEFInstruction,

                 // 0xcbFX Instructions
                 @(0xcbF0) : execute0xcbF0Instruction, @(0xcbF1) : execute0xcbF1Instruction,
                 @(0xcbF2) : execute0xcbF2Instruction,
                 @(0xcbF3) : execute0xcbF3Instruction, @(0xcbF4) : execute0xcbF4Instruction,
                 @(0xcbF5) : execute0xcbF5Instruction,
                 @(0xcbF6) : execute0xcbF6Instruction, @(0xcbF7) : execute0xcbF7Instruction,
                 @(0xcbF8) : execute0xcbF8Instruction,
                 @(0xcbF9) : execute0xcbF9Instruction, @(0xcbFA) : execute0xcbFAInstruction,
                 @(0xcbFB) : execute0xcbFBInstruction,
                 @(0xcbFC) : execute0xcbFCInstruction, @(0xcbFD) : execute0xcbFDInstruction,
                 @(0xcbFE) : execute0xcbFEInstruction, @(0xcbFF) : execute0xcbFFInstruction
                 };
    });
    return inst;
}

@end
