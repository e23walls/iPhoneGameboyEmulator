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

void (^execute0xcbC0Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,B -- Set bit 0 of B
    [state setB:setBit(currentInstruction, [state getB], @"B", 0)];
};

void (^execute0xcbC1Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,C -- Set bit 0 of C
    [state setC:setBit(currentInstruction, [state getC], @"C", 0)];
};
void (^execute0xcbC2Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,D -- Set bit 0 of D
    [state setD:setBit(currentInstruction, [state getD], @"D", 0)];
};
void (^execute0xcbC3Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,E -- Set bit 0 of E
    [state setE:setBit(currentInstruction, [state getE], @"E", 0)];
};
void (^execute0xcbC4Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,H -- Set bit 0 of H
    [state setH:setBit(currentInstruction, [state getH], @"H", 0)];
};
void (^execute0xcbC5Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,L -- Set bit 0 of L
    [state setL:setBit(currentInstruction, [state getL], @"L", 0)];
};
void (^execute0xcbC6Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,(HL) -- Set bit 0 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(currentInstruction,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 0);
};
void (^execute0xcbC7Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 0,A -- Set bit 0 of A
    [state setA:setBit(currentInstruction, [state getA], @"A", 0)];
};
void (^execute0xcbC8Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,B -- Set bit 1 of B
    [state setB:setBit(currentInstruction, [state getB], @"B", 1)];
};
void (^execute0xcbC9Instruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,C -- Set bit 1 of C
    [state setC:setBit(currentInstruction, [state getC], @"C", 1)];
};
void (^execute0xcbCAInstruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,D -- Set bit 1 of D
    [state setD:setBit(currentInstruction, [state getD], @"D", 1)];
};
void (^execute0xcbCBInstruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,E -- Set bit 1 of E
    [state setE:setBit(currentInstruction, [state getE], @"E", 1)];
};
void (^execute0xcbCCInstruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,H -- Set bit 1 of H
    [state setH:setBit(currentInstruction, [state getH], @"H", 1)];
};
void (^execute0xcbCDInstruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,L -- Set bit 1 of L
    [state setL:setBit(currentInstruction, [state getL], @"L", 1)];
};
void (^execute0xcbCEInstruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,(HL) -- Set bit 1 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(currentInstruction,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 1);
};
void (^execute0xcbCFInstruction)(romState *,
                                int8_t,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  int8_t currentInstruction,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 1,A -- Set bit 1 of A
    [state setA:setBit(currentInstruction, [state getA], @"A", 1)];
};