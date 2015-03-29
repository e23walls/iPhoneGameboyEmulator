#import <Kiwi.h>
#import "emulatorMain.h"
#import "rom.h"

#define TESTRAMSIZE 5

extern void (^executeGivenInstruction)(romState *, int8_t, char *, bool *, int8_t *);
extern void (^servicedInterrupt)(char *, int8_t);
extern void (^pushPCForISR)(romState *, char *, unsigned short);
extern void (^enableInterrupts)(bool, char *);
extern void (^setKeysInMemory)(char *, int);
extern void (^executeInstruction)(romState *, char *, bool *, int8_t *);
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
    __block int8_t test8BitData = 0;
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
        test8BitData = 0;
    });
    afterEach(^{
        free(testRam);
    });
    describe(@"Instructions LD (nn),A", ^{
        __block emulatorMain * subject = nil;
        beforeEach(^{
            testState = [romState mock];
            [testState stub:@selector(doubleIncPC)];
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
                executeGivenInstruction(testState, instruction, testRam, nil, nil);
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
                executeGivenInstruction(testState, instruction, testRam, nil, nil);
                [[theValue(subject.ram[(unsigned short)[testState getDE_big]]) should] equal:theValue(testA)];
            });
        });
    });
    describe(@"Instructions LD (HL+/-),A", ^{
        beforeEach(^{
            testState = [romState mock];
            [testState stub:@selector(doubleIncPC)];
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
                executeGivenInstruction(testState, instruction, testRam, nil, nil);
                [[theValue(testRam[(unsigned short)oldHL]) should] equal:theValue(testA)];
            });
            it(@"should increment HL after copy", ^{
                [[testState should] receive:@selector(setHL_big:)
                              withArguments:theValue(oldHL + 1)];
                executeGivenInstruction(testState, instruction, testRam, nil, nil);
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
                executeGivenInstruction(testState, instruction, testRam, nil, nil);
                [[theValue(testRam[(unsigned short)oldHL]) should] equal:theValue(testA)];
            });
            it(@"should decrement HL after copy", ^{
                [[testState should] receive:@selector(setHL_big:)
                              withArguments:theValue(oldHL - 1)];
                executeGivenInstruction(testState, instruction, testRam, nil, nil);
            });
        });
    });
    describe(@"jump instructions -- JP/JR <cond,> a16", ^{
        beforeEach(^{
            testState = [romState mock];
            [testState stub:@selector(doubleIncPC)];
            [testState stub:@selector(getPC)
                  andReturn:theValue(1)];
            [testState stub:@selector(setPC:)];
            [testState stub:@selector(getHL_big)];
            [testState stub:@selector(addToPC:)];
            [testState stub:@selector(incrementPC)];
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
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
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
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
        });
        context(@"when current instruction is JP NC,a16 -- 0xD2", ^{
            beforeEach(^{
                instruction = 0xd2;
            });
            context(@"when C == true", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)true)];
                });
                it(@"should not jump", ^{
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    [[testState shouldNot] receive:@selector(setPC:)];
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
            context(@"when C == false", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
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
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
        });
        context(@"when current instruction is JP Z,a16 -- 0xCA", ^{
            beforeEach(^{
                instruction = 0xca;
            });
            context(@"when Z == false", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should not jump", ^{
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    [[testState shouldNot] receive:@selector(setPC:)];
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
            context(@"when Z == true", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)true)];
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
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
        });
        context(@"when current instruction is JP C,a16 -- 0xDA", ^{
            beforeEach(^{
                instruction = 0xda;
            });
            context(@"when C == false", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should not jump", ^{
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    [[testState shouldNot] receive:@selector(setPC:)];
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
            context(@"when C == true", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)true)];
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
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
        });
        context(@"when current instruction is JP (HL) -- 0xE9", ^{
            beforeEach(^{
                testHL = 0x4645;
                [testState stub:@selector(getHL_big)
                      andReturn:theValue(testHL)];
                instruction = 0xe9;
            });
            it([NSString stringWithFormat:@"should jump to value stored in HL (%i)", (int)testHL], ^{
                [[testState should] receive:@selector(setPC:)
                              withArguments:theValue([testState getHL_big])];
                bool * incPC = malloc(sizeof(bool));
                *incPC = false;
                executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                free(incPC);
                incPC = NULL;
            });
        });
        context(@"when current instruction is JP a16 -- 0xc3", ^{
            beforeEach(^{
                instruction = 0xc3;
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
                executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                free(incPC);
                incPC = NULL;
            });
        });
        context(@"when current instruction is JR r8 -- 0x18", ^{
            beforeEach(^{
                instruction = 0x18;
                test8BitData = 30;
                setupRamForTest(testRam, TESTRAMSIZE, 5);
                testRam[1] = test8BitData;
            });
            it([NSString stringWithFormat:@"should add 8-bit data (%i) to PC", test8BitData], ^{
                [[testState should] receive:@selector(addToPC:)
                              withArguments:theValue(test8BitData)];
                bool * incPC = malloc(sizeof(bool));
                *incPC = false;
                executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                free(incPC);
                incPC = NULL;
            });
        });
        context(@"when current instruction is JR Z,r8 -- 0x28", ^{
            beforeEach(^{
                instruction = 0x28;
                test8BitData = 30;
                testRam[1] = test8BitData;
            });
            context(@"when Z == false", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should not add 8-bit data to PC", ^{
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    [[testState shouldNot] receive:@selector(addToPC:)];
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
            context(@"when Z == true", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)true)];
                });
                it(@"should add 8-bit data to PC", ^{
                    [[testState should] receive:@selector(addToPC:)
                                  withArguments:theValue(test8BitData)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
        });
        context(@"when current instruction is JR C,r8 -- 0x38", ^{
            beforeEach(^{
                instruction = 0x38;
                test8BitData = 24;
                testRam[1] = test8BitData;
            });
            context(@"when C == false", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should not add 8-bit data to PC", ^{
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    [[testState shouldNot] receive:@selector(addToPC:)];
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
            context(@"when C == true", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)true)];
                });
                it(@"should add 8-bit data to PC", ^{
                    [[testState should] receive:@selector(addToPC:)
                                  withArguments:theValue(test8BitData)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
        });
        context(@"when current instruction is JR NZ,r8 -- 0x20", ^{
            beforeEach(^{
                instruction = 0x20;
                test8BitData = 50;
                testRam[1] = test8BitData;
            });
            context(@"when Z == true", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)true)];
                });
                it(@"should not add 8-bit data to PC", ^{
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    [[testState shouldNot] receive:@selector(addToPC:)];
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
            context(@"when Z == false", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should add 8-bit data to PC", ^{
                    [[testState should] receive:@selector(addToPC:)
                                  withArguments:theValue(test8BitData)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
        });
        context(@"when current instruction is JR NC,r8 -- 0x30", ^{
            beforeEach(^{
                instruction = 0x30;
                test8BitData = 24;
                testRam[1] = test8BitData;
            });
            context(@"when C == true", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)true)];
                });
                it(@"should not add 8-bit data to PC", ^{
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    [[testState shouldNot] receive:@selector(addToPC:)];
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
            context(@"when C == false", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should add 8-bit data to PC", ^{
                    [[testState should] receive:@selector(addToPC:)
                                  withArguments:theValue(test8BitData)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                    incPC = NULL;
                });
            });
        });
    });
    describe(@"Return from subroutine instructions -- RET[I] <cond>", ^{
        beforeEach(^{
            testState = [romState mock];
            [testState stub:@selector(doubleIncPC)];
            // After we've incremented PC
            [testState stub:@selector(getPC)
                  andReturn:theValue(1)];
            [testState stub:@selector(setPC:)];
            [testState stub:@selector(getHL_big)];
            [testState stub:@selector(addToPC:)];
            [testState stub:@selector(incrementPC)];
            testRam = malloc(sizeof(char) * TESTRAMSIZE);
            setupRamForTest(testRam, TESTRAMSIZE, 3);
            // 16-bit address = 0x4645; do not change unless also
            // changing the test which checks this value!
            testRam[3] = 0x45;
            testRam[4] = 0x46;
            [testState stub:@selector(getSP)
                  andReturn:theValue(3)];
            [testState stub:@selector(setSP:)];
            subject = [[emulatorMain alloc] init];
            [subject stub:@selector(currentState)
                andReturn:testState];
            [subject stub:@selector(ram)
                andReturn:theValue(testRam)];
        });
        context(@"when current instruction is RET -- 0xC9", ^{
            beforeEach(^{
                instruction = 0xc9;
            });
            it(@"should get 16-bit word equal to 0x4645", ^{
                [[theValue(get16BitWordFromRAM([testState getSP], [subject ram])) should] equal:theValue(0x4645)];
            });
            it(@"should set PC to value on stack", ^{
                [[testState should] receive:@selector(setPC:)
                              withArguments:theValue(0x4645)];
                bool * incPC = malloc(sizeof(bool));
                *incPC = false;
                executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                free(incPC);
            });
            it(@"should increment SP by 2", ^{
                [[testState should] receive:@selector(setSP:)
                              withArguments:theValue([testState getSP] + 2)];
                bool * incPC = malloc(sizeof(bool));
                *incPC = false;
                executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                free(incPC);
            });
        });
        context(@"when current instruction is RET NZ -- 0xC0", ^{
            beforeEach(^{
                instruction = 0xc0;
            });
            context(@"when Z is true", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)true)];
                });
                it(@"should not set PC to value on stack", ^{
                    [[testState shouldNot] receive:@selector(setPC:)
                                     withArguments:theValue([testState getSP] + 2)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
                it(@"should not change SP", ^{
                    [[testState shouldNot] receive:@selector(setSP:)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
            });
            context(@"when Z is false", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should get 16-bit word equal to 0x4645", ^{
                    [[theValue(get16BitWordFromRAM([testState getSP], [subject ram])) should] equal:theValue(0x4645)];
                });
                it(@"should set PC to value on stack", ^{
                    [[testState should] receive:@selector(setPC:)
                                  withArguments:theValue(0x4645)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
                it(@"should increment SP by 2", ^{
                    [[testState should] receive:@selector(setSP:)
                                  withArguments:theValue([testState getSP] + 2)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
            });
        });
        context(@"when current instruction is RET NC -- 0xD0", ^{
            beforeEach(^{
                instruction = 0xd0;
            });
            context(@"when C is true", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)true)];
                });
                it(@"should not set PC to value on stack", ^{
                    [[testState shouldNot] receive:@selector(setPC:)
                                     withArguments:theValue([testState getSP] + 2)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
                it(@"should not change SP", ^{
                    [[testState shouldNot] receive:@selector(setSP:)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
            });
            context(@"when C is false", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should get 16-bit word equal to 0x4645", ^{
                    [[theValue(get16BitWordFromRAM([testState getSP], [subject ram])) should] equal:theValue(0x4645)];
                });
                it(@"should set PC to value on stack", ^{
                    [[testState should] receive:@selector(setPC:)
                                  withArguments:theValue(0x4645)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
                it(@"should increment SP by 2", ^{
                    [[testState should] receive:@selector(setSP:)
                                  withArguments:theValue([testState getSP] + 2)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
            });
        });
        context(@"when current instruction is RET Z -- 0xC8", ^{
            beforeEach(^{
                instruction = 0xc8;
            });
            context(@"when Z is false", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should not set PC to value on stack", ^{
                    [[testState shouldNot] receive:@selector(setPC:)
                                     withArguments:theValue([testState getSP] + 2)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
                it(@"should not change SP", ^{
                    [[testState shouldNot] receive:@selector(setSP:)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
            });
            context(@"when Z is true", ^{
                beforeEach(^{
                    [testState stub:@selector(getZFlag)
                          andReturn:theValue((bool)true)];
                });
                it(@"should get 16-bit word equal to 0x4645", ^{
                    [[theValue(get16BitWordFromRAM([testState getSP], [subject ram])) should] equal:theValue(0x4645)];
                });
                it(@"should set PC to value on stack", ^{
                    [[testState should] receive:@selector(setPC:)
                                  withArguments:theValue(0x4645)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
                it(@"should increment SP by 2", ^{
                    [[testState should] receive:@selector(setSP:)
                                  withArguments:theValue([testState getSP] + 2)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
            });
        });
        context(@"when current instruction is RET C -- 0xD8", ^{
            beforeEach(^{
                instruction = 0xd8;
            });
            context(@"when C is false", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)false)];
                });
                it(@"should not set PC to value on stack", ^{
                    [[testState shouldNot] receive:@selector(setPC:)
                                     withArguments:theValue([testState getSP] + 2)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
                it(@"should not change SP", ^{
                    [[testState shouldNot] receive:@selector(setSP:)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
            });
            context(@"when C is true", ^{
                beforeEach(^{
                    [testState stub:@selector(getCFlag)
                          andReturn:theValue((bool)true)];
                });
                it(@"should get 16-bit word equal to 0x4645", ^{
                    [[theValue(get16BitWordFromRAM([testState getSP], [subject ram])) should] equal:theValue(0x4645)];
                });
                it(@"should set PC to value on stack", ^{
                    [[testState should] receive:@selector(setPC:)
                                  withArguments:theValue(0x4645)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
                it(@"should increment SP by 2", ^{
                    [[testState should] receive:@selector(setSP:)
                                  withArguments:theValue([testState getSP] + 2)];
                    bool * incPC = malloc(sizeof(bool));
                    *incPC = false;
                    executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                    free(incPC);
                });
            });
        });
        context(@"when current instruction is RETI -- 0xD9", ^{
            beforeEach(^{
                instruction = 0xd9;
                [subject stub:@selector(ram)
                withArguments:theValue(0x0ffff)];
            });
            it(@"should get 16-bit word equal to 0x4645", ^{
                [[theValue(get16BitWordFromRAM([testState getSP], [subject ram])) should] equal:theValue(0x4645)];
            });
            it(@"should set PC to value on stack", ^{
                [[testState should] receive:@selector(setPC:)
                              withArguments:theValue(0x4645)];
                bool * incPC = malloc(sizeof(bool));
                *incPC = false;
                executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                free(incPC);
            });
            it(@"should increment SP by 2", ^{
                [[testState should] receive:@selector(setSP:)
                              withArguments:theValue([testState getSP] + 2)];
                bool * incPC = malloc(sizeof(bool));
                *incPC = false;
                executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                free(incPC);
            });
            it(@"should enable interrupts", ^{
                free(testRam);
                testRam = malloc(sizeof(char) * (0x0ffff + 1));
                testRam[3] = 0x45;
                testRam[4] = 0x46;
                testRam[0x0ffff] = 0;
                bool * incPC = malloc(sizeof(bool));
                *incPC = false;
                executeGivenInstruction(testState, instruction, testRam, incPC, nil);
                free(incPC);
                [[theValue(testRam[0x0ffff]) should] equal:theValue(0b00011111)];
            });
        });
    });
});

SPEC_END