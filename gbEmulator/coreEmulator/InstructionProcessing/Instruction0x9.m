#import "emulatorMain.h"


void (^execute0x9Instruction)(romState *,
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
    switch (currentInstruction & 0x0F) {
        case 0:
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
            PRINTDBG("0x%02x -- SUB B -- B is 0x%02x; A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     [state getB], prev, [state getA]);
            break;
        case 1:
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
            PRINTDBG("0x%02x -- SUB C -- C is 0x%02x; A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     [state getC], prev, [state getA]);
            break;
        case 2:
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
            PRINTDBG("0x%02x -- SUB D -- D is 0x%02x; A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     [state getD], prev, [state getA]);
            break;
        case 3:
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
            PRINTDBG("0x%02x -- SUB E -- E is 0x%02x; A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     [state getE], prev, [state getA]);
            break;
        case 4:
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
            PRINTDBG("0x%02x -- SUB H -- H is 0x%02x; A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     [state getH], prev, [state getA]);
            break;
        case 5:
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
            PRINTDBG("0x%02x -- SUB L -- L is 0x%02x; A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     [state getL], prev, [state getA]);
            break;
        case 6:
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
            PRINTDBG("0x%02x -- SUB (HL) -- HL is 0x%02x; (HL) is 0x%02x; A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     [state getHL_big], d8, prev, [state getA]);
            break;
        case 7:
            // SUB A -- A <- A - A
            prev = [state getA];
            [state setA:0];
            [state setFlags:[state getA] == 0
                          N:true
                          H:true
                          C:true];
            PRINTDBG("0x%02x -- SUB A -- A is now 0x0\n", currentInstruction);
            break;
        case 8:
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
            PRINTDBG("0x%02x -- SBC A,B -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 9:
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
            PRINTDBG("0x%02x -- SBC A,C -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xA:
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
            PRINTDBG("0x%02x -- SBC A,D -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xB:
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
            PRINTDBG("0x%02x -- SBC A,E -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xC:
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
            PRINTDBG("0x%02x -- SBC A,H -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xD:
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
            PRINTDBG("0x%02x -- SBC A,L -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xE:
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
            PRINTDBG("0x%02x -- SBC A,(HL) -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xF:
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
            PRINTDBG("0x%02x -- SBC A,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
    }
};