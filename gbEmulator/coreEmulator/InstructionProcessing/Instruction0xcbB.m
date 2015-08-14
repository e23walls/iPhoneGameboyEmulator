#import "emulatorMain.h"

extern int8_t (^resetBit)(int8_t,
                          int8_t,
                          NSString *,
                          unsigned int);

void (^execute0xcbB0Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 6,B -- Reset bit 6 of B
    [state setB:resetBit(0xB0, [state getB], @"B", 6)];
};

void (^execute0xcbB1Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 6,C -- Reset bit 6 of C
    [state setC:resetBit(0xB1, [state getC], @"C", 6)];
};
void (^execute0xcbB2Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{

    // RES 6,D -- Reset bit 6 of D
    [state setD:resetBit(0xB2, [state getD], @"D", 6)];
};
void (^execute0xcbB3Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 6,E -- Reset bit 6 of E
    [state setE:resetBit(0xB3, [state getE], @"E", 6)];
};
void (^execute0xcbB4Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 6,H -- Reset bit 6 of H
    [state setH:resetBit(0xB4, [state getH], @"H", 6)];
};
void (^execute0xcbB5Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 6,L -- Reset bit 6 of L
    [state setL:resetBit(0xB5, [state getL], @"L", 6)];
};
void (^execute0xcbB6Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 6,(HL) -- Reset bit 6 of (HL)
    ram[(unsigned short)[state getHL_big]] = resetBit(0xB6, ram[(unsigned short)[state getHL_big]], @"(HL)", 6);
};
void (^execute0xcbB7Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 6,A -- Reset bit 6 of A
    [state setA:resetBit(0xB7, [state getA], @"A", 6)];
};
void (^execute0xcbB8Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 7,B -- Reset bit 7 of B
    [state setB:resetBit(0xB8, [state getB], @"B", 7)];
};
void (^execute0xcbB9Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 7,C -- Reset bit 7 of C
    [state setC:resetBit(0xB9, [state getC], @"C", 7)];
};
void (^execute0xcbBAInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 7,D -- Reset bit 7 of D
    [state setD:resetBit(0xBA, [state getD], @"D", 7)];
};
void (^execute0xcbBBInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 7,E -- Reset bit 7 of E
    [state setE:resetBit(0xBB, [state getE], @"E", 7)];
};
void (^execute0xcbBCInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 7,H -- Reset bit 7 of H
    [state setH:resetBit(0xBC, [state getH], @"H", 7)];
};
void (^execute0xcbBDInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 7,L -- Reset bit 7 of L
    [state setL:resetBit(0xBD, [state getL], @"L", 7)];
};
void (^execute0xcbBEInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 7,(HL) -- Reset bit 7 of (HL)
    ram[(unsigned short)[state getHL_big]] = resetBit(0xBE, ram[(unsigned short)[state getHL_big]], @"(HL)", 7);
};
void (^execute0xcbBFInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // RES 7,A -- Reset bit 7 of A
    [state setA:resetBit(0xBF, [state getA], @"A", 7)];
};