#import "emulatorMain.h"


void (^execute0x70Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD (HL),B -- Load B into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getB];
    PRINTDBG("0x70 -- LD (HL),B -- (HL) was 0x%02x; (HL) is now 0x%02x\n", \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x71Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD (HL),C -- Load C into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getC];
    PRINTDBG("0x71 -- LD (HL),C -- (HL) was 0x%02x; (HL) is now 0x%02x\n", \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x72Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD (HL),D -- Load D into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getD];
    PRINTDBG("0x72 -- LD (HL),D -- (HL) was 0x%02x; (HL) is now 0x%02x\n", \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x73Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD (HL),E -- Load E into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getE];
    PRINTDBG("0x73 -- LD (HL),E -- (HL) was 0x%02x; (HL) is now 0x%02x\n", \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x74Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD (HL),H -- Load H into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getH];
    PRINTDBG("0x74 -- LD (HL),H -- (HL) was 0x%02x; (HL) is now 0x%02x\n", \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x75Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD (HL),L -- Load L into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getL];
    PRINTDBG("0x75 -- LD (HL),L -- (HL) was 0x%02x; (HL) is now 0x%02x\n", \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x76Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // HALT -- Power down CPU until interrupt occurs
#warning DO THIS EVENTUALLY!
    PRINTDBG("0x76 -- HALT\n");
};
void (^execute0x77Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD (HL),A -- Load A into (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = [state getA];
    PRINTDBG("0x77 -- LD (HL),A -- (HL) was 0x%02x; (HL) is now 0x%02x\n", \
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0x78Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD A,B -- Load B into A
    prev = [state getA];
    [state setA:[state getB]];
    PRINTDBG("0x78 -- LD A,B -- A was 0x%02x; A is now 0x%02x\n", \
             prev, [state getA]);
};
void (^execute0x79Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD A,C -- Load C into A
    prev = [state getA];
    [state setA:[state getC]];
    PRINTDBG("0x79 -- LD A,C -- A was 0x%02x; A is now 0x%02x\n", \
             prev, [state getA]);
};
void (^execute0x7AInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD A,D -- Load D into A
    prev = [state getA];
    [state setA:[state getD]];
    PRINTDBG("0x7A -- LD A,D -- A was 0x%02x; A is now 0x%02x\n", \
             prev, [state getA]);
};
void (^execute0x7BInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD A,E -- Load E into A
    prev = [state getA];
    [state setA:[state getE]];
    PRINTDBG("0x7B -- LD A,E -- A was 0x%02x; A is now 0x%02x\n", \
             prev, [state getA]);
};
void (^execute0x7CInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD A,H -- Load H into A
    prev = [state getA];
    [state setA:[state getH]];
    PRINTDBG("0x7C -- LD A,H -- A was 0x%02x; A is now 0x%02x\n", \
             prev, [state getA]);
};
void (^execute0x7DInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD A,L -- Load L into A
    prev = [state getA];
    [state setA:[state getL]];
    PRINTDBG("0x7D -- LD A,L -- A was 0x%02x; A is now 0x%02x\n", \
             prev, [state getA]);
};
void (^execute0x7EInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // LD A,(HL) -- Load (HL) into A
    prev = [state getA];
    [state setA:ram[(unsigned short)[state getHL_big]]];
    PRINTDBG("0x7E -- LD A,(HL) -- A was 0x%02x; A is now 0x%02x\n", \
             prev, [state getA]);
};
void (^execute0x7FInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // LD A,A -- Load A into A -- No-op
    PRINTDBG("0x7F -- LD A,A\n");
};