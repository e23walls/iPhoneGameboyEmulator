#import <Kiwi.h>
#import "emulatorMain.h"
#import "rom.h"

#define TESTRAMSIZE 5

extern void (^execute0x0Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x1Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x2Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x3Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x4Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x5Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x6Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x7Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x8Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0x9Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xAInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xBInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xCInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xDInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xEInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xFInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbInstruction)(romState *, char *, bool *, int8_t *, int8_t);
extern void (^execute0xcb0Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb1Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb2Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb3Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb4Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb5Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb6Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb7Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb8Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcb9Instruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbAInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbBInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbCInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbDInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbEInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^execute0xcbFInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^servicedInterrupt)(char *, int8_t);
extern void (^pushPCForISR)(romState *, char *, unsigned short);
extern void (^enableInterrupts)(bool, char *);
extern void (^setKeysInMemory)(char *, int);
extern void (^executeInstruction)(romState *, char *, bool *, int8_t *);
extern void (^execute0xcbInstruction)(romState *, char *, bool *, int8_t *, int8_t);
extern void (^interruptServiceRoutineCaller)(romState *, char *, bool *, int8_t *);

@interface romState (Testing)

@property unsigned short PC;
@property unsigned short SP;
@property int8_t A;
@property int8_t F; // [Z][N][H][C][0][0][0][0]
@property int16_t BC;
@property int16_t DE;
@property int16_t HL;

@end

@interface emulatorMain (Testing)

@property char * ram;
@property rom * currentRom;
@property romState * currentState;

@end

void (^setupRamForTest)(char *, int, int) = ^
(char * ram,
 int length,
 int var)
{
    for (int i = 0; i < length; i++)
    {
        ram[i] = (length - i) * (i - var) * (i - var);
    }
};

SPEC_BEGIN(InstructionsTests)

describe(@"Instructions LD (nn),A", ^{
    __block emulatorMain * subject = nil;
    __block char * testRam = nil;
    __block romState * testState = nil;
    __block int8_t testA = 0;
    __block int16_t testBC = 0;
    __block int16_t testDE = 0;
    __block short instruction = 0;
    beforeEach(^{
        testState = [romState mock];
        [testState stub:@selector(getPC)
              andReturn:theValue(0)];
        testRam = malloc(sizeof(char) * TESTRAMSIZE);
        subject = [[emulatorMain alloc] init];
        [subject stub:@selector(currentState)
            andReturn:testState];
    });
    context(@"when current instruction is 0x02 -- LD (BC),A", ^{
        beforeEach(^{
            testA = 50;
            testBC = 1;
            setupRamForTest(testRam, TESTRAMSIZE, 8);
            testRam[testBC] = 5;
            [testState stub:@selector(getA)
                  andReturn:theValue(testA)];
            [testState stub:@selector(getBC_big)];
            [subject stub:@selector(ram)
                  andReturn:theValue(testRam)];
            [subject stub:@selector(currentState)
                andReturn:testState];
            instruction = 0x02;
        });
        it([NSString stringWithFormat:@"should load A (%i) into (BC)", testA], ^{
            execute0x0Instruction(testState, instruction, testRam, nil, nil);
            [[theValue(subject.ram[(unsigned short)[testState getBC_big]]) should] equal:theValue(testA)];
        });
    });
    context(@"when current instruction is 0x12 -- LD (DE),A", ^{
        beforeEach(^{
            testA = 50;
            testDE = 1;
            setupRamForTest(testRam, TESTRAMSIZE, 4);
            testRam[testDE] = 5;
            [testState stub:@selector(getA)
                  andReturn:theValue(testA)];
            [testState stub:@selector(getDE_big)];
            [subject stub:@selector(ram)
                andReturn:theValue(testRam)];
            [subject stub:@selector(currentState)
                andReturn:testState];
            instruction = 0x12;
        });
        it([NSString stringWithFormat:@"should load A (%i) into (DE)", testA], ^{
            execute0x1Instruction(testState, instruction, testRam, nil, nil);
            [[theValue(subject.ram[(unsigned short)[testState getDE_big]]) should] equal:theValue(testA)];
        });
    });
});
describe(@"Instructions LD (HL+/-),A", ^{
    __block emulatorMain * subject = nil;
    __block char * testRam = nil;
    __block romState * testState = nil;
    __block int8_t testA = 0;
    __block int16_t oldHL = 0;
    __block int16_t testHL = 0;
    __block short instruction = 0;
    beforeEach(^{
        testState = [romState mock];
        [testState stub:@selector(getPC)
              andReturn:theValue(0)];
        testRam = malloc(sizeof(char) * TESTRAMSIZE);
        subject = [[emulatorMain alloc] init];
        [subject stub:@selector(currentState)
            andReturn:testState];
    });
    context(@"when current instruction is 0x22 -- LD (HL+),A", ^{
        beforeEach(^{
            setupRamForTest(testRam, TESTRAMSIZE, -9);
            testHL = 4;
            oldHL = testHL;
            testRam[testHL] = 5;
            [testState stub:@selector(getA)
                  andReturn:theValue(testA)];
            [testState stub:@selector(setHL_big:)];
            [testState stub:@selector(getHL_big)
                  andReturn:theValue(testHL)];
            [subject stub:@selector(ram)
                andReturn:theValue(testRam)];
            [subject stub:@selector(currentState)
                andReturn:testState];
            instruction = 0x22;
        });
        it(@"should copy A into (HL) -- old value of HL", ^{
            execute0x2Instruction(testState, instruction, testRam, nil, nil);
            [[theValue(testRam[(unsigned short)oldHL]) should] equal:theValue(testA)];
        });
        it(@"should increment HL after copy", ^{
            [[testState should] receive:@selector(setHL_big:)
                          withArguments:theValue(oldHL + 1)];
            execute0x2Instruction(testState, instruction, testRam, nil, nil);
        });
    });
    context(@"when current instruction is 0x32 -- LD (HL-),A", ^{
        beforeEach(^{
            setupRamForTest(testRam, TESTRAMSIZE, -9);
            testHL = 4;
            oldHL = testHL;
            testRam[testHL] = 5;
            [testState stub:@selector(getA)
                  andReturn:theValue(testA)];
            [testState stub:@selector(getHL_big)
                  andReturn:theValue(testHL)];
            [testState stub:@selector(setHL_big:)];
            [subject stub:@selector(ram)
                andReturn:theValue(testRam)];
            [subject stub:@selector(currentState)
                andReturn:testState];
            instruction = 0x32;
        });
        it(@"should copy A into (HL) -- old value of HL", ^{
            execute0x2Instruction(testState, instruction, testRam, nil, nil);
            [[theValue(testRam[(unsigned short)oldHL]) should] equal:theValue(testA)];
        });
        it(@"should decrement HL after copy", ^{
            [[testState should] receive:@selector(setHL_big:)
                          withArguments:theValue(oldHL - 1)];
            execute0x3Instruction(testState, instruction, testRam, nil, nil);
        });
    });
});

SPEC_END