#import "emulatorMain.h"


void (^execute0xcb50Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 2,B -- Test bit 2 of B
    Z = (bool)!([state getB] & 0x00000100);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB50 -- BIT 2,B -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb51Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 2,C -- Test bit 2 of C
    Z = (bool)!([state getC] & 0x00000100);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB51 -- BIT 2,C -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb52Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 2,D -- Test bit 2 of D
    Z = (bool)!([state getD] & 0x00000100);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB52 -- BIT 2,D -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb53Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 2,E -- Test bit 2 of E
    Z = (bool)!([state getE] & 0x00000100);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB53 -- BIT 2,E -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb54Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 2,H -- Test bit 2 of H
    Z = (bool)!([state getH] & 0x00000100);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB54 -- BIT 2,H -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb55Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 2,L -- Test bit 2 of L
    Z = (bool)!([state getL] & 0x00000100);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB55 -- BIT 2,L -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb56Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 2,(HL) -- Test bit 2 of (HL)
    Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00000100);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB56 -- BIT 2,(HL) -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb57Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 2,A -- Test bit 2 of A
    Z = (bool)!([state getA] & 0x00000100);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB57 -- BIT 2,A -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb58Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 3,B -- Test bit 3 of B
    Z = (bool)!([state getB] & 0x00001000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB58 -- BIT 3,B -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb59Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 3,C -- Test bit 3 of C
    Z = (bool)!([state getC] & 0x00001000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB59 -- BIT 3,C -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb5AInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 3,D -- Test bit 3 of D
    Z = (bool)!([state getD] & 0x00001000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB5A -- BIT 3,D -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb5BInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 3,E -- Test bit 3 of E
    Z = (bool)!([state getE] & 0x00001000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB5B -- BIT 3,E -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb5CInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 3,H -- Test bit 3 of H
    Z = (bool)!([state getH] & 0x00001000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB5C -- BIT 3,H -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb5DInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 3,L -- Test bit 3 of L
    Z = (bool)!([state getL] & 0x00001000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB5D -- BIT 3,L -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb5EInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 3,(HL) -- Test bit 3 of (HL)
    Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00001000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB5E -- BIT 3,(HL) -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb5FInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 3,A -- Test bit 3 of A
    Z = (bool)!([state getA] & 0x00001000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB5F -- BIT 3,A -- Z is now %i\n", [state getZFlag]);
};