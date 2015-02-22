#import "emulatorMain.h"


void (^execute0x4Instruction)(romState *,
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
            // LD B,B -- Load B into B (effectively a no-op)
            PRINTDBG("0x%02x -- LD B,B\n", currentInstruction);
            break;
        case 1:
            // LD B,C -- Load C into B
            prev = [state getB];
            [state setB:[state getC]];
            PRINTDBG("0x%02x -- LD B,C -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 2:
            // LD B,D -- Load D into B
            prev = [state getB];
            [state setB:[state getD]];
            PRINTDBG("0x%02x -- LD B,D -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 3:
            // LD B,E -- Load E into B
            prev = [state getB];
            [state setB:[state getE]];
            PRINTDBG("0x%02x -- LD B,E -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 4:
            // LD B,H -- Load H into B
            prev = [state getB];
            [state setB:[state getH]];
            PRINTDBG("0x%02x -- LD B,H -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 5:
            // LD B,L -- Load L into B
            prev = [state getB];
            [state setB:[state getL]];
            PRINTDBG("0x%02x -- LD B,L -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 6:
            // LD B,(HL) -- Load (HL) into B
            prev = [state getB];
            [state setB:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD B,(HL) -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 7:
            // LD B,A -- Load A into B
            prev = [state getB];
            [state setB:[state getA]];
            PRINTDBG("0x%02x -- LD B,A -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 8:
            // LD C,B -- Load B into C
            prev = [state getC];
            [state setC:[state getB]];
            PRINTDBG("0x%02x -- LD C,B -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 9:
            // LD C,C -- Load C into C -- Again, effectively a no-op
            PRINTDBG("0x%02x -- LD C,C\n", currentInstruction);
            break;
        case 0xA:
            // LD C,D -- Load D into C
            prev = [state getC];
            [state setC:[state getD]];
            PRINTDBG("0x%02x -- LD C,D -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 0xB:
            // LD C,E -- Load E into C
            prev = [state getC];
            [state setC:[state getE]];
            PRINTDBG("0x%02x -- LD C,E -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 0xC:
            // LD C,H -- Load H into C
            prev = [state getC];
            [state setC:[state getH]];
            PRINTDBG("0x%02x -- LD C,H -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 0xD:
            // LD C,L -- Load L into C
            prev = [state getC];
            [state setC:[state getL]];
            PRINTDBG("0x%02x -- LD C,L -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 0xE:
            // LD C,(HL)
            prev = [state getC];
            [state setC:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD C,(HL) -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 0xF:
            // LD C,A -- Load A into C
            prev = [state getC];
            [state setC:[state getA]];
            PRINTDBG("0x%02x -- LD C,A -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
    }
};
