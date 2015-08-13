#import "emulatorMain.h"

extern int8_t (^setBit)(int8_t,
                        int8_t,
                        NSString *,
                        unsigned int);

void (^execute0xcbF0Instruction)(romState *,
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
    // SET 6,B -- Set bit 6 of B
    [state setB:setBit(currentInstruction, [state getB], @"B", 6)];
};
void (^execute0xcbF1Instruction)(romState *,
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
    // SET 6,C -- Set bit 6 of C
    [state setC:setBit(currentInstruction, [state getC], @"C", 6)];
};
void (^execute0xcbF2Instruction)(romState *,
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
    // SET 6,D -- Set bit 6 of D
    [state setD:setBit(currentInstruction, [state getD], @"D", 6)];
};
void (^execute0xcbF3Instruction)(romState *,
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
    // SET 6,E -- Set bit 6 of E
    [state setE:setBit(currentInstruction, [state getE], @"E", 6)];
};
void (^execute0xcbF4Instruction)(romState *,
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
    // SET 6,H -- Set bit 6 of H
    [state setH:setBit(currentInstruction, [state getH], @"H", 6)];
};
void (^execute0xcbF5Instruction)(romState *,
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
    // SET 6,L -- Set bit 6 of L
    [state setL:setBit(currentInstruction, [state getL], @"L", 6)];
};
void (^execute0xcbF6Instruction)(romState *,
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
    // SET 6,(HL) -- Set bit 6 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(currentInstruction,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 6);
};
void (^execute0xcbF7Instruction)(romState *,
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
    // SET 6,A -- Set bit 6 of A
    [state setA:setBit(currentInstruction, [state getA], @"A", 6)];
};
void (^execute0xcbF8Instruction)(romState *,
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
    // SET 7,B -- Set bit 7 of B
    [state setB:setBit(currentInstruction, [state getB], @"B", 7)];
};
void (^execute0xcbF9Instruction)(romState *,
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
    // SET 7,C -- Set bit 7 of C
    [state setC:setBit(currentInstruction, [state getC], @"C", 7)];
};
void (^execute0xcbFAInstruction)(romState *,
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
    // SET 7,D -- Set bit 7 of D
    [state setD:setBit(currentInstruction, [state getD], @"D", 7)];
};
void (^execute0xcbFBInstruction)(romState *,
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
    // SET 7,E -- Set bit 7 of E
    [state setE:setBit(currentInstruction, [state getE], @"E", 7)];
};
void (^execute0xcbFCInstruction)(romState *,
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
    // SET 7,H -- Set bit 7 of H
    [state setH:setBit(currentInstruction, [state getH], @"H", 7)];
};
void (^execute0xcbFDInstruction)(romState *,
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
    // SET 7,L -- Set bit 7 of L
    [state setL:setBit(currentInstruction, [state getL], @"L", 7)];
};
void (^execute0xcbFEInstruction)(romState *,
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
    // SET 7,(HL) -- Set bit 7 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(currentInstruction,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 7);
};
void (^execute0xcbFFInstruction)(romState *,
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
    // SET 7,A -- Set bit 7 of A
    [state setA:setBit(currentInstruction, [state getA], @"A", 7)];
};