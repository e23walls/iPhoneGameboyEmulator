#import "emulatorMain.h"

extern int8_t (^resetBit)(int8_t,
                          int8_t,
                          NSString *,
                          unsigned int);

void (^execute0xcbA0Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 4,B -- Reset bit 4 of B
            [state setB:resetBit(0xA0, [state getB], @"B", 4)];
};
void (^execute0xcbA1Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 4,C -- Reset bit 4 of C
            [state setC:resetBit(0xA1, [state getC], @"C", 4)];
};
void (^execute0xcbA2Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 4,D -- Reset bit 4 of D
            [state setD:resetBit(0xA2, [state getD], @"D", 4)];
};
void (^execute0xcbA3Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 4,E -- Reset bit 4 of E
            [state setE:resetBit(0xA3, [state getE], @"E", 4)];
};
void (^execute0xcbA4Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 4,H -- Reset bit 4 of H
            [state setH:resetBit(0xA4, [state getH], @"B", 4)];
};
void (^execute0xcbA5Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 4,L -- Reset bit 4 of L
            [state setL:resetBit(0xA5, [state getL], @"L", 4)];
};
void (^execute0xcbA6Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 4,(HL) -- Reset bit 4 of (HL)
            ram[(unsigned short)[state getHL_big]] = resetBit(0xA6, ram[(unsigned short)[state getHL_big]], @"(HL)", 4);
};
void (^execute0xcbA7Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 4,A -- Reset bit 4 of A
            [state setA:resetBit(0xA7, [state getA], @"A", 4)];
};
void (^execute0xcbA8Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 5,B -- Reset bit 5 of B
            [state setB:resetBit(0xA8, [state getB], @"B", 5)];
};
void (^execute0xcbA9Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 5,C -- Reset bit 5 of C
            [state setC:resetBit(0xA9, [state getC], @"C", 5)];
};
void (^execute0xcbAAInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 5,D -- Reset bit 5 of D
            [state setD:resetBit(0xAA, [state getD], @"D", 5)];
};
void (^execute0xcbABInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 5,E -- Reset bit 5 of E
            [state setE:resetBit(0xAB, [state getE], @"E", 5)];
};
void (^execute0xcbACInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 5,H -- Reset bit 5 of H
            [state setH:resetBit(0xAC, [state getH], @"H", 5)];
};
void (^execute0xcbADInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 5,L -- Reset bit 5 of L
            [state setL:resetBit(0xAD, [state getL], @"L", 5)];
};
void (^execute0xcbAEInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 5,(HL) -- Reset bit 5 of (HL)
            ram[(unsigned short)[state getHL_big]] = resetBit(0xAE, ram[(unsigned short)[state getHL_big]], @"(HL)", 5);
};
void (^execute0xcbAFInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
            // RES 5,A -- Reset bit 5 of A
            [state setA:resetBit(0xAF, [state getA], @"A", 5)];
};