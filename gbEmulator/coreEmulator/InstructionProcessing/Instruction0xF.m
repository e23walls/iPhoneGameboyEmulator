#import "emulatorMain.h"


void (^execute0xF0Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    int8_t d8 = 0;
    int8_t prev = 0;

    // LDH A,(a8) -- Put (0xFF00+a8) into A
#warning This is for I/O
    d8 = ram[[state getPC]];
    [state incrementPC];
    d16 = (unsigned short)0xff00 + (unsigned short)d8;
    prev = [state getA];
    [state setA:ram[(unsigned short)d16]];
    PRINTDBG("0xF0 -- LDH A,(a8) -- 0xFF00+a8 = 0x%02x; A was 0x%02x and is now 0x%02x; (0xff00+a8) is 0x%02x\n",
             d16 & 0xffff, prev & 0xff,
             [state getA] & 0xff,
             ram[(unsigned short)d16] & 0xff);
};
void (^execute0xF1Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // POP AF -- Pop two bytes from SP into AF, and increment SP twice
    [state setA:ram[(([state getSP] & 0xff00) >> 8)]];
    // We don't want to change F
    [state setSP:([state getSP] + 2)];
    PRINTDBG("0xF1 -- POP AF -- AF = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n",
             [state getAF_big], [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xF2Instruction)(RomState *,
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

    // LD A,(C) -- Put value (0xff00+C) into A
#warning This is for I/O
    d16 = (unsigned short)0xff00 + (unsigned short)[state getC];
    prev = [state getA];
    [state setA:ram[(unsigned short)d16]];
    PRINTDBG("0xF2 -- LD A,(C) -- 0xFF00+C = 0x%02x; A was 0x%02x and is now 0x%02x; (0xff00+C) is 0x%02x\n",
             d16 & 0xffff, prev & 0xff, [state getA] & 0xff,
             ram[(unsigned short)d16] & 0xff);
};
void (^execute0xF3Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // DI -- disable interrupts
    *interruptsEnabled = -1;
    PRINTDBG("0xF3 -- DI -- disabling interrupts after the next instruction\n");
};
void (^execute0xF4Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // no instruction
    PRINTDBG("0xF4 -- invalid instruction\n");
};
void (^execute0xF5Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // PUSH AF -- push AF onto SP, and decrement SP twice
    d16 = [state getAF_little];
    [state setSP:([state getSP] - 2)];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    PRINTDBG("0xF5 -- PUSH AF -- AF = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n",
             [state getAF_big], [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xF6Instruction)(RomState *,
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

    // OR d8 -- A <- A | d8
    prev = [state getA];
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state setA:([state getA] | d8)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xF6 -- OR d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n",
             prev & 0xff, [state getA], d8 & 0xff);
};
void (^execute0xF7Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // RST 30H -- push PC onto stack, and jump to address 0x00
    d16 = [state getPC] + 1;
    [state setSP:([state getSP] - 2)];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    [state setPC:0x30];
    *incrementPC =false;
    PRINTDBG("0xF7 -- RST 30H -- SP is now at 0x%02x; (SP) = 0x%02x\n", [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xF8Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    short prev_short = 0;
    int8_t d8 = 0;

    // LD HL,SP+r8 -- Put (SP+r8) into HL
    d8 = ram[[state getPC]];
    [state incrementPC];
    prev_short = [state getHL_big];
    d16 = (unsigned short)[state getSP] + (short)d8;
    [state setHL_big:ram[(unsigned short)d16]];
    PRINTDBG("0xF8 -- LD HL,SP+r8 -- HL was 0x%02x; HL is now 0x%02x; SP=0x%02x; d8=0x%02x, (SP+d8)=0x%02x\n",
             prev_short & 0xffff, [state getHL_big] & 0xffff,
             [state getSP] & 0xffff, d8 & 0xff, ram[(unsigned short)d16]);
};
void (^execute0xF9Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    short prev_short = 0;

    // LD SP,HL -- Load LH into SP
    prev_short = [state getSP];
    [state setSP:[state getHL_big]];
    PRINTDBG("0xF9 -- LD SP,HL -- SP was 0x%02x, and is now 0x%02x\n",
             prev_short, [state getSP]);
};
void (^execute0xFAInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    int8_t d8 = 0;
    int8_t prev = 0;

    // LD A,(a16) -- Load (a16) into A
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
    d8 = ram[(unsigned short)d16];
    [state doubleIncPC];
    prev = [state getA];
    [state setA:d8];
    PRINTDBG("0xFA -- LD A,(a16) -- A was 0x%02x, and is now 0x%02x; a16 = 0%02x\n",
             prev & 0xff, [state getA] & 0xff, d16 & 0xffff);
};
void (^execute0xFBInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // EI -- Enable interrupts after next instruction
    *interruptsEnabled = 1;
    PRINTDBG("0xFB -- EI -- enabling interrupts after next instruction\n");
};
void (^execute0xFCInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // no instruction
    PRINTDBG("0xFC -- invalid instruction\n");
};
void (^execute0xFDInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // no instruction
    PRINTDBG("0xFD -- invalid instruction\n");
};
void (^execute0xFEInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    int8_t d8 = 0;

    // CP d8 -- Compare A with 8-bit data
    d8 = ram[[state getPC]];
    [state incrementPC];
    d16 = [state getA] - d8;
    [state setFlags:d16 == 0
                  N:true
                  H:!((char)([state getA] & 0xf) < \
                      (char)(((d8 & 0xf + ([state getCFlag] ? 1 : 0)) & 0xf)))
                  C:!((char)([state getA]) < \
                      (char)(((d8 + ([state getCFlag] ? 1 : 0)))))];
    PRINTDBG("0xFE -- CP d8 -- A = 0x%02x, d8 = 0x%02x; C-flag = %i\n",
             [state getA] & 0xff, d8 & 0xff, [state getCFlag] ? 1 : 0);
};
void (^execute0xFFInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // RST 38H -- push PC onto stack, and jump to address 0x00
    d16 = [state getPC]; // This is a 1-byte instruction
    [state setSP:([state getSP] - 2)];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    [state setPC:0x38];
    *incrementPC =false;
    PRINTDBG("0xFF -- RST 38H -- SP is now at 0x%02x; (SP) = 0x%02x\n", [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};