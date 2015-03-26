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
extern int16_t (^get16BitWordFromRAM)(short, char *);

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

describe(@"Instructions", ^{
    __block emulatorMain * subject = nil;
    __block char * testRam = nil;
    __block romState * testState = nil;
    __block int8_t testA = 0;
    __block int16_t testBC = 0;
    __block int16_t testDE = 0;
    __block short instruction = 0;
    __block int16_t oldHL = 0;
    __block int16_t testHL = 0;
    __block short test16BitData = 0;
    beforeEach(^{
        subject = nil;
        testRam = nil;
        testState = nil;
        testA = 0;
        testBC = 0;
        testDE = 0;
        oldHL = 0;
        testHL = 0;
        instruction = 0;
        test16BitData = 0;
    });
    describe(@"Instructions LD (nn),A", ^{
        __block emulatorMain * subject = nil;
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
    describe(@"jump instructions -- JP <cond,> a16", ^{
        beforeEach(^{
            testState = [romState mock];
            [testState stub:@selector(getPC)
                  andReturn:theValue(1)];
            [testState stub:@selector(setPC:)];
            testRam = malloc(sizeof(char) * TESTRAMSIZE);
            setupRamForTest(testRam, TESTRAMSIZE, 3);
            // 16-bit address = 0x4645; do not change unless also
            // changing the test which checks this value!
            testRam[1] = 0x45;
            testRam[2] = 0x46;
            subject = [[emulatorMain alloc] init];
            [subject stub:@selector(currentState)
                andReturn:testState];
            [subject stub:@selector(ram)
                andReturn:theValue(testRam)];
        });
        context(@"when current instruction is JP NZ,a16 -- 0xC2", ^{
            beforeEach(^{
                instruction = 0xc2;
            });
            context(@"when Z == true", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)true)];
                });
                it(@"should not jump", ^{
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    [[testState shouldNot] receive:@selector(setPC:)];
                    execute0xCInstruction(testState, instruction, testRam, incPC, nil);
                });
            });
            context(@"when Z == false", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should have ram[1] equal 0x45", ^{
                    [[theValue(testRam[1]) should] equal:theValue((int8_t)0x45)];
                    [[theValue(testRam[2]) should] equal:theValue((int8_t)0x46)];
                });
                it(@"should get 0x4645 as 16-bit address", ^{
                    test16BitData = get16BitWordFromRAM([testState getPC], testRam);
                    [[theValue(test16BitData) should] equal:theValue((short)0x4645)];
                });
                it(@"should jump to 0x4645", ^{
                    test16BitData = get16BitWordFromRAM([testState getPC], testRam);
                    [[testState should] receive:@selector(setPC:)
                                  withArguments:theValue(test16BitData)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    execute0xCInstruction(testState, instruction, testRam, incPC, nil);
                    
                });
            });
        });
    });
});

SPEC_END