#import "emulatorMain.h"


void (^execute0x90Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SUB B -- A <- A - B
    prev = [state getA];
    [state setA:([state getA]-[state getB])];
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getB] & 0xf) & 0xf)))
                  C:!((unsigned char)prev < (unsigned char)[state getB])];
    PRINTDBG("0x90 -- SUB B -- B is 0x%02x; A was 0x%02x; A is now 0x%02x\n",
             [state getB], prev, [state getA]);
};
void (^execute0x91Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SUB C -- A <- A - C
    prev = [state getA];
    [state setA:([state getA]-[state getC])];
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getC] & 0xf) & 0xf)))
                  C:!((unsigned char)prev < (unsigned char)[state getC])];
    PRINTDBG("0x91 -- SUB C -- C is 0x%02x; A was 0x%02x; A is now 0x%02x\n",
             [state getC], prev, [state getA]);
};
void (^execute0x92Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SUB D -- A <- A - D
    prev = [state getA];
    [state setA:([state getA]-[state getD])];
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getD] & 0xf) & 0xf)))
                  C:!((unsigned char)prev < (unsigned char)[state getD])];
    PRINTDBG("0x92 -- SUB D -- D is 0x%02x; A was 0x%02x; A is now 0x%02x\n",
             [state getD], prev, [state getA]);
};
void (^execute0x93Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SUB E -- A <- A - E
    prev = [state getA];
    [state setA:([state getA]-[state getE])];
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getE] & 0xf) & 0xf)))
                  C:!((unsigned char)prev < (unsigned char)[state getE])];
    PRINTDBG("0x93 -- SUB E -- E is 0x%02x; A was 0x%02x; A is now 0x%02x\n",
             [state getE], prev, [state getA]);
};
void (^execute0x94Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SUB H -- A <- A - H
    prev = [state getA];
    [state setA:([state getA]-[state getH])];
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getH] & 0xf) & 0xf)))
                  C:!((unsigned char)prev < (unsigned char)[state getH])];
    PRINTDBG("0x94 -- SUB H -- H is 0x%02x; A was 0x%02x; A is now 0x%02x\n",
             [state getH], prev, [state getA]);
};
void (^execute0x95Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SUB L -- A <- A - L
    prev = [state getA];
    [state setA:([state getA]-[state getL])];
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getL] & 0xf) & 0xf)))
                  C:!((unsigned char)prev < (unsigned char)[state getL])];
    PRINTDBG("0x95 -- SUB L -- L is 0x%02x; A was 0x%02x; A is now 0x%02x\n",
             [state getL], prev, [state getA]);
};
void (^execute0x96Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    int8_t d8 = 0;

    // SUB (HL) -- Subtract (HL) from A
    d8 = ram[(unsigned short)[state getHL_big]];
    prev = [state getA];
    [state setA:([state getA]-d8)];
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)(((d8 & 0xf) & 0xf)))
                  C:!((unsigned char)prev < (unsigned char)d8)];
    PRINTDBG("0x96 -- SUB (HL) -- HL is 0x%02x; (HL) is 0x%02x; A was 0x%02x; A is now 0x%02x\n",
             [state getHL_big], d8, prev, [state getA]);
};
void (^execute0x97Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SUB A -- A <- A - A
    prev = [state getA];
    [state setA:0];
    [state setFlags:[state getA] == 0
                  N:true
                  H:true
                  C:true];
    PRINTDBG("0x97 -- SUB A -- A is now 0x0\n");
};
void (^execute0x98Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SBC A,B -- Subtract B + carry flag from A, so A = 0 - C-flag
    prev = [state getA];
    if ([state getCFlag] == true)
    {
        [state setA:([state getA]-[state getB]-1)];
    }
    else
    {
        [state setA:([state getA]-[state getB])];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getB] & 0xf + \
                                                    ([state getCFlag] ? 1 : 0)) & 0xf)))
                  C:!((unsigned char)(prev) < (unsigned char)([state getB] + \
                                                              ([state getCFlag] ? 1 : 0)))];
    PRINTDBG("0x98 -- SBC A,B -- A was 0x%02x; A is now 0x%02x\n",
             prev, [state getA]);
};
void (^execute0x99Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SBC A,C -- Subtract C + carry flag from A, so A = 0 - C-flag
    prev = [state getA];
    if ([state getCFlag] == true)
    {
        [state setA:([state getA]-[state getC]-1)];
    }
    else
    {
        [state setA:([state getA]-[state getC])];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getC] & 0xf + \
                                                    ([state getCFlag] ? 1 : 0)) & 0xf)))
                  C:!((unsigned char)(prev) < (unsigned char)([state getC] + \
                                                              ([state getCFlag] ? 1 : 0)))];
    PRINTDBG("0x99 -- SBC A,C -- A was 0x%02x; A is now 0x%02x\n",
             prev, [state getA]);
};
void (^execute0x9AInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SBC A,D -- Subtract D + carry flag from A, so A = 0 - C-flag
    prev = [state getA];
    if ([state getCFlag] == true)
    {
        [state setA:([state getA]-[state getD]-1)];
    }
    else
    {
        [state setA:([state getA]-[state getD])];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getD] & 0xf + \
                                                    ([state getCFlag] ? 1 : 0)) & 0xf)))
                  C:!((unsigned char)(prev) < (unsigned char)([state getD] + \
                                                              ([state getCFlag] ? 1 : 0)))];
    PRINTDBG("0x9A -- SBC A,D -- A was 0x%02x; A is now 0x%02x\n",
             prev, [state getA]);
};
void (^execute0x9BInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SBC A,E -- Subtract E + carry flag from A, so A = 0 - C-flag
    prev = [state getA];
    if ([state getCFlag] == true)
    {
        [state setA:([state getA]-[state getE]-1)];
    }
    else
    {
        [state setA:([state getA]-[state getE])];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getE] & 0xf + \
                                                    ([state getCFlag] ? 1 : 0)) & 0xf)))
                  C:!((unsigned char)(prev) < (unsigned char)([state getE] + \
                                                              ([state getCFlag] ? 1 : 0)))];
    PRINTDBG("0x9B -- SBC A,E -- A was 0x%02x; A is now 0x%02x\n",
             prev, [state getA]);
};
void (^execute0x9CInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SBC A,H -- Subtract H + carry flag from A, so A = 0 - C-flag
    prev = [state getA];
    if ([state getCFlag] == true)
    {
        [state setA:([state getA]-[state getH]-1)];
    }
    else
    {
        [state setA:([state getA]-[state getH])];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getH] & 0xf + \
                                                    ([state getCFlag] ? 1 : 0)) & 0xf)))
                  C:!((unsigned char)(prev) < (unsigned char)([state getH] + \
                                                              ([state getCFlag] ? 1 : 0)))];
    PRINTDBG("0x9C -- SBC A,H -- A was 0x%02x; A is now 0x%02x\n",
             prev, [state getA]);
};
void (^execute0x9DInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SBC A,L -- Subtract L + carry flag from A, so A = 0 - C-flag
    prev = [state getA];
    if ([state getCFlag] == true)
    {
        [state setA:([state getA]-[state getL]-1)];
    }
    else
    {
        [state setA:([state getA]-[state getL])];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)((([state getL] & 0xf + \
                                                    ([state getCFlag] ? 1 : 0)) & 0xf)))
                  C:!((unsigned char)(prev) < (unsigned char)([state getL] + \
                                                              ([state getCFlag] ? 1 : 0)))];
    PRINTDBG("0x9D -- SBC A,L -- A was 0x%02x; A is now 0x%02x\n",
             prev, [state getA]);
};
void (^execute0x9EInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    int8_t d8 = 0;

    // SBC A,(HL) -- Subtract (HL) + carry flag from A
    prev = [state getA];
    d8 = ram[[state getHL_big]];
    if ([state getCFlag] == true)
    {
        [state setA:([state getA]-d8-1)];
    }
    else
    {
        [state setA:([state getA]-d8)];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:!((char)(prev & 0xf) < (char)(((d8 & 0xf + \
                                                    ([state getCFlag] ? 1 : 0)) & 0xf)))
                  C:!((unsigned char)(prev) < (unsigned char)(d8 + \
                                                              ([state getCFlag] ? 1 : 0)))];
    PRINTDBG("0x9E -- SBC A,(HL) -- A was 0x%02x; A is now 0x%02x\n",
             prev, [state getA]);
};
void (^execute0x9FInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SBC A,A -- Subtract A + carry flag from A, so A = 0 - C-flag
    prev = [state getA];
    if ([state getCFlag] == true)
    {
        [state setA:-1];
    }
    else
    {
        [state setA:0];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA] == 0
                  N:true
                  H:true
                  C:true];
    PRINTDBG("0x9F -- SBC A,A -- A was 0x%02x; A is now 0x%02x\n",
             prev, [state getA]);
};