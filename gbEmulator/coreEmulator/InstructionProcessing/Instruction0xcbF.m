#import "emulatorMain.h"

extern int8_t (^setBit)(int8_t,
                        int8_t,
                        NSString *,
                        unsigned int);

void (^execute0xcbF0Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 6,B -- Set bit 6 of B
    [state setB:setBit(0xF0, [state getB], @"B", 6)];
};
void (^execute0xcbF1Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 6,C -- Set bit 6 of C
    [state setC:setBit(0xF1, [state getC], @"C", 6)];
};
void (^execute0xcbF2Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 6,D -- Set bit 6 of D
    [state setD:setBit(0xF2, [state getD], @"D", 6)];
};
void (^execute0xcbF3Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 6,E -- Set bit 6 of E
    [state setE:setBit(0xF3, [state getE], @"E", 6)];
};
void (^execute0xcbF4Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 6,H -- Set bit 6 of H
    [state setH:setBit(0xF4, [state getH], @"H", 6)];
};
void (^execute0xcbF5Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 6,L -- Set bit 6 of L
    [state setL:setBit(0xF5, [state getL], @"L", 6)];
};
void (^execute0xcbF6Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 6,(HL) -- Set bit 6 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(0xF6,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 6);
};
void (^execute0xcbF7Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 6,A -- Set bit 6 of A
    [state setA:setBit(0xF7, [state getA], @"A", 6)];
};
void (^execute0xcbF8Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 7,B -- Set bit 7 of B
    [state setB:setBit(0xF8, [state getB], @"B", 7)];
};
void (^execute0xcbF9Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 7,C -- Set bit 7 of C
    [state setC:setBit(0xF9, [state getC], @"C", 7)];
};
void (^execute0xcbFAInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 7,D -- Set bit 7 of D
    [state setD:setBit(0xFA, [state getD], @"D", 7)];
};
void (^execute0xcbFBInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 7,E -- Set bit 7 of E
    [state setE:setBit(0xFB, [state getE], @"E", 7)];
};
void (^execute0xcbFCInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 7,H -- Set bit 7 of H
    [state setH:setBit(0xFC, [state getH], @"H", 7)];
};
void (^execute0xcbFDInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 7,L -- Set bit 7 of L
    [state setL:setBit(0xFD, [state getL], @"L", 7)];
};
void (^execute0xcbFEInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 7,(HL) -- Set bit 7 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(0xFE,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 7);
};
void (^execute0xcbFFInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // SET 7,A -- Set bit 7 of A
    [state setA:setBit(0xFF, [state getA], @"A", 7)];
};