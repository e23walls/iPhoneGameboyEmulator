#import "emulatorMain.h"


void (^execute0xcbBInstruction)(romState *,
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
            // RES 6,B -- Reset bit 6 of B
            prev = [state getB];
            [state setB:[state getB] & 0b10111111];
            PRINTDBG("0xCB%02x -- RES 6,B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff);
            break;
        case 1:
            // RES 6,C -- Reset bit 6 of C
            prev = [state getC];
            [state setC:[state getC] & 0b10111111];
            PRINTDBG("0xCB%02x -- RES 6,C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff);
            break;
        case 2:
            // RES 6,D -- Reset bit 6 of D
            prev = [state getD];
            [state setD:[state getD] & 0b10111111];
            PRINTDBG("0xCB%02x -- RES 6,D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff);
            break;
        case 3:
            // RES 6,E -- Reset bit 6 of E
            prev = [state getE];
            [state setE:[state getE] & 0b10111111];
            PRINTDBG("0xCB%02x -- RES 6,E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff);
            break;
        case 4:
            // RES 6,H -- Reset bit 6 of H
            prev = [state getH];
            [state setH:[state getH] & 0b10111111];
            PRINTDBG("0xCB%02x -- RES 6,H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff);
            break;
        case 5:
            // RES 6,L -- Reset bit 6 of L
            prev = [state getL];
            [state setL:[state getL] & 0b10111111];
            PRINTDBG("0xCB%02x -- RES 6,L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff);
            break;
        case 6:
            // RES 6,(HL) -- Reset bit 6 of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] &= 0b10111111;
            PRINTDBG("0xCB%02x -- RES 6,(HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff);
            break;
        case 7:
            // RES 6,A -- Reset bit 6 of A
            prev = [state getA];
            [state setA:[state getA] & 0b10111111];
            PRINTDBG("0xCB%02x -- RES 6,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff);
            break;
        case 8:
            // RES 7,B -- Reset bit 7 of B
            prev = [state getB];
            [state setB:[state getB] & 0b01111111];
            PRINTDBG("0xCB%02x -- RES 7,B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff);
            break;
        case 9:
            // RES 7,C -- Reset bit 7 of C
            prev = [state getC];
            [state setC:[state getC] & 0b01111111];
            PRINTDBG("0xCB%02x -- RES 7,C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff);
            break;
        case 0xA:
            // RES 7,D -- Reset bit 7 of D
            prev = [state getD];
            [state setD:[state getD] & 0b01111111];
            PRINTDBG("0xCB%02x -- RES 7,D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff);
            break;
        case 0xB:
            // RES 7,E -- Reset bit 7 of E
            prev = [state getE];
            [state setE:[state getE] & 0b01111111];
            PRINTDBG("0xCB%02x -- RES 7,E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff);
            break;
        case 0xC:
            // RES 7,H -- Reset bit 7 of H
            prev = [state getH];
            [state setH:[state getH] & 0b01111111];
            PRINTDBG("0xCB%02x -- RES 7,H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff);
            break;
        case 0xD:
            // RES 7,L -- Reset bit 7 of L
            prev = [state getL];
            [state setL:[state getL] & 0b01111111];
            PRINTDBG("0xCB%02x -- RES 7,L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff);
            break;
        case 0xE:
            // RES 7,(HL) -- Reset bit 7 of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] &= 0b01111111;
            PRINTDBG("0xCB%02x -- RES 7,(HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff);
            break;
        case 0xF:
            // RES 7,A -- Reset bit 7 of A
            prev = [state getA];
            [state setA:[state getA] & 0b01111111];
            PRINTDBG("0xCB%02x -- RES 7,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff);
            break;
    }
};