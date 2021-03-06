#import "emulatorMain.h"

void (^execute0x10Instruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    //    int8_t previousButtons = self.buttons;
    // STOP
    // Wait for button press before changing processor and screen
#warning Figure this out
    //            while ((self.buttons ^ previousButtons) == 0)
    //            {/* Do nothing but wait */}
    PRINTDBG("0x10 -- STOP\n");
    // Pause execution
    // When view gets keyboard input, resume.
    
};
void (^execute0x11Instruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    unsigned short d16 = 0;

    // LD DE, d16 -- Load d16 into DE
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x0ff);
    [state doubleIncPC];
    [state setDE_big:d16];
    PRINTDBG("0x11 -- LD DE, d16 -- d16 = 0x%02x\n", d16 & 0xffff);
};
void (^execute0x12Instruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // LD (DE), A -- put A into (DE)
    ram[(unsigned short)[state getDE_big]] = [state getA];
    PRINTDBG("0x12 -- LD (DE), A -- A = %i\n", [state getA] & 0xff);
};
void (^execute0x13Instruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // INC DE -- Increment DE
    [state setDE_big:([state getDE_big] + 1)];
    PRINTDBG("0x13 -- INC DE; DE is now %i\n", [state getDE_big] & 0xffff);
};
void (^execute0x14Instruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // INC D -- Increment D
    prev = [state getD];
    [state setD:([state getD] + 1)];
    [state setFlags:([state getD] == 0)
                  N:false
                  H:(prev > [state getD])
                  C:([state getCFlag])];
    PRINTDBG("0x14 -- INC D; D is now %i\n", [state getD] & 0xff);
};
void (^execute0x15Instruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // DEC D -- Decrement D
    prev = [state getD];
    [state setD:([state getD] - 1)];
    [state setFlags:([state getD] == 0)
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getD] & 0xf) & 0xf)))
                  C:([state getCFlag])];
    PRINTDBG("0x15 -- DEC D; D was %i; D is now %i\n", prev & 0xff, [state getD] & 0xff);
};
void (^execute0x16Instruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;

    // LD D, d8 -- load 8-bit immediate value into D
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state setD:d8];
    PRINTDBG("0x16 -- LD D, d8 -- d8 = %i\n", (int)d8);
};

void (^execute0x17Instruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t A = 0;
    bool C = false;

    // RLA -- Rotate A left through carry flag
    int8_t prevA = [state getA];
    A = [state getA] << 1;
    C = (bool)([state getA] & 0b10000000);
    // Set LSb of A to its previous C-value
    [state getCFlag] ? [state setA:(A | 1)] : [state setA:(A & 0b11111110)];
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0x17 -- RLA -- A was 0x%02x; A is now 0x%02x\n", prevA & 0xff, [state getA] & 0xff);
};
void (^execute0x18Instruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;

    // JR r8 (8-bit signed data, added to PC)
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state addToPC:d8];
    PRINTDBG("0x18 -- JR r8 (r8 = %d) -- PC is now 0x%02x\n", d8 & 0xff, [state getPC] & 0xffff);
};
void (^execute0x19Instruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    short prev_short = 0;
    bool Z = true;
    bool H = true;
    bool C = true;

    // ADD HL,DE -- add DE to HL
    // H = carry from bit 11; C = carry from bit 15; reset N; leave Z alone
    prev = [state getHL_little] & 0xf;
    prev_short = [state getHL_big];
    [state setHL_big:([state getDE_big]+[state getHL_big])];
    Z = [state getZFlag];
    C = (unsigned short)prev_short > (unsigned short)[state getHL_big];
    H = prev_short > [state getHL_big];
    [state setFlags:Z
                  N:false
                  H:H
                  C:C];
    PRINTDBG("0x19 -- ADD HL,DE -- add DE (%i) and HL (%i) = %i\n", \
             [state getDE_big] & 0xffff, prev_short & 0xffff, [state getHL_big] & 0xffff);
};
void (^execute0x1AInstruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // LD A,(DE) - load (DE) into A
    [state setA:(ram[(unsigned short)[state getDE_big]])];
    PRINTDBG("0x1A -- LD A,(DE) -- load (DE == 0x%04x) = 0x%02x into A\n", \
             [state getDE_big] & 0xffff, ram[(unsigned short)[state getDE_big]] & 0xff);
};
void (^execute0x1BInstruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int prev_int = 0;

    // DEC DE -- Decrement DE
    prev_int = [state getDE_big];
    [state setDE_big:([state getDE_big] - 1)];
    PRINTDBG("0x1B -- DEC DE -- DE was %i; DE is now %i\n", \
             prev_int & 0xffff, [state getDE_big] & 0xffff);
};
void (^execute0x1CInstruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // INC E -- Increment E
    prev = [state getE];
    [state setE:([state getE] + 1)];
    [state setFlags:([state getE] == 0)
                  N:false
                  H:(prev > [state getE])
                  C:([state getCFlag])];
    PRINTDBG("0x1C -- INC E; E = %i\n", [state getE] & 0xff);
};
void (^execute0x1DInstruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool Z = true;
    bool H = true;

    // DEC E -- Decrement E
    prev = [state getE];
    [state setE:([state getE] - 1)];
    Z = [state getE] == 0;
    H = !((char)(prev & 0xf) < (char)((([state getE] & 0xf) & 0xf)));
    [state setFlags:Z
                  N:true
                  H:H
                  C:[state getCFlag]];
    PRINTDBG("0x1D -- DEC E -- E was %i; E is now %i\n", \
             prev & 0xff, [state getE] & 0xff);
};
void (^execute0x1EInstruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;

    // LD E,d8 -- Load immediate 8-bit data into E
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state setE:d8];
    PRINTDBG("0x1E -- LD E, d8 -- d8 = %i\n", d8 & 0xff);
};
void (^execute0x1FInstruction)(RomState *,
                               int8_t *,
                               bool *,
                               int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t A = 0;
    bool C = false;

    // RRA -- Rotate A right through carry flag
    A = [state getA] >> 1;
    C = (bool)([state getA] & 0b00000001);
    // Set MSb of A to its previous C-value
    [state getCFlag] ? [state setA:(A | 0b10000000)] : [state setA:(A & 0b01111111)];
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0x1F -- RRA -- A was 0x%02x; A is now 0x%02x\n", A & 0xff, [state getA] & 0xff);
};

