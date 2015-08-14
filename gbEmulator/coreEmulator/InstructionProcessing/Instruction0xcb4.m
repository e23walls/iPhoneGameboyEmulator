#import "emulatorMain.h"


void (^execute0xcb40Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 0,B -- Test bit 0 of B
    Z = (bool)!([state getB] & 0x00000001);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB40 -- BIT 0,B -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb41Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 0,C -- Test bit 0 of C
    Z = (bool)!([state getC] & 0x00000001);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB41 -- BIT 0,C -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb42Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 0,D -- Test bit 0 of D
    Z = (bool)!([state getD] & 0x00000001);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB42 -- BIT 0,D -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb43Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 0,E -- Test bit 0 of E
    Z = (bool)!([state getE] & 0x00000001);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB43 -- BIT 0,E -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb44Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 0,H -- Test bit 0 of H
    Z = (bool)!([state getH] & 0x00000001);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB44 -- BIT 0,H -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb45Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 0,L -- Test bit 0 of L
    Z = (bool)!([state getL] & 0x00000001);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB45 -- BIT 0,L -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb46Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 0,(HL) -- Test bit 0 of (HL)
    Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00000001);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB46 -- BIT 0,(HL) -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb47Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 0,A -- Test bit 0 of A
    Z = (bool)!([state getA] & 0x00000001);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB47 -- BIT 0,A -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb48Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 1,B -- Test bit 1 of B
    Z = (bool)!([state getB] & 0x00000010);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB48 -- BIT 1,B -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb49Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 1,C -- Test bit 1 of C
    Z = (bool)!([state getC] & 0x00000010);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB49 -- BIT 1,C -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb4AInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 1,D -- Test bit 1 of D
    Z = (bool)!([state getD] & 0x00000010);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB4A -- BIT 1,D -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb4BInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 1,E -- Test bit 1 of E
    Z = (bool)!([state getE] & 0x00000010);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB4B -- BIT 1,E -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb4CInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 1,H -- Test bit 1 of H
    Z = (bool)!([state getH] & 0x00000010);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB4C -- BIT 1,H -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb4DInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 1,L -- Test bit 1 of L
    Z = (bool)!([state getL] & 0x00000010);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB4D -- BIT 1,L -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb4EInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 1,(HL) -- Test bit 1 of (HL)
    Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00000010);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB4E -- BIT 1,(HL) -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb4FInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 1,A -- Test bit 1 of A
    Z = (bool)!([state getA] & 0x00000010);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB4F -- BIT 1,A -- Z is now %i\n", [state getZFlag]);
};