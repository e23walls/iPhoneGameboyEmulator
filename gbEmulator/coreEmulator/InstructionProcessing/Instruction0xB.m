#import "emulatorMain.h"


void (^execute0xBInstruction)(romState *,
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
            // OR B -- A <- A | B
            prev = [state getA];
            [state setA:([state getA] | [state getB])];
            [state setFlags:([state getA] == 0)
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- OR B -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 1:
            // OR C -- A <- A | C
            prev = [state getA];
            [state setA:([state getA] | [state getC])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- OR C -- A was 0x%02x; A is now 0x%02x; C = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getC] & 0xff);
            break;
        case 2:
            // OR D -- A <- A | D
            prev = [state getA];
            [state setA:([state getA] | [state getD])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- OR D -- A was 0x%02x; A is now 0x%02x; D = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getD] & 0xff);
            break;
        case 3:
            // OR E -- A <- A | E
            prev = [state getA];
            [state setA:([state getA] | [state getE])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- OR E -- A was 0x%02x; A is now 0x%02x; E = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getE] & 0xff);
            break;
        case 4:
            // OR H -- A <- A | H
            prev = [state getA];
            [state setA:([state getA] | [state getH])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- OR H -- A was 0x%02x; A is now 0x%02x; H = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getH] & 0xff);
            break;
        case 5:
            // OR L -- A <- A | L
            prev = [state getA];
            [state setA:([state getA] | [state getL])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- OR L -- A was 0x%02x; A is now 0x%02x; L = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getL] & 0xff);
            break;
        case 6:
            // OR (HL) -- A <- A | (HL)
            d8 = ram[(unsigned short)[state getHL_big]];
            prev = [state getA];
            [state setA:([state getA] | d8)];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- OR (HL) -- A was 0x%02x; A is now 0x%02x; HL = 0x%02x; (HL) = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getHL_big] & 0xffff, d8 & 0xff);
            break;
        case 7:
            // OR A -- A <- A | A
            [state setFlags:([state getA] == 0)
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- OR A -- A is 0x%02x\n", currentInstruction, [state getA]);
            break;
        case 8:
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
            PRINTDBG("0x%02x -- CP B -- B is 0x%02x; A is 0x%02x\n", currentInstruction,
                     [state getB], [state getA]);
            break;
        case 9:
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
            PRINTDBG("0x%02x -- CP C -- C is 0x%02x; A is 0x%02x\n", currentInstruction,
                     [state getC], [state getA]);
            break;
        case 0xA:
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
            PRINTDBG("0x%02x -- CP D -- D is 0x%02x; A is 0x%02x\n", currentInstruction,
                     [state getD], [state getA]);
            break;
        case 0xB:
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
            PRINTDBG("0x%02x -- CP E -- E is 0x%02x; A is 0x%02x\n", currentInstruction,
                     [state getE], [state getA]);
            break;
        case 0xC:
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
            PRINTDBG("0x%02x -- CP H -- H is 0x%02x; A is 0x%02x\n", currentInstruction,
                     [state getH], [state getA]);
            break;
        case 0xD:
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
            PRINTDBG("0x%02x -- CP L -- L is 0x%02x; A is 0x%02x\n", currentInstruction,
                     [state getL], [state getA]);
            break;
        case 0xE:
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
            PRINTDBG("0x%02x -- CP (HL) -- HL is 0x%02x; (HL) is 0x%02x; A is 0x%02x\n", currentInstruction,
                     [state getHL_big], d8, [state getA]);
            break;
        case 0xF:
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
            PRINTDBG("0x%02x -- CP A -- A is 0x%02x\n", currentInstruction,
                     [state getA]);
            break;
    }
};