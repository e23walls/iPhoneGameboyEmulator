#import "emulatorMain.h"

void (^execute0x80Instruction)(romState *,
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
    bool C = false;
    bool H = false;

    // ADD A,B -- Add B to A
    prev = [state getA];
    [state setA:([state getA] + [state getB])];
    C = (unsigned char)prev > (unsigned char)[state getA];
    H = prev > [state getA];
    [state setFlags:[state getA] == 0
                  N:false
                  H:H // carry from bit 3
                  C:C]; // carry from bit 7
    PRINTDBG("0x%02x -- ADD A,B -- add A (%i) and B (%i) = %i\n", currentInstruction & 0xff, \
             prev, [state getB], [state getA]);
};
void (^execute0x81Instruction)(romState *,
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
    bool C = false;
    bool H = false;

    // ADD A,C -- Add C to A
    prev = [state getA];
    [state setA:([state getA] + [state getC])];
    C = (unsigned char)prev > (unsigned char)[state getA];
    H = prev > [state getA];
    [state setFlags:[state getA] == 0
                  N:false
                  H:H // carry from bit 3
                  C:C]; // carry from bit 7
    PRINTDBG("0x%02x -- ADD A,C -- add A (%i) and C (%i) = %i\n", currentInstruction & 0xff, \
             prev, [state getC], [state getA]);
};
void (^execute0x82Instruction)(romState *,
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
    bool C = false;
    bool H = false;

    // ADD A,D -- Add D to A
    prev = [state getA];
    [state setA:([state getA] + [state getD])];
    C = (unsigned char)prev > (unsigned char)[state getA];
    H = prev > [state getA];
    [state setFlags:[state getA] == 0
                  N:false
                  H:H // carry from bit 3
                  C:C]; // carry from bit 7
    PRINTDBG("0x%02x -- ADD A,D -- add A (%i) and D (%i) = %i\n", currentInstruction & 0xff, \
             prev, [state getD], [state getA]);
};
void (^execute0x83Instruction)(romState *,
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
    bool C = false;
    bool H = false;

    // ADD A,E -- Add E to A
    prev = [state getA];
    [state setA:([state getA] + [state getE])];
    C = (unsigned char)prev > (unsigned char)[state getA];
    H = prev > [state getA];
    [state setFlags:[state getA] == 0
                  N:false
                  H:H // carry from bit 3
                  C:C]; // carry from bit 7
    PRINTDBG("0x%02x -- ADD A,E -- add A (%i) and E (%i) = %i\n", currentInstruction & 0xff, \
             prev, [state getE], [state getA]);
};
void (^execute0x84Instruction)(romState *,
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
    bool C = false;
    bool H = false;

    // ADD A,H -- Add H to A
    prev = [state getA];
    [state setA:([state getA] + [state getH])];
    C = (unsigned char)prev > (unsigned char)[state getA];
    H = prev > [state getA];
    [state setFlags:[state getA] == 0
                  N:false
                  H:H // carry from bit 3
                  C:C]; // carry from bit 7
    PRINTDBG("0x%02x -- ADD A,H -- add A (%i) and H (%i) = %i\n", currentInstruction & 0xff, \
             prev, [state getH], [state getA]);
};
void (^execute0x85Instruction)(romState *,
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
    bool C = false;
    bool H = false;

    // ADD A,L -- Add L to A
    prev = [state getA];
    [state setA:([state getA] + [state getL])];
    C = (unsigned char)prev > (unsigned char)[state getA];
    H = prev > [state getA];
    [state setFlags:[state getA] == 0
                  N:false
                  H:H // carry from bit 3
                  C:C]; // carry from bit 7
    PRINTDBG("0x%02x -- ADD A,L -- add A (%i) and L (%i) = %i\n", currentInstruction & 0xff, \
             prev, [state getL], [state getA]);
};
void (^execute0x86Instruction)(romState *,
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
    int8_t d8 = 0;
    bool C = false;
    bool H = false;

    // ADD A,(HL) -- Add (HL) to A
    prev = [state getA];
    d8 = ram[(unsigned short)[state getHL_big]];
    [state setA:([state getA] + d8)];
    C = (unsigned char)prev > (unsigned char)[state getA];
    H = prev > [state getA];
    [state setFlags:[state getA] == 0
                  N:false
                  H:H // carry from bit 3
                  C:C]; // carry from bit 7
    PRINTDBG("0x%02x -- ADD A,(HL) -- add A (%i) and (HL) (%i) = %i\n", currentInstruction & 0xff, \
             prev, d8, [state getA]);
};
void (^execute0x87Instruction)(romState *,
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
    bool C = false;
    bool H = false;

    // ADD A,A -- Add A to A
    prev = [state getA];
    prev_short = [state getA];
    [state setA:(2 * [state getA])];
    C = (unsigned char)prev > (unsigned char)[state getA];
    H = prev > [state getA];
    [state setFlags:[state getA] == 0
                  N:false
                  H:H // carry from bit 3
                  C:C]; // carry from bit 7
    PRINTDBG("0x%02x -- ADD A,A -- add A (%i) and A (%i) = %i\n", currentInstruction & 0xff, \
             prev, prev, [state getA]);
};
void (^execute0x88Instruction)(romState *,
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

    // ADC A,B -- Add B + C-flag to A
    prev = [state getA];
    if ([state getCFlag])
    {
        [state setA:[state getA]+[state getB]+1];
    }
    else
    {
        [state setA:[state getA]+[state getB]];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if carry from bit 4.
     C - Set if carry (from bit 7).
     */
    [state setFlags:[state getA] == 0
                  N:false
                  H:((char)(prev & 0xf) > (char)([state getA] & 0xf))
                  C:((unsigned char)(prev) > (unsigned char)([state getA]))];
    PRINTDBG("0x%02x -- ADC A,B -- A was 0x%02x; A is now 0x%02x; B = 0x%02x\n", currentInstruction & 0xff,
             prev, [state getA], [state getB]);
};
void (^execute0x89Instruction)(romState *,
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

    // ADC A,C -- Add C + C-flag to A
    prev = [state getA];
    if ([state getCFlag])
    {
        [state setA:[state getA]+[state getC]+1];
    }
    else
    {
        [state setA:[state getA]+[state getC]];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if carry from bit 4.
     C - Set if carry (from bit 7).
     */
    [state setFlags:[state getA] == 0
                  N:false
                  H:((char)(prev & 0xf) > (char)([state getA] & 0xf))
                  C:((unsigned char)(prev) > (unsigned char)([state getA]))];
    PRINTDBG("0x%02x -- ADC A,C -- A was 0x%02x; A is now 0x%02x; C = 0x%02x\n", currentInstruction & 0xff,
             prev, [state getA], [state getC]);
};
void (^execute0x8AInstruction)(romState *,
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

    // ADC A,D -- Add D + C-flag to A
    prev = [state getA];
    if ([state getCFlag])
    {
        [state setA:[state getA]+[state getD]+1];
    }
    else
    {
        [state setA:[state getA]+[state getD]];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if carry from bit 4.
     C - Set if carry (from bit 7).
     */
    [state setFlags:[state getA] == 0
                  N:false
                  H:((char)(prev & 0xf) > (char)([state getA] & 0xf))
                  C:((unsigned char)(prev) > (unsigned char)([state getA]))];
    PRINTDBG("0x%02x -- ADC A,D -- A was 0x%02x; A is now 0x%02x; D = 0x%02x\n", currentInstruction & 0xff,
             prev, [state getA], [state getD]);
};
void (^execute0x8BInstruction)(romState *,
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

    // ADC A,E -- Add E + C-flag to A
    prev = [state getA];
    if ([state getCFlag])
    {
        [state setA:[state getA]+[state getE]+1];
    }
    else
    {
        [state setA:[state getA]+[state getE]];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if carry from bit 4.
     C - Set if carry (from bit 7).
     */
    [state setFlags:[state getA] == 0
                  N:false
                  H:((char)(prev & 0xf) > (char)([state getA] & 0xf))
                  C:((unsigned char)(prev) > (unsigned char)([state getA]))];
    PRINTDBG("0x%02x -- ADC A,E -- A was 0x%02x; A is now 0x%02x; E = 0x%02x\n", currentInstruction & 0xff,
             prev, [state getA], [state getE]);
};
void (^execute0x8CInstruction)(romState *,
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

    // ADC A,H -- Add H + C-flag to A
    prev = [state getA];
    if ([state getCFlag])
    {
        [state setA:[state getA]+[state getH]+1];
    }
    else
    {
        [state setA:[state getA]+[state getH]];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if carry from bit 4.
     C - Set if carry (from bit 7).
     */
    [state setFlags:[state getA] == 0
                  N:false
                  H:((char)(prev & 0xf) > (char)([state getA] & 0xf))
                  C:((unsigned char)(prev) > (unsigned char)([state getA]))];
    PRINTDBG("0x%02x -- ADC A,H -- A was 0x%02x; A is now 0x%02x; H = 0x%02x\n", currentInstruction & 0xff,
             prev, [state getA], [state getH]);
};
void (^execute0x8DInstruction)(romState *,
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

    // ADC A,L -- Add L + C-flag to A
    prev = [state getA];
    if ([state getCFlag])
    {
        [state setA:[state getA]+[state getL]+1];
    }
    else
    {
        [state setA:[state getA]+[state getL]];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if carry from bit 4.
     C - Set if carry (from bit 7).
     */
    [state setFlags:[state getA] == 0
                  N:false
                  H:((char)(prev & 0xf) > (char)([state getA] & 0xf))
                  C:((unsigned char)(prev) > (unsigned char)([state getA]))];
    PRINTDBG("0x%02x -- ADC A,L -- A was 0x%02x; A is now 0x%02x; L = 0x%02x\n", currentInstruction & 0xff,
             prev, [state getA], [state getL]);
};
void (^execute0x8EInstruction)(romState *,
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
    int8_t d8 = 0;

    // ADC A,(HL) -- Add (HL) + C-flag to A
    prev = [state getA];
    d8 = ram[(unsigned short)[state getHL_big]];
    if ([state getCFlag])
    {
        [state setA:[state getA]+d8+1];
    }
    else
    {
        [state setA:[state getA]+d8];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if carry from bit 4.
     C - Set if carry (from bit 7).
     */
    [state setFlags:[state getA] == 0
                  N:false
                  H:((char)(prev & 0xf) > (char)([state getA] & 0xf))
                  C:((unsigned char)(prev) > (unsigned char)([state getA]))];
    PRINTDBG("0x%02x -- ADC A,B -- A was 0x%02x; A is now 0x%02x; HL = 0x%02x; (HL) = 0x%02x\n", currentInstruction & 0xff,
             prev, [state getA], [state getHL_big] & 0xffff, d8 & 0xff);
};
void (^execute0x8FInstruction)(romState *,
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

    // ADC A,A -- Add A + C-flag to A
    prev = [state getA];
    if ([state getCFlag])
    {
        [state setA:[state getA]*2+1];
    }
    else
    {
        [state setA:[state getA]*2];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if carry from bit 4.
     C - Set if carry (from bit 7).
     */
    [state setFlags:[state getA] == 0
                  N:false
                  H:((char)(prev & 0xf) > (char)([state getA] & 0xf))
                  C:((unsigned char)(prev) > (unsigned char)([state getA]))];
    PRINTDBG("0x%02x -- ADC A,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction & 0xff,
             prev, [state getA]);
};