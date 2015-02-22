#import "emulatorMain.h"

extern void (^enableInterrupts)(bool, char *);
extern void (^execute0xcbInstruction)(romState *, char *, bool *, int8_t *, int8_t);

void (^execute0xCInstruction)(romState *,
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
    unsigned short prev_short = 0;
    int8_t prev = 0;
    int8_t d8 = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // RET NZ -- If !Z, return from subroutine
            prev_short = [state getSP];
            if ([state getZFlag] == false)
            {
                d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
                (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [state setSP:([state getSP]+2)];
                [state setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET NZ -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction & 0xff,
                     prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
            break;
        case 1:
            // POP BC -- Pop two bytes from SP into BC, and increment SP twice
            d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
            (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [state setBC_big:d16];
            [state setSP:([state getSP] + 2)];
            PRINTDBG("0x%02x -- POP BC -- BC = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction & 0xff,
                     [state getBC_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 2:
            // JP NZ,a16 -- If !Z, jump to address a16
            if ([state getZFlag] == false)
            {
                d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
                    (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
                [state setPC:d16];
            }
            PRINTDBG("0x%02x -- JP NZ,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", currentInstruction & 0xff,
                     d16 & 0xffff, [state getPC]);
            *incrementPC = false;
            break;
        case 3:
            // JP a16 -- Jump to address a16
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state setPC:d16];
            PRINTDBG("0x%02x -- JP a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", currentInstruction & 0xff,
                     d16 & 0xffff, [state getPC]);
            *incrementPC = false;
            break;
        case 4:
            // CALL NZ,a16 -- If !Z, push PC onto stack, and jump to a16
            prev_short = [state getSP];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) |
                (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getZFlag] == false)
            {
                [state setSP:([state getSP] - 2)];
                ram[[state getSP]] = (int8_t)(([state getPC]+1) & 0xff00) >> 8;
                ram[[state getSP]+1] = (int8_t)(([state getPC]+1) & 0x00ff);
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- CALL NZ,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x; (SP) = 0x%02x\n", currentInstruction & 0xff,
                     d16 & 0xffff, prev_short, [state getSP],
                     [state getPC],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 5:
            // PUSH BC -- push BC onto SP, and decrement SP twice
            d16 = [state getBC_little];
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            PRINTDBG("0x%02x -- PUSH BC -- BC = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction & 0xff,
                     [state getBC_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 6:
            // ADD A,d8 -- A <- A + d8
            prev = [state getA];
            d8 = ram[[state getPC]];
            [state incrementPC];
            [state setA:([state getA] + d8)];
            [state setFlags:[state getA] == 0
                          N:false
                          H:prev > [state getA]
                          C:((unsigned char)prev > (unsigned char)[state getA])];
            PRINTDBG("0x%02x -- ADD d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n", currentInstruction & 0xff,
                     prev & 0xff, [state getA], d8 & 0xff);
            break;
        case 7:
            // RST 00H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC];
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x00];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 00H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction & 0xff, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 8:
            // RET Z -- If Z, return from subroutine
            prev_short = [state getSP];
            if ([state getZFlag] == true)
            {
                d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
                (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [state setSP:([state getSP]+2)];
                [state setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET Z -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction & 0xff, \
                     prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
            break;
        case 9:
            // RET -- return from subroutine; pop two bytes from SP and go to that address
            d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
            (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [state setSP:([state getSP]+2)];
            [state setPC:(unsigned short)d16];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RET -- PC is now 0x%02x; (SP) = 0x%02x\n", currentInstruction & 0xff,
                     [state getPC],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 0xA:
            // JP Z,a16 -- If Z, jump to address a16
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
            [state doubleIncPC];
            if ([state getZFlag] == true)
            {
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- JP Z,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", currentInstruction & 0xff,
                     d16 & 0xffff, [state getPC]);
            break;
        case 0xB:
            // Instruction with 0xCB prefix
            PRINTDBG("CB instruction...\n");
            currentInstruction = ram[[state getPC]];
            execute0xcbInstruction(state, ram, incrementPC, interruptsEnabled, currentInstruction);
            break;
        case 0xC:
            // CALL Z,a16 -- If Z, call subroutine at address a16
            prev_short = [state getSP];
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
            [state doubleIncPC];
            if ([state getZFlag] == true)
            {
                [state setSP:([state getSP] - 2)];
                ram[[state getSP]] = (int8_t)(([state getPC]+1) & 0xff00) >> 8;
                ram[[state getSP]+1] = (int8_t)(([state getPC]+1) & 0x00ff);
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- CALL Z,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction & 0xff,
                     d16 & 0xffff, prev_short, [state getSP],
                     [state getPC]);
            break;
        case 0xD:
            // CALL a16 -- call subroutine at address a16
            prev_short = [state getSP];
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
            [state doubleIncPC];
            [state setSP:(prev_short - 2)];
            ram[[state getSP]] = (int8_t)(([state getPC]+1) & 0xff);
            ram[[state getSP]+1] = (int8_t)((([state getPC]+1) & 0xff00) >> 8);
            [state setPC:d16];
            *incrementPC = false;
            PRINTDBG("0x%02x -- CALL a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x; (SP) = 0x%02x\n", currentInstruction & 0xff, d16 & 0xffff,
                     [state getPC],
                     prev_short, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 0xE:
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
            PRINTDBG("0x%02x -- ADC A,d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n", currentInstruction & 0xff,
                     prev, [state getA], d8 & 0xff);
            break;
        case 0xF:
            // RST 08H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC] + 1;
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x08];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 08H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction & 0xff, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
    }
};