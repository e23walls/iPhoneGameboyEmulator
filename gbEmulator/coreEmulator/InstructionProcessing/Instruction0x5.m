#import "emulatorMain.h"


void (^execute0x5Instruction)(romState *,
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
            // LD D,B -- Load B into D
            prev = [state getD];
            [state setD:[state getB]];
            PRINTDBG("0x%02x -- LD D,B -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 1:
            // LD D,C -- Load C into D
            prev = [state getD];
            [state setC:[state getB]];
            PRINTDBG("0x%02x -- LD D,C -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 2:
            // LD D,D -- Load D into D -- No-op
            PRINTDBG("0x%02x -- LD D,D\n", currentInstruction);
            break;
        case 3:
            // LD D,E -- Load E into D
            prev = [state getD];
            [state setD:[state getE]];
            PRINTDBG("0x%02x -- LD D,E -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 4:
            // LD D,H -- Load H into D
            prev = [state getD];
            [state setD:[state getH]];
            PRINTDBG("0x%02x -- LD D,H -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 5:
            // LD D,L -- Load L into D
            prev = [state getD];
            [state setD:[state getL]];
            PRINTDBG("0x%02x -- LD D,L -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 6:
            // LD D,(HL) -- Load (HL) into D
            prev = [state getD];
            [state setD:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD D,(HL) -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 7:
            // LD D,A -- Load A into D
            prev = [state getD];
            [state setD:[state getA]];
            PRINTDBG("0x%02x -- LD D,A -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 8:
            // LD E,B -- Load B into E
            prev = [state getE];
            [state setE:[state getB]];
            PRINTDBG("0x%02x -- LD E,B -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 9:
            // LD E,C -- Load C into E
            prev = [state getE];
            [state setE:[state getC]];
            PRINTDBG("0x%02x -- LD E,C -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 0xA:
            // LD E,D -- Load D into E
            prev = [state getE];
            [state setE:[state getD]];
            PRINTDBG("0x%02x -- LD E,D -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 0xB:
            // LD E,E -- Load E into E -- No-op
            prev = [state getE];
            [state setE:[state getB]];
            PRINTDBG("0x%02x -- LD E,E\n", currentInstruction);
            break;
        case 0xC:
            // LD E,H -- Load H into E; A very Canadian instruction
            prev = [state getE];
            [state setE:[state getH]];
            PRINTDBG("0x%02x -- Load, eh? -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 0xD:
            // LD E,L -- Load L into E
            prev = [state getE];
            [state setE:[state getL]];
            PRINTDBG("0x%02x -- LD E,L -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 0xE:
            // LD E,(HL) -- Load (HL) into E
            prev = [state getE];
            [state setE:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD E,(HL) -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 0xF:
            // LD E,A -- Load A into E
            prev = [state getE];
            [state setE:[state getA]];
            PRINTDBG("0x%02x -- LD E,A -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
    }
};