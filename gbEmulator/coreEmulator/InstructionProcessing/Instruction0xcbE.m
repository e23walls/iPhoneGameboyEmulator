#import "emulatorMain.h"

extern int8_t (^setBit)(int8_t,
                        int8_t,
                        NSString *,
                        unsigned int);

void (^execute0xcbE0Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 4,B -- Set bit 4 of B
    [state setB:setBit(0xE0, [state getB], @"B", 4)];
};
void (^execute0xcbE1Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 4,C -- Set bit 4 of C
    [state setC:setBit(0xE1, [state getC], @"C", 4)];
};
void (^execute0xcbE2Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 4,D -- Set bit 4 of D
    [state setD:setBit(0xE2, [state getD], @"D", 4)];
};
void (^execute0xcbE3Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 4,E -- Set bit 4 of E
    [state setE:setBit(0xE3, [state getE], @"E", 4)];
};
void (^execute0xcbE4Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 4,H -- Set bit 4 of H
    [state setH:setBit(0xE4, [state getH], @"H", 4)];
};
void (^execute0xcbE5Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 4,L -- Set bit 4 of L
    [state setL:setBit(0xE5, [state getL], @"L", 4)];
};
void (^execute0xcbE6Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 4,(HL) -- Set bit 4 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(0xE6,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 4);
};
void (^execute0xcbE7Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 4,A -- Set bit 4 of A
    [state setA:setBit(0xE7, [state getA], @"A", 4)];
};
void (^execute0xcbE8Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 5,B -- Set bit 5 of B
    [state setB:setBit(0xE8, [state getB], @"B", 5)];
};
void (^execute0xcbE9Instruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 5,C -- Set bit 5 of C
    [state setC:setBit(0xE9, [state getC], @"C", 5)];
};
void (^execute0xcbEAInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 5,D -- Set bit 5 of D
    [state setD:setBit(0xEA, [state getD], @"D", 5)];
};
void (^execute0xcbEBInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 5,E -- Set bit 5 of E
    [state setE:setBit(0xEB, [state getE], @"E", 5)];
};
void (^execute0xcbECInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 5,H -- Set bit 5 of H
    [state setH:setBit(0xEC, [state getH], @"H", 5)];
};
void (^execute0xcbEDInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 5,L -- Set bit 5 of L
    [state setL:setBit(0xED, [state getL], @"L", 5)];
};
void (^execute0xcbEEInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 5,(HL) -- Set bit 5 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(0xEE,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 5);
};
void (^execute0xcbEFInstruction)(RomState *,
                                char *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 5,A -- Set bit 5 of A
    [state setA:setBit(0xEF, [state getA], @"A", 5)];
};