#import "emulatorMain.h"

extern int8_t (^setBit)(int8_t,
                        int8_t,
                        NSString *,
                        unsigned int);

void (^execute0xcbE0Instruction)(romState *,
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
    // SET 4,B -- Set bit 4 of B
    [state setB:setBit(currentInstruction, [state getB], @"B", 4)];
};
void (^execute0xcbE1Instruction)(romState *,
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
    // SET 4,C -- Set bit 4 of C
    [state setC:setBit(currentInstruction, [state getC], @"C", 4)];
};
void (^execute0xcbE2Instruction)(romState *,
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
    // SET 4,D -- Set bit 4 of D
    [state setD:setBit(currentInstruction, [state getD], @"D", 4)];
};
void (^execute0xcbE3Instruction)(romState *,
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
    // SET 4,E -- Set bit 4 of E
    [state setE:setBit(currentInstruction, [state getE], @"E", 4)];
};
void (^execute0xcbE4Instruction)(romState *,
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
    // SET 4,H -- Set bit 4 of H
    [state setH:setBit(currentInstruction, [state getH], @"H", 4)];
};
void (^execute0xcbE5Instruction)(romState *,
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
    // SET 4,L -- Set bit 4 of L
    [state setL:setBit(currentInstruction, [state getL], @"L", 4)];
};
void (^execute0xcbE6Instruction)(romState *,
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
    // SET 4,(HL) -- Set bit 4 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(currentInstruction,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 4);
};
void (^execute0xcbE7Instruction)(romState *,
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
    // SET 4,A -- Set bit 4 of A
    [state setA:setBit(currentInstruction, [state getA], @"A", 4)];
};
void (^execute0xcbE8Instruction)(romState *,
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
    // SET 5,B -- Set bit 5 of B
    [state setB:setBit(currentInstruction, [state getB], @"B", 5)];
};
void (^execute0xcbE9Instruction)(romState *,
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
    // SET 5,C -- Set bit 5 of C
    [state setC:setBit(currentInstruction, [state getC], @"C", 5)];
};
void (^execute0xcbEAInstruction)(romState *,
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
    // SET 5,D -- Set bit 5 of D
    [state setD:setBit(currentInstruction, [state getD], @"D", 5)];
};
void (^execute0xcbEBInstruction)(romState *,
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
    // SET 5,E -- Set bit 5 of E
    [state setE:setBit(currentInstruction, [state getE], @"E", 5)];
};
void (^execute0xcbECInstruction)(romState *,
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
    // SET 5,H -- Set bit 5 of H
    [state setH:setBit(currentInstruction, [state getH], @"H", 5)];
};
void (^execute0xcbEDInstruction)(romState *,
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
    // SET 5,L -- Set bit 5 of L
    [state setL:setBit(currentInstruction, [state getL], @"L", 5)];
};
void (^execute0xcbEEInstruction)(romState *,
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
    // SET 5,(HL) -- Set bit 5 of (HL)
    ram[(unsigned short)[state getHL_big]] = setBit(currentInstruction,
                                                    ram[(unsigned short)[state getHL_big]],
                                                    @"(HL)", 5);
};
void (^execute0xcbEFInstruction)(romState *,
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
    // SET 5,A -- Set bit 5 of A
    [state setA:setBit(currentInstruction, [state getA], @"A", 5)];
};