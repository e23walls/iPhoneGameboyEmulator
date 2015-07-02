#import "emulatorMain.h"


void (^execute0x60Instruction)(romState *,
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

    // LD H,B -- Load B into H
    prev = [state getH];
    [state setH:[state getB]];
    PRINTDBG("0x%02x -- LD H,B -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
             prev, [state getH]);
};

void (^execute0x61Instruction)(romState *,
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

    // LD H,C -- Load C into H
    prev = [state getH];
    [state setH:[state getC]];
    PRINTDBG("0x%02x -- LD H,C -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
             prev, [state getH]);
};

void (^execute0x62Instruction)(romState *,
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

    // LD H,D -- Load D into H
    prev = [state getH];
    [state setH:[state getD]];
    PRINTDBG("0x%02x -- LD H,D -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
             prev, [state getH]);
};

void (^execute0x63Instruction)(romState *,
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

    // LD H,E -- Load E into H
    prev = [state getH];
    [state setH:[state getE]];
    PRINTDBG("0x%02x -- LD H,E -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
             prev, [state getH]);
};

void (^execute0x64Instruction)(romState *,
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
    // LD H,H -- Load H into H -- No-op
    PRINTDBG("0x%02x -- LD H,H\n", currentInstruction);
};

void (^execute0x65Instruction)(romState *,
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

    // LD H,L -- Load L into H
    prev = [state getH];
    [state setH:[state getL]];
    PRINTDBG("0x%02x -- LD H,L -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
             prev, [state getH]);
};

void (^execute0x66Instruction)(romState *,
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
    short prev_short = 0;

    // LD H,(HL) -- Load (HL) into H
    prev = [state getH];
    prev_short = [state getHL_big];
    [state setH:ram[(unsigned short)[state getHL_big]]];
    PRINTDBG("0x%02x -- LD H,(HL) -- H was 0x%02x; HL was 0x%04x; (HL) was 0x%02x; H is now 0x%02x\n", currentInstruction,
             prev & 0xff, prev_short & 0xffff, \
             ram[(unsigned short)prev_short] & 0xff, [state getH] & 0xff);
};

void (^execute0x67Instruction)(romState *,
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

    // LD H,A -- Load A into H
    prev = [state getH];
    [state setH:[state getA]];
    PRINTDBG("0x%02x -- LD H,A -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
             prev, [state getH]);
};

void (^execute0x68Instruction)(romState *,
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

    // LD L,B -- Load B into L
    prev = [state getL];
    [state setL:[state getB]];
    PRINTDBG("0x%02x -- LD L,B -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
             prev, [state getL]);
};

void (^execute0x69Instruction)(romState *,
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

    // LD L,C -- Load C into L
    prev = [state getL];
    [state setL:[state getC]];
    PRINTDBG("0x%02x -- LD L,C -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
             prev, [state getL]);
};

void (^execute0x6AInstruction)(romState *,
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

    // LD L,D -- Load D into L
    prev = [state getL];
    [state setL:[state getD]];
    PRINTDBG("0x%02x -- LD L,D -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
             prev, [state getL]);
};

void (^execute0x6BInstruction)(romState *,
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

    // LD L,E -- Load E into L
    prev = [state getL];
    [state setL:[state getE]];
    PRINTDBG("0x%02x -- LD L,E -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
             prev, [state getL]);
};

void (^execute0x6CInstruction)(romState *,
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

    // LD L,H -- Load H into L
    prev = [state getL];
    [state setL:[state getH]];
    PRINTDBG("0x%02x -- LD L,H -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
             prev, [state getL]);
};

void (^execute0x6DInstruction)(romState *,
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
    // LD L,L -- Load L into L -- No-op
    PRINTDBG("0x%02x -- LD L,L\n", currentInstruction);
};

void (^execute0x6EInstruction)(romState *,
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

    // LD L,(HL) -- Load (HL) into L
    prev = [state getL];
    [state setL:ram[(unsigned short)[state getHL_big]]];
    PRINTDBG("0x%02x -- LD L,(HL) -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
             prev, [state getL]);
};

void (^execute0x6FInstruction)(romState *,
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

    // LD L,A -- Load A into L
    prev = [state getL];
    [state setL:[state getA]];
    PRINTDBG("0x%02x -- LD L,A -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
             prev, [state getL]);
};
