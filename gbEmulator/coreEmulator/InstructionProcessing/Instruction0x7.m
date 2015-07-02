#import "emulatorMain.h"


void (^execute0x70Instruction)(romState *,
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
    int8_t prev = 0;

    // LD (HL),B -- Load B into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getB];
    PRINTDBG("0x%02x -- LD (HL),B -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x71Instruction)(romState *,
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
    int8_t prev = 0;

    // LD (HL),C -- Load C into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getC];
    PRINTDBG("0x%02x -- LD (HL),C -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x72Instruction)(romState *,
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
    int8_t prev = 0;

    // LD (HL),D -- Load D into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getD];
    PRINTDBG("0x%02x -- LD (HL),D -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x73Instruction)(romState *,
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
    int8_t prev = 0;

    // LD (HL),E -- Load E into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getE];
    PRINTDBG("0x%02x -- LD (HL),E -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x74Instruction)(romState *,
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
    int8_t prev = 0;

    // LD (HL),H -- Load H into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getH];
    PRINTDBG("0x%02x -- LD (HL),H -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x75Instruction)(romState *,
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
    int8_t prev = 0;

    // LD (HL),L -- Load L into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getL];
    PRINTDBG("0x%02x -- LD (HL),L -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x76Instruction)(romState *,
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
    // HALT -- Power down CPU until interrupt occurs
#warning DO THIS EVENTUALLY!
    PRINTDBG("0x%02x -- HALT\n", currentInstruction);
};
void (^execute0x77Instruction)(romState *,
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
    int8_t prev = 0;

    // LD (HL),A -- Load A into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getA];
    PRINTDBG("0x%02x -- LD (HL),A -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x78Instruction)(romState *,
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
    int8_t prev = 0;

    // LD A,B -- Load B into A
    prev = [state getA];
    [state setA:[state getB]];
    PRINTDBG("0x%02x -- LD A,B -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
             prev, [state getA]);
};
void (^execute0x79Instruction)(romState *,
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
    int8_t prev = 0;

    // LD A,C -- Load C into A
    prev = [state getA];
    [state setA:[state getC]];
    PRINTDBG("0x%02x -- LD A,C -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
             prev, [state getA]);
};
void (^execute0x7AInstruction)(romState *,
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
    int8_t prev = 0;

    // LD A,D -- Load D into A
    prev = [state getA];
    [state setA:[state getD]];
    PRINTDBG("0x%02x -- LD A,D -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
             prev, [state getA]);
};
void (^execute0x7BInstruction)(romState *,
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
    int8_t prev = 0;

    // LD A,E -- Load E into A
    prev = [state getA];
    [state setA:[state getE]];
    PRINTDBG("0x%02x -- LD A,E -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
             prev, [state getA]);
};
void (^execute0x7CInstruction)(romState *,
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
    int8_t prev = 0;

    // LD A,H -- Load H into A
    prev = [state getA];
    [state setA:[state getH]];
    PRINTDBG("0x%02x -- LD A,H -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
             prev, [state getA]);
};
void (^execute0x7DInstruction)(romState *,
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
    int8_t prev = 0;

    // LD A,L -- Load L into A
    prev = [state getA];
    [state setA:[state getL]];
    PRINTDBG("0x%02x -- LD A,L -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
             prev, [state getA]);
};
void (^execute0x7EInstruction)(romState *,
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
    int8_t prev = 0;

    // LD A,(HL) -- Load (HL) into A
    prev = [state getA];
    [state setA:ram[(unsigned short)[state getHL_big]]];
    PRINTDBG("0x%02x -- LD A,(HL) -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
             prev, [state getA]);
};
void (^execute0x7FInstruction)(romState *,
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
    // LD A,A -- Load A into A -- No-op
    PRINTDBG("0x%02x -- LD A,A\n", currentInstruction);
};