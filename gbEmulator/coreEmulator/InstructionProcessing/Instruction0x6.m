#import "emulatorMain.h"


void (^execute0x6Instruction)(romState *,
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
    short prev_short = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // LD H,B -- Load B into H
            prev = [state getH];
            [state setH:[state getB]];
            PRINTDBG("0x%02x -- LD H,B -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 1:
            // LD H,C -- Load C into H
            prev = [state getH];
            [state setH:[state getC]];
            PRINTDBG("0x%02x -- LD H,C -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 2:
            // LD H,D -- Load D into H
            prev = [state getH];
            [state setH:[state getD]];
            PRINTDBG("0x%02x -- LD H,D -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 3:
            // LD H,E -- Load E into H
            prev = [state getH];
            [state setH:[state getE]];
            PRINTDBG("0x%02x -- LD H,E -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 4:
            // LD H,H -- Load H into H -- No-op
            PRINTDBG("0x%02x -- LD H,H\n", currentInstruction);
            break;
        case 5:
            // LD H,L -- Load L into H
            prev = [state getH];
            [state setH:[state getL]];
            PRINTDBG("0x%02x -- LD H,L -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 6:
            // LD H,(HL) -- Load (HL) into H
            prev = [state getH];
            prev_short = [state getHL_big];
            [state setH:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD H,(HL) -- H was 0x%02x; HL was 0x%04x; (HL) was 0x%02x; H is now 0x%02x\n", \
                     currentInstruction, prev & 0xff, prev_short & 0xffff, \
                     ram[(unsigned short)prev_short] & 0xff, [state getH] & 0xff);
            break;
        case 7:
            // LD H,A -- Load A into H
            prev = [state getH];
            [state setH:[state getA]];
            PRINTDBG("0x%02x -- LD H,A -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 8:
            // LD L,B -- Load B into L
            prev = [state getL];
            [state setL:[state getB]];
            PRINTDBG("0x%02x -- LD L,B -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 9:
            // LD L,C -- Load C into L
            prev = [state getL];
            [state setL:[state getC]];
            PRINTDBG("0x%02x -- LD L,C -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 0xA:
            // LD L,D -- Load D into L
            prev = [state getL];
            [state setL:[state getD]];
            PRINTDBG("0x%02x -- LD L,D -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 0xB:
            // LD L,E -- Load E into L
            prev = [state getL];
            [state setL:[state getE]];
            PRINTDBG("0x%02x -- LD L,E -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 0xC:
            // LD L,H -- Load H into L
            prev = [state getL];
            [state setL:[state getH]];
            PRINTDBG("0x%02x -- LD L,H -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 0xD:
            // LD L,L -- Load L into L -- No-op
            PRINTDBG("0x%02x -- LD L,L\n", currentInstruction);
            break;
        case 0xE:
            // LD L,(HL) -- Load (HL) into L
            prev = [state getL];
            [state setL:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD L,(HL) -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 0xF:
            // LD L,A -- Load A into L
            prev = [state getL];
            [state setL:[state getA]];
            PRINTDBG("0x%02x -- LD L,A -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
    }
};
