#import "emulatorMain.h"

extern int8_t (^resetBit)(int8_t,
                          int8_t,
                          NSString *,
                          unsigned int);

void (^execute0xcb90Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 2,B -- Reset bit 2 of B
    [state setB:resetBit(0x90, [state getB], @"B", 2)];
};
void (^execute0xcb91Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 2,C -- Reset bit 2 of C
    [state setC:resetBit(0x91, [state getC], @"C", 2)];
};
void (^execute0xcb92Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 2,D -- Reset bit 2 of D
    [state setD:resetBit(0x92, [state getD], @"D", 2)];
};
void (^execute0xcb93Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 2,E -- Reset bit 2 of E
    [state setE:resetBit(0x93, [state getE], @"E", 2)];
};
void (^execute0xcb94Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 2,H -- Reset bit 2 of H
    [state setH:resetBit(0x94, [state getH], @"H", 2)];
};
void (^execute0xcb95Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 2,L -- Reset bit 2 of L
    [state setL:resetBit(0x95, [state getL], @"L", 2)];
};
void (^execute0xcb96Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 2,(HL) -- Reset bit 2 of (HL)
    ram[(unsigned short)[state getHL_big]] = resetBit(0x96, ram[(unsigned short)[state getHL_big]], @"(HL)", 2);
};
void (^execute0xcb97Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 2,A -- Reset bit 2 of A
    [state setA:resetBit(0x97, [state getA], @"A", 2)];
};
void (^execute0xcb98Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 3,B -- Reset bit 3 of B
    [state setB:resetBit(0x98, [state getB], @"B", 3)];
};
void (^execute0xcb99Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 3,C -- Reset bit 3 of C
    [state setC:resetBit(0x99, [state getC], @"C", 3)];
};
void (^execute0xcb9AInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 3,D -- Reset bit 3 of D
    [state setD:resetBit(0x9A, [state getD], @"D", 3)];
};
void (^execute0xcb9BInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 3,E -- Reset bit 3 of E
    [state setE:resetBit(0x9B, [state getE], @"E", 3)];
};
void (^execute0xcb9CInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 3,H -- Reset bit 3 of H
    [state setH:resetBit(0x9C, [state getH], @"H", 3)];
};
void (^execute0xcb9DInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 3,L -- Reset bit 3 of L
    [state setL:resetBit(0x9D, [state getL], @"L", 3)];
};
void (^execute0xcb9EInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 3,(HL) -- Reset bit 3 of (HL)
    ram[(unsigned short)[state getHL_big]] = resetBit(0x9E, ram[(unsigned short)[state getHL_big]], @"(HL)", 3);
};
void (^execute0xcb9FInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 3,A -- Reset bit 3 of A
    [state setA:resetBit(0x9F, [state getA], @"A", 3)];
};