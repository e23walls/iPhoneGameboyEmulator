#import "emulatorMain.h"


void (^execute0x7Instruction)(romState *,
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
    switch (currentInstruction & 0x0F) {
        case 0:
            // LD (HL),B -- Load B into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getB];
            PRINTDBG("0x%02x -- LD (HL),B -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 1:
            // LD (HL),C -- Load C into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getC];
            PRINTDBG("0x%02x -- LD (HL),C -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 2:
            // LD (HL),D -- Load D into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getD];
            PRINTDBG("0x%02x -- LD (HL),D -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 3:
            // LD (HL),E -- Load E into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getE];
            PRINTDBG("0x%02x -- LD (HL),E -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 4:
            // LD (HL),H -- Load H into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getH];
            PRINTDBG("0x%02x -- LD (HL),H -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 5:
            // LD (HL),L -- Load L into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getL];
            PRINTDBG("0x%02x -- LD (HL),L -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 6:
            // HALT -- Power down CPU until interrupt occurs
#warning DO THIS EVENTUALLY!
            PRINTDBG("0x%02x -- HALT\n", currentInstruction);
            break;
        case 7:
            // LD (HL),A -- Load A into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getA];
            PRINTDBG("0x%02x -- LD (HL),A -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 8:
            // LD A,B -- Load B into A
            prev = [state getA];
            [state setA:[state getB]];
            PRINTDBG("0x%02x -- LD A,B -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 9:
            // LD A,C -- Load C into A
            prev = [state getA];
            [state setA:[state getC]];
            PRINTDBG("0x%02x -- LD A,C -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xA:
            // LD A,D -- Load D into A
            prev = [state getA];
            [state setA:[state getD]];
            PRINTDBG("0x%02x -- LD A,D -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xB:
            // LD A,E -- Load E into A
            prev = [state getA];
            [state setA:[state getE]];
            PRINTDBG("0x%02x -- LD A,E -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xC:
            // LD A,H -- Load H into A
            prev = [state getA];
            [state setA:[state getH]];
            PRINTDBG("0x%02x -- LD A,H -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xD:
            // LD A,L -- Load L into A
            prev = [state getA];
            [state setA:[state getL]];
            PRINTDBG("0x%02x -- LD A,L -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xE:
            // LD A,(HL) -- Load (HL) into A
            prev = [state getA];
            [state setA:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD A,(HL) -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xF:
            // LD A,A -- Load A into A -- No-op
            PRINTDBG("0x%02x -- LD A,A\n", currentInstruction);
            break;
    }
};