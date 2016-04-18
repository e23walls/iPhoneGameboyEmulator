#import "emulatorMain.h"

int8_t (^setBit)(int8_t,
                 int8_t,
                 NSString *,
                 unsigned int) =
^(int8_t currentInstruction,
  int8_t reg,
  NSString * regName,
  unsigned int bitToSet)
{
    assert(bitToSet >= 0 && bitToSet <= 7);
    const char * cStringName = [regName cStringUsingEncoding:NSUTF8StringEncoding];
    int8_t prev = reg;
    reg |= 1 << bitToSet;
    PRINTDBG("0xCB%02x -- SET %u,%s -- %s was 0x%02x; %s is now 0x%02x\n", currentInstruction, bitToSet,
             cStringName, cStringName, prev & 0xff, cStringName, reg & 0xff);
    return reg;
};

void (^execute0xcbC0Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,B -- Set bit 0 of B
    [state setB:setBit(0xC0, [state getB], @"B", 0)];
};

void (^execute0xcbC1Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,C -- Set bit 0 of C
    [state setC:setBit(0xC1, [state getC], @"C", 0)];
};
void (^execute0xcbC2Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,D -- Set bit 0 of D
    [state setD:setBit(0xC2, [state getD], @"D", 0)];
};
void (^execute0xcbC3Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,E -- Set bit 0 of E
    [state setE:setBit(0xC3, [state getE], @"E", 0)];
};
void (^execute0xcbC4Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,H -- Set bit 0 of H
    [state setH:setBit(0xC4, [state getH], @"H", 0)];
};
void (^execute0xcbC5Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,L -- Set bit 0 of L
    [state setL:setBit(0xC5, [state getL], @"L", 0)];
};
void (^execute0xcbC6Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,(HL) -- Set bit 0 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(0xC6,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 0);
};
void (^execute0xcbC7Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,A -- Set bit 0 of A
    [state setA:setBit(0xC7, [state getA], @"A", 0)];
};
void (^execute0xcbC8Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,B -- Set bit 1 of B
    [state setB:setBit(0xC8, [state getB], @"B", 1)];
};
void (^execute0xcbC9Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,C -- Set bit 1 of C
    [state setC:setBit(0xC9, [state getC], @"C", 1)];
};
void (^execute0xcbCAInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,D -- Set bit 1 of D
    [state setD:setBit(0xCA, [state getD], @"D", 1)];
};
void (^execute0xcbCBInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,E -- Set bit 1 of E
    [state setE:setBit(0xCB, [state getE], @"E", 1)];
};
void (^execute0xcbCCInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,H -- Set bit 1 of H
    [state setH:setBit(0xCC, [state getH], @"H", 1)];
};
void (^execute0xcbCDInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,L -- Set bit 1 of L
    [state setL:setBit(0xCD, [state getL], @"L", 1)];
};
void (^execute0xcbCEInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,(HL) -- Set bit 1 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(0xCE,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 1);
};
void (^execute0xcbCFInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,A -- Set bit 1 of A
    [state setA:setBit(0xCF, [state getA], @"A", 1)];
};