#import "emulatorMain.h"


void (^execute0xB0Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // OR B -- A <- A | B
    prev = [state getA];
    [state setA:([state getA] | [state getB])];
    [state setFlags:([state getA] == 0)
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xB0 -- OR B -- A was 0x%02x; A is now 0x%02x\n",
             prev, [state getA]);
};
void (^execute0xB1Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // OR C -- A <- A | C
    prev = [state getA];
    [state setA:([state getA] | [state getC])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xB1 -- OR C -- A was 0x%02x; A is now 0x%02x; C = 0x%02x\n",
             prev & 0xff, [state getA], [state getC] & 0xff);
};
void (^execute0xB2Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // OR D -- A <- A | D
    prev = [state getA];
    [state setA:([state getA] | [state getD])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xB2 -- OR D -- A was 0x%02x; A is now 0x%02x; D = 0x%02x\n",
             prev & 0xff, [state getA], [state getD] & 0xff);
};
void (^execute0xB3Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // OR E -- A <- A | E
    prev = [state getA];
    [state setA:([state getA] | [state getE])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xB3 -- OR E -- A was 0x%02x; A is now 0x%02x; E = 0x%02x\n", prev & 0xff, [state getA], [state getE] & 0xff);
};
void (^execute0xB4Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // OR H -- A <- A | H
    prev = [state getA];
    [state setA:([state getA] | [state getH])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xB4 -- OR H -- A was 0x%02x; A is now 0x%02x; H = 0x%02x\n", prev & 0xff, [state getA], [state getH] & 0xff);
};
void (^execute0xB5Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // OR L -- A <- A | L
    prev = [state getA];
    [state setA:([state getA] | [state getL])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xB5 -- OR L -- A was 0x%02x; A is now 0x%02x; L = 0x%02x\n", prev & 0xff, [state getA], [state getL] & 0xff);
};
void (^execute0xB6Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    int8_t d8 = 0;

    // OR (HL) -- A <- A | (HL)
    d8 = ram[(unsigned short)[state getHL_big]];
    prev = [state getA];
    [state setA:([state getA] | d8)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xB6 -- OR (HL) -- A was 0x%02x; A is now 0x%02x; HL = 0x%02x; (HL) = 0x%02x\n",
             prev & 0xff, [state getA], [state getHL_big] & 0xffff, d8 & 0xff);
};
void (^execute0xB7Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // OR A -- A <- A | A
    [state setFlags:([state getA] == 0)
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xB7 -- OR A -- A is 0x%02x\n", [state getA]);
};
void (^execute0xB8Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // CP B -- Compare A with B and set flags accordingly
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA]-[state getB] == 0
                  N:true
                  H:!((char)([state getA] & 0xf) < (char)((([state getB] & 0xf) & 0xf)))
                  C:!((unsigned char)[state getA] < (unsigned char)[state getB])];
    PRINTDBG("0xB8 -- CP B -- B is 0x%02x; A is 0x%02x\n",
             [state getB], [state getA]);
};
void (^execute0xB9Instruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // CP C -- Compare A with C and set flags accordingly
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA]-[state getC] == 0
                  N:true
                  H:!((char)([state getA] & 0xf) < (char)((([state getC] & 0xf) & 0xf)))
                  C:!((unsigned char)[state getA] < (unsigned char)[state getC])];
    PRINTDBG("0xB9 -- CP C -- C is 0x%02x; A is 0x%02x\n",
             [state getC], [state getA]);
};
void (^execute0xBAInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // CP D -- Compare A with D and set flags accordingly
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA]-[state getD] == 0
                  N:true
                  H:!((char)([state getA] & 0xf) < (char)((([state getD] & 0xf) & 0xf)))
                  C:!((unsigned char)[state getA] < (unsigned char)[state getD])];
    PRINTDBG("0xBA -- CP D -- D is 0x%02x; A is 0x%02x\n",
             [state getD], [state getA]);
};
void (^execute0xBBInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // CP E -- Compare A with E and set flags accordingly
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA]-[state getE] == 0
                  N:true
                  H:!((char)([state getA] & 0xf) < (char)((([state getE] & 0xf) & 0xf)))
                  C:!((unsigned char)[state getA] < (unsigned char)[state getE])];
    PRINTDBG("0xBB -- CP E -- E is 0x%02x; A is 0x%02x\n",
             [state getE], [state getA]);
};
void (^execute0xBCInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // CP H -- Compare A with H and set flags accordingly
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA]-[state getH] == 0
                  N:true
                  H:!((char)([state getA] & 0xf) < (char)((([state getH] & 0xf) & 0xf)))
                  C:!((unsigned char)[state getA] < (unsigned char)[state getH])];
    PRINTDBG("0xBC -- CP H -- H is 0x%02x; A is 0x%02x\n",
             [state getH], [state getA]);
};
void (^execute0xBDInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // CP L -- Compare A with L and set flags accordingly
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA]-[state getL] == 0
                  N:true
                  H:!((char)([state getA] & 0xf) < (char)((([state getL] & 0xf) & 0xf)))
                  C:!((unsigned char)[state getA] < (unsigned char)[state getL])];
    PRINTDBG("0xBD -- CP L -- L is 0x%02x; A is 0x%02x\n",
             [state getL], [state getA]);
};
void (^execute0xBEInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;

    // CP (HL) -- Compare A with (HL) and set flags accordingly
    d8 = ram[(unsigned short)[state getHL_big]];
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:[state getA]-d8 == 0
                  N:true
                  H:!((char)([state getA] & 0xf) < (char)(((d8 & 0xf) & 0xf)))
                  C:!((unsigned char)[state getA] < (unsigned char)d8)];
    PRINTDBG("0xBE -- CP (HL) -- HL is 0x%02x; (HL) is 0x%02x; A is 0x%02x\n",
             [state getHL_big], d8, [state getA]);
};
void (^execute0xBFInstruction)(romState *,
                              char *,
                              bool *,
                              int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // CP A -- Compare A with A and set flags accordingly
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if no borrow from bit 4.
     C - Set if no borrow.
     */
    [state setFlags:true
                  N:true
                  H:true
                  C:true];
    PRINTDBG("0xBF -- CP A -- A is 0x%02x\n",
             [state getA]);
};