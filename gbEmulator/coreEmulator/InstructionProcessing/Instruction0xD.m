#import "emulatorMain.h"

extern void (^enableInterrupts)(bool, char *);
extern int16_t (^get16BitWordFromRAM)(short, char *);

void (^execute0xD0Instruction)(RomState *,
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

    // RET NC -- If !C, return from subroutine
    prev_short = [state getSP];
    if ([state getCFlag] == false)
    {
        [state setSP:([state getSP]+2)];
        d16 = (((ram[[state getSP]]) & 0x00ff)) |
        (((ram[[state getSP]+1]) << 8) & 0xff00);
        [state setPC:(unsigned short)d16];
    }
    PRINTDBG("0xD0 -- RET NC -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n",
             prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
};
void (^execute0xD1Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // POP DE - Pop two bytes from SP into DE, and increment SP twice
    [state setSP:([state getSP] + 2)];
    d16 = (((ram[[state getSP]]) & 0x00ff)) |
    (((ram[[state getSP]+1]) << 8) & 0xff00);
    [state setDE_big:d16];
    PRINTDBG("0xD1 -- POP DE -- DE = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n",
             [state getDE_big], [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xD2Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // JP NC,a16 -- If !C, jump to address a16
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
    [state doubleIncPC];
    if ([state getCFlag] == false)
    {
        [state setPC:d16];
        *incrementPC =false;
    }
    PRINTDBG("0xD2 -- JP NC,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n",
             d16 & 0xffff, [state getPC]);
};
void (^execute0xD3Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // no instruction
    PRINTDBG("0xD3 -- invalid instruction\n");
};
void (^execute0xD4Instruction)(RomState *,
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

    // CALL NC,a16 -- If !C, call subroutine at address a16
    prev_short = [state getSP];
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
    [state doubleIncPC];
    if ([state getCFlag] == false)
    {
        ram[[state getSP]] = (([state getPC]) & 0xff00) >> 8;
        ram[[state getSP]+1] = ([state getPC]) & 0x00ff;
        [state setSP:([state getSP] - 2)];
        [state setPC:d16];
    }
    PRINTDBG("0xD4 -- CALL NC,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n",
             d16 & 0xffff, prev_short, [state getSP], \
             [state getPC]);
};
void (^execute0xD5Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // PUSH DE -- push DE onto SP, and decrement SP twice
    d16 = [state getDE_little];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    [state setSP:([state getSP] - 2)];
    PRINTDBG("0xD5 -- PUSH DE -- DE = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n",
             [state getDE_big], [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xD6Instruction)(RomState *,
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

    // SUB d8 -- A <- A - d8
    d8 = ram[[state getPC]];
    [state incrementPC];
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
    PRINTDBG("0xD6 -- SUB d8 -- d8 is 0x%02x; A was 0x%02x; A is now 0x%02x\n",
             d8 & 0xff, prev, [state getA]);
};
void (^execute0xD7Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // RST 10H -- push PC onto stack, and jump to address 0x00
    d16 = [state getPC] + 1;
    [state setSP:([state getSP] - 2)];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    [state setPC:0x10];
    *incrementPC =false;
    PRINTDBG("0xD7 -- RST 10H -- SP is now at 0x%02x; (SP) = 0x%02x\n", [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xD8Instruction)(RomState *,
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

    // RET C -- If C, return from subroutine
    prev_short = [state getSP];
    if ([state getCFlag] == true)
    {
        [state setSP:([state getSP]+2)];
        d16 = (((ram[[state getSP]]) & 0x00ff)) |
        (((ram[[state getSP]+1]) << 8) & 0xff00);
        [state setPC:(unsigned short)d16];
    }
    PRINTDBG("0xD8 -- RET C -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n",
             prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
};
void (^execute0xD9Instruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // RETI -- RET + enable interrupts
    [state setSP:([state getSP]+2)];
    d16 = (((ram[[state getSP]]) & 0x00ff)) |
    (((ram[[state getSP]+1]) << 8) & 0xff00);
    [state setPC:(unsigned short)d16];
    enableInterrupts(true, ram);
    PRINTDBG("0xD9 -- RETI -- PC is now 0x%02x\n",
             [state getPC]);
};
void (^execute0xDAInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // JP C,a16 -- If C, jump to address a16
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
    [state doubleIncPC];
    if ([state getCFlag] == true)
    {
        [state setPC:d16];
    }
    PRINTDBG("0xDA -- JP C,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n",
             d16 & 0xffff, [state getPC]);
};
void (^execute0xDBInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // no instruction
    PRINTDBG("0xDB -- invalid instruction\n");
};
void (^execute0xDCInstruction)(RomState *,
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

    // CALL C,a16 -- If C, call subroutine at address a16
    prev_short = [state getSP];
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
    [state doubleIncPC];
    if ([state getCFlag] == true)
    {
        ram[[state getSP]] = (int8_t)(([state getPC]) & 0xff00) >> 8;
        ram[[state getSP]+1] = (int8_t)(([state getPC]) & 0x00ff);
        [state setSP:([state getSP] - 2)];
        [state setPC:d16];
    }
    PRINTDBG("0xDC -- CALL C,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n",
             d16 & 0xffff, prev_short, [state getSP], \
             [state getPC]);
};
void (^execute0xDDInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // no instruction
    PRINTDBG("0xDD -- invalid instruction\n");
};
void (^execute0xDEInstruction)(RomState *,
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

    // SBC A,d8 -- Subtract d8 + carry flag from A, so A = A - (d8 + C-flag)
    prev = [state getA];
    d8 = ram[[state getPC]];
    [state incrementPC];
    if ([state getCFlag])
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
    PRINTDBG("0xDE -- SBC A,d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n",
             prev, [state getA], d8 & 0xff);

};
void (^execute0xDFInstruction)(RomState *,
                              char *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // RST 18H -- push PC onto stack, and jump to address 0x00
    d16 = [state getPC] + 1;
    [state setSP:([state getSP] - 2)];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    [state setPC:0x18];
    *incrementPC =false;
    PRINTDBG("0xDF -- RST 18H -- SP is now at 0x%02x; (SP) = 0x%02x\n", [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};