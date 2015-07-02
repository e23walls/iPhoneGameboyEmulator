#import "emulatorMain.h"


void (^execute0x50Instruction)(romState *,
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

    // LD D,B -- Load B into D
    prev = [state getD];
    [state setD:[state getB]];
    PRINTDBG("0x%02x -- LD D,B -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
             prev, [state getD]);
};
void (^execute0x51Instruction)(romState *,
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

    // LD D,C -- Load C into D
    prev = [state getD];
    [state setC:[state getB]];
    PRINTDBG("0x%02x -- LD D,C -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
             prev, [state getD]);
};
void (^execute0x52Instruction)(romState *,
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
    // LD D,D -- Load D into D -- No-op
    PRINTDBG("0x%02x -- LD D,D\n", currentInstruction);
};
void (^execute0x53Instruction)(romState *,
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
    // LD D,E -- Load E into D
    prev = [state getD];
    [state setD:[state getE]];
    PRINTDBG("0x%02x -- LD D,E -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
             prev, [state getD]);
};
void (^execute0x54Instruction)(romState *,
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

    // LD D,H -- Load H into D
    prev = [state getD];
    [state setD:[state getH]];
    PRINTDBG("0x%02x -- LD D,H -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
             prev, [state getD]);
};
void (^execute0x55Instruction)(romState *,
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

    // LD D,L -- Load L into D
    prev = [state getD];
    [state setD:[state getL]];
    PRINTDBG("0x%02x -- LD D,L -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
             prev, [state getD]);
};
void (^execute0x56Instruction)(romState *,
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

    // LD D,(HL) -- Load (HL) into D
    prev = [state getD];
    [state setD:ram[(unsigned short)[state getHL_big]]];
    PRINTDBG("0x%02x -- LD D,(HL) -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
             prev, [state getD]);
};
void (^execute0x57Instruction)(romState *,
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

    // LD D,A -- Load A into D
    prev = [state getD];
    [state setD:[state getA]];
    PRINTDBG("0x%02x -- LD D,A -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
             prev, [state getD]);
};
void (^execute0x58Instruction)(romState *,
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

    // LD E,B -- Load B into E
    prev = [state getE];
    [state setE:[state getB]];
    PRINTDBG("0x%02x -- LD E,B -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
             prev, [state getE]);
};
void (^execute0x59Instruction)(romState *,
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

    // LD E,C -- Load C into E
    prev = [state getE];
    [state setE:[state getC]];
    PRINTDBG("0x%02x -- LD E,C -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
             prev, [state getE]);
};
void (^execute0x5AInstruction)(romState *,
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

    // LD E,D -- Load D into E
    prev = [state getE];
    [state setE:[state getD]];
    PRINTDBG("0x%02x -- LD E,D -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
             prev, [state getE]);
};
void (^execute0x5BInstruction)(romState *,
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

    // LD E,E -- Load E into E -- No-op
    prev = [state getE];
    [state setE:[state getB]];
    PRINTDBG("0x%02x -- LD E,E\n", currentInstruction);
};
void (^execute0x5CInstruction)(romState *,
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

    // LD E,H -- Load H into E; A very Canadian instruction
    prev = [state getE];
    [state setE:[state getH]];
    PRINTDBG("0x%02x -- Load, eh? -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
             prev, [state getE]);
};
void (^execute0x5DInstruction)(romState *,
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

    // LD E,L -- Load L into E
    prev = [state getE];
    [state setE:[state getL]];
    PRINTDBG("0x%02x -- LD E,L -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
             prev, [state getE]);
};
void (^execute0x5EInstruction)(romState *,
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

    // LD E,(HL) -- Load (HL) into E
    prev = [state getE];
    [state setE:ram[(unsigned short)[state getHL_big]]];
    PRINTDBG("0x%02x -- LD E,(HL) -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
             prev, [state getE]);
};
void (^execute0x5FInstruction)(romState *,
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

    // LD E,A -- Load A into E
    prev = [state getE];
    [state setE:[state getA]];
    PRINTDBG("0x%02x -- LD E,A -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
             prev, [state getE]);
};