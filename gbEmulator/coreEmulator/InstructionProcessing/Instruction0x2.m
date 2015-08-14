#import "emulatorMain.h"

void (^execute0x20Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;

    // JR NZ,r8 -- If !Z, add r8 to PC
    d8 = ram[[state getPC]];
    if ([state getZFlag] == false)
    {
        [state addToPC:d8];
    }
    [state incrementPC];
    PRINTDBG("0x20 -- JR NZ, r8 -- if !Z, PC += %i; PC is now 0x%02x\n", (int8_t)d8,
             [state getPC]);
    *incrementPC =false;
};
void (^execute0x21Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    unsigned short d16 = 0;

    // LD HL,d16 -- Load d16 into HL
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x0ff);
    [state doubleIncPC];
    [state setHL_big:d16];
    PRINTDBG("0x21 -- LD HL, d16 -- d16 = 0x%02x; HL = 0x%02x\n", d16, \
             [state getHL_big]);
};
void (^execute0x22Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    short prevHL = 0;

    // LD (HL+),A -- Put A into (HL), and increment HL
    ram[(unsigned short)[state getHL_big]] = [state getA];
    prevHL = [state getHL_big];
    [state setHL_big:(prevHL + 1)];
    PRINTDBG("0x22 -- LD (HL+),A -- HL = 0x%02x; (HL) = 0x%02x; A = %i\n",
             [state getHL_big], ram[(unsigned short)[state getHL_big]],
             [state getA]);
};
void (^execute0x23Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // INC HL -- Increment HL
    [state setHL_big:([state getHL_big] + 1)];
    PRINTDBG("0x23 -- INC HL; HL is now %i\n", [state getHL_big]);
};
void (^execute0x24Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // INC H -- Increment H
    prev = [state getH];
    [state setH:([state getH] + 1)];
    [state setFlags:([state getH] == 0)
                  N:false
                  H:(prev > [state getH])
                  C:([state getCFlag])];
    PRINTDBG("0x24 -- INC H; H is now %i\n", [state getH]);
};
void (^execute0x25Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // DEC H -- Decrement H
    prev = [state getH];
    [state setH:((int8_t)([state getH] - 1))];
    [state setFlags:([state getH] == 0)
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getH] & 0xf) & 0xf)))
                  C:([state getCFlag])];
    PRINTDBG("0x25 -- DEC H; H was %i; H is now %i\n", prev, [state getH]);
};
void (^execute0x26Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;

    // LD H,d8 -- Load 8-bit immediate data into H
    d8 = ram[[state getPC]];
    [state setH:d8];
    [state incrementPC];
    PRINTDBG("0x26 -- LD H, d8 -- d8 = %i\n", (int)d8);
};
void (^execute0x27Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // DAA -- Decimal adjust register A; adjust A so that correct BCD obtained
#warning Do this eventually!!!
    PRINTDBG("0x27 - DAA -- this needs to be done sometime\n");
};
void (^execute0x28Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;

    // JR Z,r8 -- If Z, add r8 to PC
    d8 = ram[[state getPC]];
    [state incrementPC];
    if ([state getZFlag])
    {
        [state addToPC:d8];
    }
    PRINTDBG("0x28 -- JR Z, r8 -- if Z, PC += %i; PC is now 0x%02x\n",
             (int8_t)d8, [state getPC]);
    *incrementPC =false;
};
void (^execute0x29Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    short prev_short = 0;
    bool Z = true;
    bool H = true;
    bool C = true;

    // ADD HL,HL -- Add HL to HL
    prev = [state getHL_little] & 0xf;
    prev_short = [state getHL_big];
    [state setHL_big:(2 * [state getHL_big])];
    Z = [state getZFlag];
    C = (unsigned short)prev_short > (unsigned short)[state getHL_big];
    H = prev_short > [state getHL_big];
    [state setFlags:Z
                  N:false
                  H:H
                  C:C];
    PRINTDBG("0x29 -- ADD HL,HL -- add HL (%i) to itself = %i\n", \
             prev_short, [state getHL_big]);
};
void (^execute0x2AInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // LD A,(HL+) -- Put value at address at HL, (HL), into A, and increment HL
    [state setA:ram[(unsigned short)[state getHL_big]]];
    [state setHL_big:([state getHL_big]+1)];
    PRINTDBG("0x2A -- LD A,(HL+) -- HL is now 0x%02x; A = 0x%02x\n", \
             [state getHL_big], [state getA]);
};
void (^execute0x2BInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int prev_int = 0;

    // DEC HL -- Decrement HL
    prev_int = [state getHL_big];
    [state setHL_big:([state getHL_big] - 1)];
    PRINTDBG("0x2B -- DEC HL -- HL was %i; HL is now %i\n", \
             prev_int, [state getHL_big]);
};
void (^execute0x2CInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // INC L -- Increment L
    prev = [state getL];
    [state setL:([state getL] + 1)];
    [state setFlags:([state getL] == 0)
                  N:false
                  H:(prev > [state getL])
                  C:([state getCFlag])];
    PRINTDBG("0x2C -- INC L; L is now %i\n", [state getL]);
};
void (^execute0x2DInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool Z = true;
    bool H = true;

    // DEC L -- Decrement L
    prev = [state getL];
    [state setL:([state getL] - 1)];
    Z = [state getL] == 0;
    H = !((char)(prev & 0xf) < (char)((([state getL] & 0xf) & 0xf)));
    [state setFlags:Z
                  N:true
                  H:H
                  C:[state getCFlag]];
    PRINTDBG("0x2D -- DEC L -- L was %i; L is now %i\n", \
             prev, (int)[state getL]);
};
void (^execute0x2EInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;

    // LD L,d8 -- Load 8-bit immediate data into L
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state setL:d8];
    PRINTDBG("0x2E -- LD L, d8 -- d8 = %i\n", (short)d8);
};
void (^execute0x2FInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // CPL -- Complement A
    prev = [state getA];
    [state setA:([state getA] ^ 0xff)];
    [state setFlags:[state getZFlag]
                  N:true
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0x2F -- CPL A -- A was %i; A is now %i\n", prev, [state getA]);
};

