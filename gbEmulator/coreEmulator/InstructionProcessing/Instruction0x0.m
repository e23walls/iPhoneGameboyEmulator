#import "emulatorMain.h"

void (^execute0x00Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // No-op
    PRINTDBG("0x00 -- no-op\n");
};

void (^execute0x01Instruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    unsigned short d16 = 0;

    // LD BC, d16 -- Load 16-bit data into registers BC
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x00ff);
    [state doubleIncPC];
    [state setBC_big:d16];
    PRINTDBG("0x01 -- LD BC, d16 -- d16 = %i\n", d16);
};
void (^execute0x02Instruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // LD BC, A -- Load A into (BC)
    // Cast to unsigned short for case where the number is negative, since it should
    // be interpreted unsigned, but becomes too large a value. -1 should be interpreted as RAMSIZE-1
    ram[(unsigned short)[state getBC_big]] = [state getA];
    PRINTDBG("0x02 -- LD (BC), A -- A is now %d\n", [state getA]);
};
void (^execute0x03Instruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // INC BC -- increment BC
    [state setBC_big:([state getBC_big] + 1)];
    PRINTDBG("0x03 -- INC BC; BC is now %i\n", [state getBC_big]);
};
void (^execute0x04Instruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // INC B -- increment B and set flags
    prev = [state getB];
    [state setB:([state getB] + 1)];
    [state setFlags:([state getB] == 0)
                  N:false
     // (If positive number becomes negative number)
                  H:(prev > [state getB])
                  C:([state getCFlag])];
    PRINTDBG("0x04 -- INC B; B is now %i\n", [state getB]);
};
void (^execute0x05Instruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // DEC B -- decrement B and set flags
    prev = [state getB];
    [state setB:([state getB] - 1)];
    [state setFlags:([state getB] == 0)
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getB] & 0xf) & 0xf)))
                  C:([state getCFlag])];
    PRINTDBG("0x05 -- DEC B; B was %i; B is now %i\n", prev, [state getB]);
};
void (^execute0x06Instruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;

    // LD B, d8 -- load following 8-bit data into B
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state setB:d8];
    PRINTDBG("0x06 -- LD B, d8 -- d8 = %i\n", (int)d8);
};
void (^execute0x07Instruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t A = 0;;
    bool Z = true;
    bool C = true;

    // RLCA -- Rotate A left; C = bit 7, A'[0] = A[7]
    A = [state getA];
    C = (bool)([state getA] & 0b10000000);
    [state setA:([state getA] << 1)];
    // Set LSb of A to its previous MSb
    C ? [state setA:([state getA] | 1)] :
    [state setA:([state getA] & 0b11111110)];
    Z = [state getA] == 0;
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0x07 -- RLCA -- A was 0x%02x; A is now 0x%02x\n", A, [state getA]);
};
void (^execute0x08Instruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    short prev_short = 0;
    unsigned short d16 = 0;

    // LD (a16), SP -- put (SP) at address a16
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
    [state doubleIncPC];
    prev_short =  (ram[(unsigned short)(d16+1)] << 8) | (ram[(unsigned short)d16] & 0x0ff);
    ram[(unsigned short)d16] = ram[(unsigned short)([state getSP]+1)];
    ram[(unsigned short)(d16+1)] = ram[[state getSP]];
    PRINTDBG("0x08 -- LD (a16), SP -- put (SP = 0x%02x) at [d16 = 0x%02x] -- [SP] is 0x%02x -- [d16] was 0x%02x; now 0x%02x\n", [state getSP], d16,
             (ram[[state getSP]] & 0x0ff) | (ram[[state getSP]+1] << 8),
             prev_short, (ram[(unsigned short)(d16+1)] & 0x0ff) | (ram[(unsigned short)d16] << 8));
};
void (^execute0x09Instruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    short prev_short = 0;
    bool Z = true;
    bool H = true;
    bool C = true;

    // ADD HL,BC -- add BC to HL
    // H == carry from bit 11
    // C == carry from bit 15
    prev_short = [state getHL_big];
    [state setHL_big:([state getBC_big]+[state getHL_big])];
    Z = [state getZFlag];
    C = (unsigned short)prev_short > (unsigned short)[state getHL_big];
    H = prev_short > [state getHL_big];
    [state setFlags:Z
                  N:false
                  H:H
                  C:C];
    PRINTDBG("0x09 -- ADD HL,BC -- add BC (%i) and HL (%i) = %i\n", \
             [state getBC_big], prev_short, [state getHL_big]);
};
void (^execute0x0AInstruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // LD A,(BC) -- load (BC) into A
    [state setA:ram[(unsigned short)[state getBC_big]]];
    PRINTDBG("0x0A -- LD A,(BC) -- load (BC == %i -> %i) into A\n", \
             [state getBC_big], (int)ram[(unsigned short)[state getBC_big]]);
};
void (^execute0x0BInstruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int prev_int = 0;

    // DEC BC -- decrement BC
    prev_int = [state getBC_big];
    [state setBC_big:([state getBC_big] - 1)];
    PRINTDBG("0x0B -- DEC BC -- BC was %i; BC is now %i\n", \
             prev_int, [state getBC_big]);
};
void (^execute0x0CInstruction)(romState *,
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

    // INC C -- increment C
    prev = [state getC];
    [state setC:([state getC] + 1)];
    Z = [state getC] == 0;
    H = [state getC] < prev;
    [state setFlags:Z
                  N:false
                  H:H
                  C:[state getCFlag]];
    PRINTDBG("0x%0C -- INC C -- C was %i; C is now %i\n", \
             prev, (int)[state getC]);
};
void (^execute0x0DInstruction)(romState *,
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

    // DEC C -- decrement C
    prev = [state getC];
    [state setC:([state getC] - 1)];
    Z = [state getC] == 0;
    H = !((char)(prev & 0xf) < (char)((([state getC] & 0xf) & 0xf)));
    [state setFlags:Z
                  N:true
                  H:H
                  C:[state getCFlag]];
    PRINTDBG("0x0D -- DEC C -- C was %i; C is now %i\n", \
             prev, (int)[state getC]);
};
void (^execute0x0EInstruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;

    // LD C, d8 -- load immediate 8-bit data into C
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state setC:d8];
    PRINTDBG("0x0E -- LD C, d8 -- d8 = 0x%02x; C is now 0x%02x\n", d8 & 0xff,
             [state getC] & 0xff);
};
void (^execute0x0FInstruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t A = 0;
    bool C = true;

    bool temp = true;
    // RRCA -- rotate A right
    A = [state getA];
    temp = [state getCFlag];
    C = (bool)([state getA] & 0b00000001);
    [state setA:([state getA] >> 1)];
    // Set MSb of A to its previous LSb
    C ? [state setA:([state getA] | 0b10000000)] :
    [state setA:([state getA] & 0b01111111)];
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0x0F -- RRCA -- A was 0x%02x; A is now 0x%02x\n", A, [state getA]);
};

