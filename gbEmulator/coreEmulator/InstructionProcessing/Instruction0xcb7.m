#import "emulatorMain.h"

void (^execute0xcb70Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB70 -- BIT 6,B -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb71Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB71 -- BIT 6,C -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb72Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB72 -- BIT 6,D -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb73Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB73 -- BIT 6,E -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb74Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB74 -- BIT 6,H -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb75Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB75 -- BIT 6,L -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb76Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB76 -- BIT 6,(HL) -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb77Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB77 -- BIT 6,A -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb78Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB78 -- BIT 7,B -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb79Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB79 -- BIT 7,C -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb7AInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB7A -- BIT 7,D -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb7BInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB7B -- BIT 7,E -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb7CInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // BIT 7,H -- test 7th bit of H register
    [state setFlags:(bool)([state getH] & (int8_t)0b10000000)
                  N:false
                  H:true
                  C:[state getCFlag]];
    PRINTDBG("0xCB7C -- BIT 7,H -- H is 0x%02x -- Z is now %i\n",
             [state getH], [state getZFlag]);
};
void (^execute0xcb7DInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB7D -- BIT 7,L -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb7EInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB7E -- BIT 7,(HL) -- Z is now %i\n", [state getZFlag]);
};
void (^execute0xcb7FInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
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
    PRINTDBG("0xCB7F -- BIT 7,A -- Z is now %i\n", [state getZFlag]);
};