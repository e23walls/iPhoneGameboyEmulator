#import "emulatorMain.h"

extern int8_t (^resetBit)(int8_t,
                          int8_t,
                          NSString *,
                          unsigned int);

void (^execute0xcbB0Instruction)(romState *,
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
    // RES 6,B -- Reset bit 6 of B
    [state setB:resetBit(currentInstruction, [state getB], @"B", 6)];
};

void (^execute0xcbB1Instruction)(romState *,
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
    // RES 6,C -- Reset bit 6 of C
    [state setC:resetBit(currentInstruction, [state getC], @"C", 6)];
};
void (^execute0xcbB2Instruction)(romState *,
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

    // RES 6,D -- Reset bit 6 of D
    [state setD:resetBit(currentInstruction, [state getD], @"D", 6)];
};
void (^execute0xcbB3Instruction)(romState *,
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
    // RES 6,E -- Reset bit 6 of E
    [state setE:resetBit(currentInstruction, [state getE], @"E", 6)];
};
void (^execute0xcbB4Instruction)(romState *,
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
    // RES 6,H -- Reset bit 6 of H
    [state setH:resetBit(currentInstruction, [state getH], @"H", 6)];
};
void (^execute0xcbB5Instruction)(romState *,
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
    // RES 6,L -- Reset bit 6 of L
    [state setL:resetBit(currentInstruction, [state getL], @"L", 6)];
};
void (^execute0xcbB6Instruction)(romState *,
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
    // RES 6,(HL) -- Reset bit 6 of (HL)
    ram[(unsigned short)[state getHL_big]] = resetBit(currentInstruction, ram[(unsigned short)[state getHL_big]], @"(HL)", 6);
};
void (^execute0xcbB7Instruction)(romState *,
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
    // RES 6,A -- Reset bit 6 of A
    [state setA:resetBit(currentInstruction, [state getA], @"A", 6)];
};
void (^execute0xcbB8Instruction)(romState *,
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
    // RES 7,B -- Reset bit 7 of B
    [state setB:resetBit(currentInstruction, [state getB], @"B", 7)];
};
void (^execute0xcbB9Instruction)(romState *,
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
    // RES 7,C -- Reset bit 7 of C
    [state setC:resetBit(currentInstruction, [state getC], @"C", 7)];
};
void (^execute0xcbBAInstruction)(romState *,
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
    // RES 7,D -- Reset bit 7 of D
    [state setD:resetBit(currentInstruction, [state getD], @"D", 7)];
};
void (^execute0xcbBBInstruction)(romState *,
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
    // RES 7,E -- Reset bit 7 of E
    [state setE:resetBit(currentInstruction, [state getE], @"E", 7)];
};
void (^execute0xcbBCInstruction)(romState *,
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
    // RES 7,H -- Reset bit 7 of H
    [state setH:resetBit(currentInstruction, [state getH], @"H", 7)];
};
void (^execute0xcbBDInstruction)(romState *,
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
    // RES 7,L -- Reset bit 7 of L
    [state setL:resetBit(currentInstruction, [state getL], @"L", 7)];
};
void (^execute0xcbBEInstruction)(romState *,
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
    // RES 7,(HL) -- Reset bit 7 of (HL)
    ram[(unsigned short)[state getHL_big]] = resetBit(currentInstruction, ram[(unsigned short)[state getHL_big]], @"(HL)", 7);
};
void (^execute0xcbBFInstruction)(romState *,
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
    // RES 7,A -- Reset bit 7 of A
    [state setA:resetBit(currentInstruction, [state getA], @"A", 7)];
};