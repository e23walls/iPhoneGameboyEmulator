#import "emulatorMain.h"

void (^execute0xcb70Instruction)(romState *,
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
    bool Z = false;
    // BIT 6,B -- Test bit 6 of B
    Z = (bool)!([state getB] & 0x01000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 6,B -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb71Instruction)(romState *,
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
    bool Z = false;

    // BIT 6,C -- Test bit 6 of C
    Z = (bool)!([state getC] & 0x01000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 6,C -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb72Instruction)(romState *,
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
    bool Z = false;

    // BIT 6,D -- Test bit 6 of D
    Z = (bool)!([state getD] & 0x01000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 6,D -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb73Instruction)(romState *,
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
    bool Z = false;

    // BIT 6,E -- Test bit 6 of E
    Z = (bool)!([state getE] & 0x01000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 6,E -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb74Instruction)(romState *,
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
    bool Z = false;

    // BIT 6,H -- Test bit 6 of H
    Z = (bool)!([state getH] & 0x01000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 6,H -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb75Instruction)(romState *,
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
    bool Z = false;

    // BIT 6,L -- Test bit 6 of L
    Z = (bool)!([state getL] & 0x01000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 6,L -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb76Instruction)(romState *,
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
    bool Z = false;

    // BIT 6,(HL) -- Test bit 6 of (HL)
    Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x01000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 6,(HL) -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb77Instruction)(romState *,
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
    bool Z = false;

    // BIT 6,A -- Test bit 6 of A
    Z = (bool)!([state getA] & 0x01000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 6,A -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb78Instruction)(romState *,
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
    bool Z = false;

    // BIT 7,B -- Test bit 7 of B
    Z = (bool)!([state getB] & 0x10000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 7,B -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb79Instruction)(romState *,
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
    bool Z = false;

    // BIT 7,C -- Test bit 7 of C
    Z = (bool)!([state getC] & 0x10000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 7,C -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb7AInstruction)(romState *,
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
    bool Z = false;

    // BIT 7,D -- Test bit 7 of D
    Z = (bool)!([state getD] & 0x10000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 7,D -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb7BInstruction)(romState *,
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
    bool Z = false;

    // BIT 7,E -- Test bit 7 of E
    Z = (bool)!([state getE] & 0x10000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 7,E -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb7CInstruction)(romState *,
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
    // BIT 7,H -- test 7th bit of H register
    [state setFlags:(bool)([state getH] & (int8_t)0b10000000)
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 7,H -- H is 0x%02x -- Z is now %i\n", currentInstruction,
             [state getH], [state getZFlag]);
};
void (^execute0xcb7DInstruction)(romState *,
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
    bool Z = false;

    // BIT 7,L -- Test bit 7 of L
    Z = (bool)!([state getL] & 0x10000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 7,L -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb7EInstruction)(romState *,
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
    bool Z = false;

    // BIT 7,(HL) -- Test bit 7 of (HL)
    Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x10000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 7,(HL) -- Z is now %i\n", currentInstruction, [state getZFlag]);
};
void (^execute0xcb7FInstruction)(romState *,
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
    bool Z = false;

    // BIT 7,A -- Test bit 7 of A
    Z = (bool)!([state getA] & 0x10000000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB%02x -- BIT 7,A -- Z is now %i\n", currentInstruction, [state getZFlag]);
};