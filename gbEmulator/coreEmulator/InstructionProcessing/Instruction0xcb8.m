#import "emulatorMain.h"

int8_t (^resetBit)(int8_t,
                   int8_t,
                   NSString *,
                   unsigned int) =
^(int8_t currentInstruction,
  int8_t reg,
  NSString * regName,
  unsigned int bitToReset)
{
    assert(bitToReset >= 0 && bitToReset <= 7);
    const char * cStringName = [regName cStringUsingEncoding:NSUTF8StringEncoding];
    int8_t prev = reg;
    reg &= ((1 << bitToReset) ^ 0xff);
    PRINTDBG("0xCB%02x -- RES %u,%s -- %s was 0x%02x; %s is now 0x%02x\n", currentInstruction, bitToReset,
             cStringName, cStringName, prev & 0xff, cStringName, reg & 0xff);
    return reg;
};

void (^execute0xcb80Instruction)(romState *,
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
    // RES 0,B -- Reset bit 0 of B
    [state setB:resetBit(currentInstruction, [state getB], @"B", 0)];
};
void (^execute0xcb81Instruction)(romState *,
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
    // RES 0,C -- Reset bit 0 of C
    [state setC:resetBit(currentInstruction, [state getC], @"C", 0)];
};
void (^execute0xcb82Instruction)(romState *,
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
    // RES 0,D -- Reset bit 0 of D
    [state setD:resetBit(currentInstruction, [state getD], @"D", 0)];
};
void (^execute0xcb83Instruction)(romState *,
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
    // RES 0,E -- Reset bit 0 of E
    [state setE:resetBit(currentInstruction, [state getE], @"E", 0)];
};
void (^execute0xcb84Instruction)(romState *,
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
    // RES 0,H -- Reset bit 0 of H
    [state setH:resetBit(currentInstruction, [state getH], @"H", 0)];
};
void (^execute0xcb85Instruction)(romState *,
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
    // RES 0,L -- Reset bit 0 of L
    [state setL:resetBit(currentInstruction, [state getL], @"L", 0)];
};
void (^execute0xcb86Instruction)(romState *,
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
    // RES 0,(HL) -- Reset bit 0 of (HL)
    ram[(unsigned short)[state getHL_big]] = resetBit(currentInstruction, ram[(unsigned short)[state getHL_big]], @"(HL)", 0);
};
void (^execute0xcb87Instruction)(romState *,
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
    // RES 0,A -- Reset bit 0 of A
    [state setA:resetBit(currentInstruction, [state getA], @"A", 0)];
};
void (^execute0xcb88Instruction)(romState *,
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
    // RES 1,B -- Reset bit 1 of B
    [state setB:resetBit(currentInstruction, [state getB], @"B", 1)];
};
void (^execute0xcb89Instruction)(romState *,
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
    // RES 1,C -- Reset bit 1 of C
    [state setC:resetBit(currentInstruction, [state getC], @"C", 1)];
};
void (^execute0xcb8AInstruction)(romState *,
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
    // RES 1,D -- Reset bit 1 of D
    [state setD:resetBit(currentInstruction, [state getD], @"D", 1)];
};
void (^execute0xcb8BInstruction)(romState *,
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
    // RES 1,E -- Reset bit 1 of E
    [state setE:resetBit(currentInstruction, [state getE], @"E", 1)];
};
void (^execute0xcb8CInstruction)(romState *,
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
    // RES 1,H -- Reset bit 1 of H
    [state setH:resetBit(currentInstruction, [state getH], @"H", 1)];
};
void (^execute0xcb8DInstruction)(romState *,
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
    // RES 1,L -- Reset bit 1 of L
    [state setL:resetBit(currentInstruction, [state getL], @"L", 1)];
};
void (^execute0xcb8EInstruction)(romState *,
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
    // RES 1,(HL) -- Reset bit 1 of (HL)
    ram[(unsigned short)[state getHL_big]] = resetBit(currentInstruction, ram[(unsigned short)[state getHL_big]], @"(HL)", 1);
};
void (^execute0xcb8FInstruction)(romState *,
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
    // RES 1,A -- Reset bit 1 of A
    [state setA:resetBit(currentInstruction, [state getA], @"A", 1)];
};