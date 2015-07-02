#import "emulatorMain.h"


void (^execute0xA0Instruction)(romState *,
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

    // AND B -- A <- A & B
    prev = [state getA];
    [state setA:([state getA] & [state getB])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0x%02x -- AND B -- A was 0x%02x; A is now 0x%02x; B = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getB] & 0xff);
};
void (^execute0xA1Instruction)(romState *,
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

    // AND C -- A <- A & C
    prev = [state getA];
    [state setA:([state getA] & [state getC])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0x%02x -- AND C -- A was 0x%02x; A is now 0x%02x; C = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getC] & 0xff);
};
void (^execute0xA2Instruction)(romState *,
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

    // AND D -- A <- A & D
    prev = [state getA];
    [state setA:([state getA] & [state getD])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0x%02x -- AND D -- A was 0x%02x; A is now 0x%02x; D = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getD] & 0xff);
};
void (^execute0xA3Instruction)(romState *,
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

    // AND E -- A <- A & E
    prev = [state getA];
    [state setA:([state getA] & [state getE])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0x%02x -- AND E -- A was 0x%02x; A is now 0x%02x; E = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getE] & 0xff);
};
void (^execute0xA4Instruction)(romState *,
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

    // AND H -- A <- A & H
    prev = [state getA];
    [state setA:([state getA] & [state getH])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0x%02x -- AND H -- A was 0x%02x; A is now 0x%02x; H = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getH] & 0xff);
};
void (^execute0xA5Instruction)(romState *,
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

    // AND L -- A <- A & L
    prev = [state getA];
    [state setA:([state getA] & [state getL])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0x%02x -- AND L -- A was 0x%02x; A is now 0x%02x; L = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getL] & 0xff);
};
void (^execute0xA6Instruction)(romState *,
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

    // AND (HL) -- A <- A & (HL)
    d8 = ram[(unsigned short)[state getHL_big]];
    prev = [state getA];
    [state setA:([state getA] & d8)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0x%02x -- AND (HL) -- A was 0x%02x; A is now 0x%02x; HL = 0x%02x; (HL) = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getHL_big] & 0xffff, d8 & 0xff);
};
void (^execute0xA7Instruction)(romState *,
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

    // AND A -- A <- A & A (so, only changes the flags)
    prev = [state getA];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0x%02x -- AND A -- A is 0x%02x\n", currentInstruction & 0xff, [state getA] & 0xff);
};
void (^execute0xA8Instruction)(romState *,
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

    // XOR B -- A <- A ^ B
    prev = [state getA];
    [state setA:([state getA] ^ [state getB])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0x%02x -- XOR B -- A was 0x%02x; A is now 0x%02x; B = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getB] & 0xff);
};
void (^execute0xA9Instruction)(romState *,
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

    // XOR C -- A <- A ^ C
    prev = [state getA];
    [state setA:([state getA] ^ [state getC])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0x%02x -- XOR C -- A was 0x%02x; A is now 0x%02x; C = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getC] & 0xff);
};
void (^execute0xAAInstruction)(romState *,
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

    // XOR D -- A <- A ^ D
    prev = [state getA];
    [state setA:([state getA] ^ [state getD])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0x%02x -- XOR D -- A was 0x%02x; A is now 0x%02x; D = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getD] & 0xff);
};
void (^execute0xABInstruction)(romState *,
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

    // XOR E -- A <- A ^ E
    prev = [state getA];
    [state setA:([state getA] ^ [state getE])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0x%02x -- XOR E -- A was 0x%02x; A is now 0x%02x; E = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getE] & 0xff);
};
void (^execute0xACInstruction)(romState *,
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

    // XOR H -- A <- A ^ H
    prev = [state getA];
    [state setA:([state getA] ^ [state getH])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0x%02x -- XOR H -- A was 0x%02x; A is now 0x%02x; H = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getH] & 0xff);
};
void (^execute0xADInstruction)(romState *,
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

    // XOR L -- A <- A ^ L
    prev = [state getA];
    [state setA:([state getA] ^ [state getL])];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0x%02x -- XOR L -- A was 0x%02x; A is now 0x%02x; L = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getL] & 0xff);
};
void (^execute0xAEInstruction)(romState *,
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

    // XOR (HL) -- A <- A ^ (HL)
    d8 = ram[(unsigned short)[state getHL_big]];
    prev = [state getA];
    [state setA:([state getA] ^ d8)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0x%02x -- XOR (HL) -- A was 0x%02x; A is now 0x%02x; HL = 0x%02x; (HL) = 0x%02x\n", currentInstruction & 0xff,
             prev & 0xff, [state getA], [state getHL_big] & 0xffff, d8 & 0xff);
};
void (^execute0xAFInstruction)(romState *,
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

    // XOR A -- A <- A ^ A
    prev = [state getA];
    [state setA:0];
    [state setFlags:([state getA] == 0)
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0x%02x -- XOR A -- A is now 0x00\n", currentInstruction & 0xff);
};