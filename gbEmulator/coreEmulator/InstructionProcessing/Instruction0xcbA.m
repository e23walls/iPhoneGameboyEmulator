#import "emulatorMain.h"


void (^execute0xcbAInstruction)(romState *,
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
            // RES 4,B -- Reset bit 4 of B
            prev = [state getB];
            [state setB:[state getB] & 0b11101111];
            PRINTDBG("0x%02x -- RES 4,B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff);
            break;
        case 1:
            // RES 4,C -- Reset bit 4 of C
            prev = [state getC];
            [state setC:[state getC] & 0b11101111];
            PRINTDBG("0x%02x -- RES 4,C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff);
            break;
        case 2:
            // RES 4,D -- Reset bit 4 of D
            prev = [state getD];
            [state setD:[state getD] & 0b11101111];
            PRINTDBG("0x%02x -- RES 4,D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff);
            break;
        case 3:
            // RES 4,E -- Reset bit 4 of E
            prev = [state getE];
            [state setE:[state getE] & 0b11101111];
            PRINTDBG("0x%02x -- RES 4,E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff);
            break;
        case 4:
            // RES 4,H -- Reset bit 4 of H
            prev = [state getH];
            [state setH:[state getH] & 0b11101111];
            PRINTDBG("0x%02x -- RES 4,H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff);
            break;
        case 5:
            // RES 4,L -- Reset bit 4 of L
            prev = [state getL];
            [state setL:[state getL] & 0b11101111];
            PRINTDBG("0x%02x -- RES 4,L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff);
            break;
        case 6:
            // RES 4,(HL) -- Reset bit 4 of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] &= 0b11101111;
            PRINTDBG("0x%02x -- RES 4,(HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff);
            break;
        case 7:
            // RES 4,A -- Reset bit 4 of A
            prev = [state getA];
            [state setA:[state getA] & 0b11101111];
            PRINTDBG("0x%02x -- RES 4,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff);
            break;
        case 8:
            // RES 5,B -- Reset bit 5 of B
            prev = [state getB];
            [state setB:[state getB] & 0b11011111];
            PRINTDBG("0x%02x -- RES 5,B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff);
            break;
        case 9:
            // RES 5,C -- Reset bit 5 of C
            prev = [state getC];
            [state setC:[state getC] & 0b11011111];
            PRINTDBG("0x%02x -- RES 5,C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff);
            break;
        case 0xA:
            // RES 5,D -- Reset bit 5 of D
            prev = [state getD];
            [state setD:[state getD] & 0b11011111];
            PRINTDBG("0x%02x -- RES 5,D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff);
            break;
        case 0xB:
            // RES 5,E -- Reset bit 5 of E
            prev = [state getE];
            [state setE:[state getE] & 0b11011111];
            PRINTDBG("0x%02x -- RES 5,E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff);
            break;
        case 0xC:
            // RES 5,H -- Reset bit 5 of H
            prev = [state getH];
            [state setH:[state getH] & 0b11011111];
            PRINTDBG("0x%02x -- RES 5,H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff);
            break;
        case 0xD:
            // RES 5,L -- Reset bit 5 of L
            prev = [state getL];
            [state setL:[state getL] & 0b11011111];
            PRINTDBG("0x%02x -- RES 5,L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff);
            break;
        case 0xE:
            // RES 5,(HL) -- Reset bit 5 of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] &= 0b11011111;
            PRINTDBG("0x%02x -- RES 5,(HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff);
            break;
        case 0xF:
            // RES 5,A -- Reset bit 5 of A
            prev = [state getA];
            [state setA:[state getA] & 0b11011111];
            PRINTDBG("0x%02x -- RES 5,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff);
            break;
    }
};