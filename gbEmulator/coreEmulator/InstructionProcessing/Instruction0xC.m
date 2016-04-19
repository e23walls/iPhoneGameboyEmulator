#import "emulatorMain.h"

extern void (^enableInterrupts)(bool, int8_t *);
extern void (^executeGivenInstruction)(RomState *, int8_t, int8_t *, bool *, int8_t *, bool);
extern int16_t (^get16BitWordFromRAM)(short, int8_t *);

void (^execute0xC0Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    unsigned short prev_short = 0;

    // RET NZ -- If !Z, return from subroutine
    prev_short = [state getSP];
    if ([state getZFlag] == false)
    {
        [state setSP:([state getSP]+2)];
        d16 = (((ram[[state getSP]]) & 0x00ff)) |
        (((ram[[state getSP]+1]) << 8) & 0xff00);
        [state setPC:(unsigned short)d16];
    }
    PRINTDBG("0xC0 -- RET NZ -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n",
             prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
};
void (^execute0xC1Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // POP BC -- Pop two bytes from SP into BC, and increment SP twice
    [state setSP:([state getSP] + 2)];
    d16 = (((ram[[state getSP]]) & 0x00ff)) |
    (((ram[[state getSP]+1]) << 8) & 0xff00);
    [state setBC_big:d16];
    PRINTDBG("0xC1 -- POP BC -- BC = 0x%02x -- SP is now at 0x%02x; popped off 0x%02x; (SP) = 0x%02x\n",
             [state getBC_big], [state getSP], d16,
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xC2Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // JP NZ,a16 -- If !Z, jump to address a16
    // This d16 fetch is correct, thanks to unit testing
    if ([state getZFlag] == false)
    {
        d16 = get16BitWordFromRAM([state getPC], ram);
        [state setPC:d16];
    }
    PRINTDBG("0xC2 -- JP NZ,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n",
             d16 & 0xffff, [state getPC]);
};
void (^execute0xC3Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // JP a16 -- Jump to address a16
    d16 = get16BitWordFromRAM([state getPC], ram);
    [state setPC:d16];
    PRINTDBG("0xC3 -- JP a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n",
             d16 & 0xffff, [state getPC]);
};
void (^execute0xC4Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    unsigned short prev_short = 0;

    // CALL NZ,a16 -- If !Z, push PC onto stack, and jump to a16
    prev_short = [state getSP];
    d16 = get16BitWordFromRAM([state getPC], ram);
    [state incrementPC];
    if ([state getZFlag] == false)
    {
        ram[[state getSP]] = (int8_t)(([state getPC]) & 0xff00) >> 8;
        ram[[state getSP]+1] = (int8_t)(([state getPC]) & 0x00ff);
        [state setSP:([state getSP] - 2)];
        [state setPC:d16];
    }
    PRINTDBG("0xC4 -- CALL NZ,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x; (SP) = 0x%02x\n",
             d16 & 0xffff, prev_short, [state getSP],
             [state getPC],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xC5Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // PUSH BC -- push BC onto SP, and decrement SP twice
    d16 = [state getBC_big];
    ram[[state getSP]+1] = (d16 & 0xff00) >> 8;
    ram[[state getSP]] = d16 & 0x00ff;
    [state setSP:([state getSP] - 2)];
    PRINTDBG("0xC5 -- PUSH BC -- BC = 0x%02x -- SP is now at 0x%02x; pushed 0x%02x; (SP) = 0x%02x\n",
             [state getBC_big] & 0xffff, [state getSP] & 0xffff, d16 & 0xffff,
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xC6Instruction)(RomState *,
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

    // ADD A,d8 -- A <- A + d8
    prev = [state getA];
    d8 = ram[[state getPC]];
    [state incrementPC];
    [state setA:([state getA] + d8)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:prev > [state getA]
                  C:((unsigned char)prev > (unsigned char)[state getA])];
    PRINTDBG("0xC6 -- ADD d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n",
             prev & 0xff, [state getA], d8 & 0xff);
};
void (^execute0xC7Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // RST 00H -- push PC onto stack, and jump to address 0x00
    d16 = [state getPC];
    [state setSP:([state getSP] - 2)];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    [state setPC:0x00];
    *incrementPC =false;
    PRINTDBG("0xC7 -- RST 00H -- SP is now at 0x%02x; (SP) = 0x%02x\n", [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xC8Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    unsigned short prev_short = 0;

    // RET Z -- If Z, return from subroutine
    prev_short = [state getSP];
    if ([state getZFlag] == true)
    {
        [state setSP:([state getSP]+2)];
        d16 = (((ram[[state getSP]]) & 0x00ff)) |
        (((ram[[state getSP]+1]) << 8) & 0xff00);
        [state setPC:(unsigned short)d16];
    }
    PRINTDBG("0xC8 -- RET Z -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", \
             prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
};
void (^execute0xC9Instruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // RET -- return from subroutine; pop two bytes from SP and go to that address
    [state setSP:([state getSP]+2)];
    d16 = (((ram[[state getSP]]) & 0x00ff)) |
    (((ram[[state getSP]+1]) << 8) & 0xff00);
    [state setPC:(unsigned short)d16];
    PRINTDBG("0xC9 -- RET -- PC is now 0x%02x; (SP) = 0x%02x\n",
             [state getPC],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xCAInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // JP Z,a16 -- If Z, jump to address a16
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
    [state doubleIncPC];
    if ([state getZFlag] == true)
    {
        [state setPC:d16];
        *incrementPC =false;
    }
    PRINTDBG("0xCA -- JP Z,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n",
             d16 & 0xffff, [state getPC]);
};
void (^execute0xCBInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    // Instruction with 0xCB prefix
    PRINTDBG("CB instruction...\n");
    int8_t currentInstruction = (0xcb * 0x100) | ram[[state getPC]];
    [state incrementPC];
    executeGivenInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled, true);
};
void (^execute0xCCInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    unsigned short prev_short = 0;

    // CALL Z,a16 -- If Z, call subroutine at address a16
    prev_short = [state getSP];
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
    [state doubleIncPC];
    if ([state getZFlag] == true)
    {
        ram[[state getSP]] = (int8_t)(([state getPC]) & 0xff00) >> 8;
        ram[[state getSP]+1] = (int8_t)(([state getPC]) & 0x00ff);
        [state setSP:([state getSP] - 2)];
        [state setPC:d16];
    }
    PRINTDBG("0xCC -- CALL Z,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n",
             d16 & 0xffff, prev_short, [state getSP],
             [state getPC]);
};
void (^execute0xCDInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;
    unsigned short prev_short = 0;

    // CALL a16 -- call subroutine at address a16
    prev_short = [state getSP];
    d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
    [state doubleIncPC];
    ram[[state getSP]] = (int8_t)(([state getPC]) & 0xff);
    ram[[state getSP]+1] = (int8_t)((([state getPC]) & 0xff00) >> 8);
    [state setSP:([state getSP] - 2)];
    [state setPC:d16];
    PRINTDBG("0xCD -- CALL a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x; (SP) = 0x%02x\n", d16 & 0xffff,
             [state getPC],
             prev_short, [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};
void (^execute0xCEInstruction)(RomState *,
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

    // ADC A,d8 -- Add d8 + C-flag to A
    prev = [state getA];
    d8 = ram[[state getPC]];
    [state incrementPC];
    if ([state getCFlag])
    {
        [state setA:([state getA]+d8+1)];
    }
    else
    {
        [state setA:([state getA]+d8)];
    }
    /*
     Z - Set if result is zero.
     N - Set.
     H - Set if carry from bit 4.
     C - Set if carry (from bit 7).
     */
    [state setFlags:[state getA] == 0
                  N:false
                  H:((char)(prev & 0xf) > (char)((([state getA] & 0xf + \
                                                   ([state getCFlag] ? 1 : 0)) & 0xf)))
                  C:((unsigned char)(prev) > (unsigned char)([state getA] + \
                                                             ([state getCFlag] ? 1 : 0)))];
    PRINTDBG("0xCE -- ADC A,d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n",
             prev, [state getA], d8 & 0xff);
};
void (^execute0xCFInstruction)(RomState *,
                              int8_t *,
                              bool *,
                              int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int16_t d16 = 0;

    // RST 08H -- push PC onto stack, and jump to address 0x00
    d16 = [state getPC] + 1;
    [state setSP:([state getSP] - 2)];
    ram[[state getSP]] = (d16 & 0xff00) >> 8;
    ram[[state getSP]+1] = d16 & 0x00ff;
    [state setPC:0x08];
    *incrementPC =false;
    PRINTDBG("0xCF -- RST 08H -- SP is now at 0x%02x; (SP) = 0x%02x\n", [state getSP],
             (((ram[[state getSP]]) & 0x00ff)) |
             (((ram[[state getSP]+1]) << 8) & 0xff00));
};