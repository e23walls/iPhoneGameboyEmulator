#import "emulatorMain.h"

extern void (^enableInterrupts)(bool, char *);;

void (^execute0xDInstruction)(romState *,
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
    int16_t d16 = 0;
    int8_t d8 = 0;
    int8_t prev = 0;
    unsigned short prev_short = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // RET NC -- If !C, return from subroutine
            prev_short = [state getSP];
            if ([state getCFlag] == false)
            {
                d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
                (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [state setSP:([state getSP]+2)];
                [state setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET NC -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction, \
                     prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
            break;
        case 1:
            // POP DE - Pop two bytes from SP into DE, and increment SP twice
            d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
            (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [state setDE_big:d16];
            [state setSP:([state getSP] + 2)];
            PRINTDBG("0x%02x -- POP DE -- DE = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getDE_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 2:
            // JP NC,a16 -- If !C, jump to address a16
            [state incrementPC];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getCFlag] == false)
            {
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- JP NC,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, [state getPC]);
            break;
        case 3:
            // no instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 4:
            // CALL NC,a16 -- If !C, call subroutine at address a16
            [state incrementPC];
            prev_short = [state getSP];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getCFlag] == false)
            {
                [state setSP:([state getSP] - 2)];
                ram[[state getSP]] = (([state getPC]+1) & 0xff00) >> 8;
                ram[[state getSP]+1] = ([state getPC]+1) & 0x00ff;
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- CALL NC,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, prev_short, [state getSP], \
                     [state getPC]);
            break;
        case 5:
            // PUSH DE -- push DE onto SP, and decrement SP twice
            d16 = [state getDE_little];
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            PRINTDBG("0x%02x -- PUSH DE -- DE = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getDE_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 6:
            // SUB d8 -- A <- A - d8
            [state incrementPC];
            d8 = ram[[state getPC]];
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
            PRINTDBG("0x%02x -- SUB d8 -- d8 is 0x%02x; A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     d8 & 0xff, prev, [state getA]);
            break;
        case 7:
            // RST 10H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC] + 1;
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x10];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 10H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 8:
            // RET C -- If C, return from subroutine
            prev_short = [state getSP];
            if ([state getCFlag] == true)
            {
                d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
                (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [state setSP:([state getSP]+2)];
                [state setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET C -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction, \
                     prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
            break;
        case 9:
            // RETI -- RET + enable interrupts
            d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
            (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [state setSP:([state getSP]+2)];
            [state setPC:(unsigned short)d16];
            *incrementPC = false;
            enableInterrupts(true, ram);
            PRINTDBG("0x%02x -- RETI -- PC is now 0x%02x\n", currentInstruction,
                     [state getPC]);
            break;
        case 0xA:
            // JP C,a16 -- If C, jump to address a16
            [state incrementPC];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getCFlag] == true)
            {
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- JP C,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, [state getPC]);
            break;
        case 0xB:
            // no instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 0xC:
            // CALL C,a16 -- If C, call subroutine at address a16
            [state incrementPC];
            prev_short = [state getSP];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getCFlag] == true)
            {
                [state setSP:([state getSP] - 2)];
                ram[[state getSP]] = (int8_t)(([state getPC]+1) & 0xff00) >> 8;
                ram[[state getSP]+1] = (int8_t)(([state getPC]+1) & 0x00ff);
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- CALL C,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, prev_short, [state getSP], \
                     [state getPC]);
            break;
        case 0xD:
            // no instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 0xE:
            // SBC A,d8 -- Subtract d8 + carry flag from A, so A = A - (d8 + C-flag)
            prev = [state getA];
            [state incrementPC];
            d8 = ram[[state getPC]];
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
            PRINTDBG("0x%02x -- SBC A,d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n", currentInstruction,
                     prev, [state getA], d8 & 0xff);
            
            break;
        case 0xF:
            // RST 18H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC] + 1;
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x18];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 18H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
    }
};