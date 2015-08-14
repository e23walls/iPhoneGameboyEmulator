#import "emulatorMain.h"


void (^execute0xA0Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // AND B -- A <- A & B
    prev = [state getA];
    [state setA:([state getA] & [state getB])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0xA0 -- AND B -- A was 0x%02x; A is now 0x%02x; B = 0x%02x\n",
             prev & 0xff, [state getA], [state getB] & 0xff);
};
void (^execute0xA1Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // AND C -- A <- A & C
    prev = [state getA];
    [state setA:([state getA] & [state getC])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0xA1 -- AND C -- A was 0x%02x; A is now 0x%02x; C = 0x%02x\n",
             prev & 0xff, [state getA], [state getC] & 0xff);
};
void (^execute0xA2Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // AND D -- A <- A & D
    prev = [state getA];
    [state setA:([state getA] & [state getD])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0xA2 -- AND D -- A was 0x%02x; A is now 0x%02x; D = 0x%02x\n",
             prev & 0xff, [state getA], [state getD] & 0xff);
};
void (^execute0xA3Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // AND E -- A <- A & E
    prev = [state getA];
    [state setA:([state getA] & [state getE])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0xA3 -- AND E -- A was 0x%02x; A is now 0x%02x; E = 0x%02x\n",
             prev & 0xff, [state getA], [state getE] & 0xff);
};
void (^execute0xA4Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // AND H -- A <- A & H
    prev = [state getA];
    [state setA:([state getA] & [state getH])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0xA4 -- AND H -- A was 0x%02x; A is now 0x%02x; H = 0x%02x\n",
             prev & 0xff, [state getA], [state getH] & 0xff);
};
void (^execute0xA5Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // AND L -- A <- A & L
    prev = [state getA];
    [state setA:([state getA] & [state getL])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0xA5 -- AND L -- A was 0x%02x; A is now 0x%02x; L = 0x%02x\n",
             prev & 0xff, [state getA], [state getL] & 0xff);
};
void (^execute0xA6Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    int8_t d8 = 0;

    // AND (HL) -- A <- A & (HL)
    d8 = ram[(unsigned short)[state getHL_big]];
    prev = [state getA];
    [state setA:([state getA] & d8)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0xA6 -- AND (HL) -- A was 0x%02x; A is now 0x%02x; HL = 0x%02x; (HL) = 0x%02x\n",
             prev & 0xff, [state getA], [state getHL_big] & 0xffff, d8 & 0xff);
};
void (^execute0xA7Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // AND A -- A <- A & A (so, only changes the flags)
    prev = [state getA];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0xA7 -- AND A -- A is 0x%02x\n", [state getA] & 0xff);
};
void (^execute0xA8Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // XOR B -- A <- A ^ B
    prev = [state getA];
    [state setA:([state getA] ^ [state getB])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xA8 -- XOR B -- A was 0x%02x; A is now 0x%02x; B = 0x%02x\n",
             prev & 0xff, [state getA], [state getB] & 0xff);
};
void (^execute0xA9Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // XOR C -- A <- A ^ C
    prev = [state getA];
    [state setA:([state getA] ^ [state getC])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xA9 -- XOR C -- A was 0x%02x; A is now 0x%02x; C = 0x%02x\n",
             prev & 0xff, [state getA], [state getC] & 0xff);
};
void (^execute0xAAInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // XOR D -- A <- A ^ D
    prev = [state getA];
    [state setA:([state getA] ^ [state getD])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xAA -- XOR D -- A was 0x%02x; A is now 0x%02x; D = 0x%02x\n",
             prev & 0xff, [state getA], [state getD] & 0xff);
};
void (^execute0xABInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // XOR E -- A <- A ^ E
    prev = [state getA];
    [state setA:([state getA] ^ [state getE])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xAB -- XOR E -- A was 0x%02x; A is now 0x%02x; E = 0x%02x\n",
             prev & 0xff, [state getA], [state getE] & 0xff);
};
void (^execute0xACInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // XOR H -- A <- A ^ H
    prev = [state getA];
    [state setA:([state getA] ^ [state getH])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xAC -- XOR H -- A was 0x%02x; A is now 0x%02x; H = 0x%02x\n",
             prev & 0xff, [state getA], [state getH] & 0xff);
};
void (^execute0xADInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // XOR L -- A <- A ^ L
    prev = [state getA];
    [state setA:([state getA] ^ [state getL])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xAD -- XOR L -- A was 0x%02x; A is now 0x%02x; L = 0x%02x\n",
             prev & 0xff, [state getA], [state getL] & 0xff);
};
void (^execute0xAEInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    int8_t d8 = 0;

    // XOR (HL) -- A <- A ^ (HL)
    d8 = ram[(unsigned short)[state getHL_big]];
    prev = [state getA];
    [state setA:([state getA] ^ d8)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xAE -- XOR (HL) -- A was 0x%02x; A is now 0x%02x; HL = 0x%02x; (HL) = 0x%02x\n",
             prev & 0xff, [state getA], [state getHL_big] & 0xffff, d8 & 0xff);
};
void (^execute0xAFInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // XOR A -- A <- A ^ A
    prev = [state getA];
    [state setA:0];
    [state setFlags:([state getA] == 0)
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xAF -- XOR A -- A is now 0x00\n");
};