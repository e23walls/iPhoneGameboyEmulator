#import "emulatorMain.h"

extern int8_t (^setBit)(int8_t,
                        int8_t,
                        NSString *,
                        unsigned int);

void (^execute0xcbD0Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 2,B -- Set bit 2 of B
    [state setB:setBit(0xD0, [state getB], @"B", 2)];
};
void (^execute0xcbD1Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 2,C -- Set bit 2 of C
    [state setC:setBit(0xD1, [state getC], @"C", 2)];
};
void (^execute0xcbD2Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 2,D -- Set bit 2 of D
    [state setD:setBit(0xD2, [state getD], @"D", 2)];
};
void (^execute0xcbD3Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 2,E -- Set bit 2 of E
    [state setE:setBit(0xD3, [state getE], @"E", 2)];
};
void (^execute0xcbD4Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 2,H -- Set bit 2 of H
    [state setH:setBit(0xD4, [state getH], @"H", 2)];
};
void (^execute0xcbD5Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 2,L -- Set bit 2 of L
    [state setL:setBit(0xD5, [state getL], @"L", 2)];
};
void (^execute0xcbD6Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 2,(HL) -- Set bit 2 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(0xD6,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 2);
};
void (^execute0xcbD7Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 2,A -- Set bit 2 of A
    [state setA:setBit(0xD7, [state getA], @"A", 2)];
};
void (^execute0xcbD8Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 3,B -- Set bit 3 of B
    [state setB:setBit(0xD8, [state getB], @"B", 3)];
};
void (^execute0xcbD9Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 3,C -- Set bit 3 of C
    [state setC:setBit(0xD9, [state getC], @"C", 3)];
};
void (^execute0xcbDAInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 3,D -- Set bit 3 of D
    [state setD:setBit(0xDA, [state getD], @"D", 3)];
};
void (^execute0xcbDBInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 3,E -- Set bit 3 of E
    [state setE:setBit(0xDB, [state getE], @"E", 3)];
};
void (^execute0xcbDCInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 3,H -- Set bit 3 of H
    [state setH:setBit(0xDC, [state getH], @"H", 3)];
};
void (^execute0xcbDDInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 3,L -- Set bit 3 of L
    [state setL:setBit(0xDD, [state getL], @"L", 3)];
};
void (^execute0xcbDEInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 3,(HL) -- Set bit 3 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(0xDE,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 3);
};
void (^execute0xcbDFInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 3,A -- Set bit 3 of A
    [state setA:setBit(0xDF, [state getA], @"A", 3)];
};