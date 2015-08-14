#import "emulatorMain.h"


void (^execute0xcb60Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 4,B -- Test bit 4 of B
    Z = (bool)!([state getB] & 0x00010000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB60 -- BIT 4,B -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb61Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 4,C -- Test bit 4 of C
    Z = (bool)!([state getC] & 0x00010000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB61 -- BIT 4,C -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb62Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 4,D -- Test bit 4 of D
    Z = (bool)!([state getD] & 0x00010000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB62 -- BIT 4,D -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb63Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 4,E -- Test bit 4 of E
    Z = (bool)!([state getE] & 0x00010000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB63 -- BIT 4,E -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb64Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 4,H -- Test bit 4 of H
    Z = (bool)!([state getH] & 0x00010000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB64 -- BIT 4,H -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb65Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 4,L -- Test bit 4 of L
    Z = (bool)!([state getL] & 0x00010000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB65 -- BIT 4,L -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb66Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 4,(HL) -- Test bit 4 of (HL)
    Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00010000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB66 -- BIT 4,(HL) -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb67Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 4,A -- Test bit 4 of A
    Z = (bool)!([state getA] & 0x00010000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB67 -- BIT 4,A -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb68Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 5,B -- Test bit 5 of B
    Z = (bool)!([state getB] & 0x00100000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB68 -- BIT 5,B -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb69Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 5,C -- Test bit 5 of C
    Z = (bool)!([state getC] & 0x00100000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB69 -- BIT 5,C -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb6AInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 5,D -- Test bit 5 of D
    Z = (bool)!([state getD] & 0x00100000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB6A -- BIT 5,D -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb6BInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 5,E -- Test bit 5 of E
    Z = (bool)!([state getE] & 0x00100000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB6B -- BIT 5,E -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb6CInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 5,H -- Test bit 5 of H
    Z = (bool)!([state getH] & 0x00100000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB6C -- BIT 5,H -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb6DInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 5,L -- Test bit 5 of L
    Z = (bool)!([state getL] & 0x00100000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB6D -- BIT 5,L -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb6EInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 5,(HL) -- Test bit 5 of (HL)
    Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00100000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB6E -- BIT 5,(HL) -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb6FInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool Z = false;

    // BIT 5,A -- Test bit 5 of A
    Z = (bool)!([state getA] & 0x00100000);
    [state setFlags:Z
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB6F -- BIT 5,A -- Z is now %i\n", [state getZFlag]);
};