#import "emulatorMain.h"


void (^execute0xcb8Instruction)(romState *,
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
            // RES 0,B -- Reset bit 0 of B
            prev = [state getB];
            [state setB:[state getB] & 0b11111110];
            PRINTDBG("0x%02x -- RES 0,B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff);
            break;
        case 1:
            // RES 0,C -- Reset bit 0 of C
            prev = [state getC];
            [state setC:[state getC] & 0b11111110];
            PRINTDBG("0x%02x -- RES 0,C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff);
            break;
        case 2:
            // RES 0,D -- Reset bit 0 of D
            prev = [state getD];
            [state setD:[state getD] & 0b11111110];
            PRINTDBG("0x%02x -- RES 0,D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff);
            break;
        case 3:
            // RES 0,E -- Reset bit 0 of E
            prev = [state getE];
            [state setE:[state getE] & 0b11111110];
            PRINTDBG("0x%02x -- RES 0,E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff);
            break;
        case 4:
            // RES 0,H -- Reset bit 0 of H
            prev = [state getH];
            [state setH:[state getH] & 0b11111110];
            PRINTDBG("0x%02x -- RES 0,H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff);
            break;
        case 5:
            // RES 0,L -- Reset bit 0 of L
            prev = [state getL];
            [state setL:[state getL] & 0b11111110];
            PRINTDBG("0x%02x -- RES 0,L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff);
            break;
        case 6:
            // RES 0,(HL) -- Reset bit 0 of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] &= 0b11111110;
            PRINTDBG("0x%02x -- RES 0,(HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff);
            break;
        case 7:
            // RES 0,A -- Reset bit 0 of A
            prev = [state getA];
            [state setA:[state getA] & 0b11111110];
            PRINTDBG("0x%02x -- RES 0,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff);
            break;
        case 8:
            // RES 1,B -- Reset bit 1 of B
            prev = [state getB];
            [state setB:[state getB] & 0b11111101];
            PRINTDBG("0x%02x -- RES 1,B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff);
            break;
        case 9:
            // RES 1,C -- Reset bit 1 of C
            prev = [state getC];
            [state setC:[state getC] & 0b11111101];
            PRINTDBG("0x%02x -- RES 1,C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff);
            break;
        case 0xA:
            // RES 1,D -- Reset bit 1 of D
            prev = [state getD];
            [state setD:[state getD] & 0b11111101];
            PRINTDBG("0x%02x -- RES 1,D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff);
            break;
        case 0xB:
            // RES 1,E -- Reset bit 1 of E
            prev = [state getE];
            [state setE:[state getE] & 0b11111101];
            PRINTDBG("0x%02x -- RES 1,E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff);
            break;
        case 0xC:
            // RES 1,H -- Reset bit 1 of H
            prev = [state getH];
            [state setH:[state getH] & 0b11111101];
            PRINTDBG("0x%02x -- RES 1,H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff);
            break;
        case 0xD:
            // RES 1,L -- Reset bit 1 of L
            prev = [state getL];
            [state setL:[state getL] & 0b11111101];
            PRINTDBG("0x%02x -- RES 1,L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff);
            break;
        case 0xE:
            // RES 1,(HL) -- Reset bit 1 of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] &= 0b11111101;
            PRINTDBG("0x%02x -- RES 1,(HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff);
            break;
        case 0xF:
            // RES 1,A -- Reset bit 1 of A
            prev = [state getA];
            [state setA:[state getA] & 0b11111101];
            PRINTDBG("0x%02x -- RES 1,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff);
            break;
    }
};