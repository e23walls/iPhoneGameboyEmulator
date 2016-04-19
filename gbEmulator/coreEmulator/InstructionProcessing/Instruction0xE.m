#import "emulatorMain.h"

extern int16_t (^get16BitWordFromRAM)(short, char *);

void (^execute0xE0Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;
    int16_t d16 = 0;
    int8_t prev = 0;

    // LDH (a8),A -- Load A into (0xFF00 + a8)
#warning This is for I/O
    d8 = ram[[state getPC]];
    [state incrementPC];
    d16 = (unsigned short)0xff00 + (unsigned short)d8;
    prev = ram[(unsigned short)d16];
    ram[(unsigned short)d16] = [state getA];
    PRINTDBG("0xE0 -- LDH (a8),A -- 0xFF00+a8 = 0x%02x; (0xff00+a8) was 0x%02x and is now 0x%02x; A is 0x%02x\n",
             d16 & 0xffff, prev & 0xff, ram[(unsigned short)d16] & 0xff,
             [state getA] & 0xff);
};
void (^execute0xE1Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // POP HL - Pop two bytes from SP into HL, and increment SP twice
    [state setSP:([state getSP] + 2)];
    d16 = (((ram[[state getSP]]) & 0x00ff)) |
    (((ram[[state getSP]+1]) << 8) & 0xff00);
    [state setHL_big:d16];
    PRINTDBG("0xE1 -- POP HL -- HL = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n",
             [state getHL_big], [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xE2Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    int8_t prev = 0;

    // LD (C),A -- Load A into (0xFF00 + C)
#warning This is for I/O
    d16 = (unsigned short)0xff00 + (unsigned short)[state getC];
    prev = ram[(unsigned short)d16];
    ram[(unsigned short)d16] = [state getA];
    PRINTDBG("0xE2 -- LD (C),A -- 0xFF00+C = 0x%02x; (C) was 0x%02x and is now 0x%02x; A is 0x%02x\n",
             d16 & 0xffff, prev & 0xff, ram[(unsigned short)d16] & 0xff, \
             [state getA] & 0xff);
};
void (^execute0xE3Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // No instruction
    PRINTDBG("0xE3 -- invalid instruction\n");
};
void (^execute0xE4Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // No instruction
    PRINTDBG("0xE4 -- invalid instruction\n");
};
void (^execute0xE5Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // PUSH HL -- push HL onto SP, and decrement SP twice
    d16 = [state getHL_little];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    [state setSP:([state getSP] - 2)];
    PRINTDBG("0xE5 -- PUSH HL -- HL = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n",
             [state getHL_big], [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xE6Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;
    int8_t prev = 0;

    // AND d8 -- A <- A & d8
    prev = [state getA];
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state setA:([state getA] & d8)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:true
                  C:false];
    PRINTDBG("0xE6 -- AND d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n",
             prev & 0xff, [state getA], d8 & 0xff);
};
void (^execute0xE7Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // RST 20H -- push PC onto stack, and jump to address 0x00
    d16 = [state getPC] + 1;
    [state setSP:([state getSP] - 2)];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    [state setPC:0x20];
    *incrementPC =false;
    PRINTDBG("0xE7 -- RST 20H -- SP is now at 0x%02x; (SP) = 0x%02x\n", [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xE8Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;
    unsigned short prev_short = 0;
    bool H = false;
    bool C = false;

    // ADD SP,r8 -- Add 8-bit immediate value to SP
    prev_short = [state getSP];
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state addToSP:d8];
    C = (unsigned short)prev_short > (unsigned short)[state getSP];
    H = prev_short > [state getSP];
    [state setFlags:false
                  N:false
                  H:H
                  C:C];
    PRINTDBG("0xE8 -- ADD SP,r8 (r8 = %d) -- SP was 0x%02x; SP is now 0x%02x\n",
             (int)d8, prev_short, [state getSP]);
};
void (^execute0xE9Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // JP (HL) -- Jump to address in register HL
    d16 = [state getHL_big];
    [state setPC:d16];
    PRINTDBG("0xE9 -- JP (HL) -- HL = 0x%02x -- PC is now at 0x%02x\n",
             d16 & 0xffff, [state getPC]);
};
void (^execute0xEAInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    unsigned short prev_short = 0;

    // LD (a16),A -- Put A into (a16)
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
    [state doubleIncPC];
    prev_short = ram[(unsigned short)d16];
    ram[(unsigned short)d16] = [state getA];
    PRINTDBG("0xEA -- LD (a16),A -- A = 0x%02x; a16 = 0x%02x; [a16] was 0x%02x and is now 0x%02x\n",
             [state getA], (unsigned short)d16, \
             (unsigned short)prev_short, ram[(unsigned short)d16]);
};
void (^execute0xEBInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // No instruction
    PRINTDBG("0xEB -- invalid instruction\n");
};
void (^execute0xECInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // No instruction
    PRINTDBG("0xEC -- invalid instruction\n");
};
void (^execute0xEDInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // No instruction
    PRINTDBG("0xED -- invalid instruction\n");
};
void (^execute0xEEInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t d8 = 0;
    int8_t prev = 0;

    // XOR d8 -- A <- A ^ d8
    prev = [state getA];
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state setA:([state getA] ^ d8)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xEE -- XOR d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n",
             prev & 0xff, [state getA], d8 & 0xff);
};
void (^execute0xEFInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // RST 28H -- push PC onto stack, and jump to address 0x00
    d16 = [state getPC] + 1;
    [state setSP:([state getSP] - 2)];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    [state setPC:0x28];
    *incrementPC =false;
    PRINTDBG("0xEF -- RST 28H -- SP is now at 0x%02x; (SP) = 0x%02x\n", [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};