#import "emulatorMain.h"


void (^execute0xcbDInstruction)(romState *,
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
            // SET 2,B -- Set bit 2 of B
            prev = [state getB];
            [state setB:[state getB] | 0b00000100];
            PRINTDBG("0xCB%02x -- SET 2,B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff);
            break;
        case 1:
            // SET 2,C -- Set bit 2 of C
            prev = [state getC];
            [state setC:[state getC] | 0b00000100];
            PRINTDBG("0xCB%02x -- SET 2,C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff);
            break;
        case 2:
            // SET 2,D -- Set bit 2 of D
            prev = [state getD];
            [state setD:[state getD] | 0b00000100];
            PRINTDBG("0xCB%02x -- SET 2,D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff);
            break;
        case 3:
            // SET 2,E -- Set bit 2 of E
            prev = [state getE];
            [state setE:[state getE] | 0b00000100];
            PRINTDBG("0xCB%02x -- SET 2,E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff);
            break;
        case 4:
            // SET 2,H -- Set bit 2 of H
            prev = [state getH];
            [state setH:[state getH] | 0b00000100];
            PRINTDBG("0xCB%02x -- SET 2,H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff);
            break;
        case 5:
            // SET 2,L -- Set bit 2 of L
            prev = [state getL];
            [state setL:[state getL] | 0b00000100];
            PRINTDBG("0xCB%02x -- SET 2,L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff);
            break;
        case 6:
            // SET 2,(HL) -- Set bit 2 of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] |= 0b00000100;
            PRINTDBG("0xCB%02x -- SET 2,(HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff);
            break;
        case 7:
            // SET 2,A -- Set bit 2 of A
            prev = [state getA];
            [state setA:[state getA] | 0b00000100];
            PRINTDBG("0xCB%02x -- SET 2,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff);
            break;
        case 8:
            // SET 3,B -- Set bit 3 of B
            prev = [state getB];
            [state setB:[state getB] | 0b00001000];
            PRINTDBG("0xCB%02x -- SET 3,B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff);
            break;
        case 9:
            // SET 3,C -- Set bit 3 of C
            prev = [state getC];
            [state setC:[state getC] | 0b00001000];
            PRINTDBG("0xCB%02x -- SET 3,C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff);
            break;
        case 0xA:
            // SET 3,D -- Set bit 3 of D
            prev = [state getD];
            [state setD:[state getD] | 0b00001000];
            PRINTDBG("0xCB%02x -- SET 3,D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff);
            break;
        case 0xB:
            // SET 3,E -- Set bit 3 of E
            prev = [state getE];
            [state setE:[state getE] | 0b00001000];
            PRINTDBG("0xCB%02x -- SET 3,E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff);
            break;
        case 0xC:
            // SET 3,H -- Set bit 3 of H
            prev = [state getH];
            [state setH:[state getH] | 0b00001000];
            PRINTDBG("0xCB%02x -- SET 3,H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff);
            break;
        case 0xD:
            // SET 3,L -- Set bit 3 of L
            prev = [state getL];
            [state setL:[state getL] | 0b00001000];
            PRINTDBG("0xCB%02x -- SET 3,L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff);
            break;
        case 0xE:
            // SET 3,(HL) -- Set bit 3 of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] |= 0b00001000;
            PRINTDBG("0xCB%02x -- SET 3,(HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff);
            break;
        case 0xF:
            // SET 3,A -- Set bit 3 of A
            prev = [state getA];
            [state setA:[state getA] | 0b00001000];
            PRINTDBG("0xCB%02x -- SET 3,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff);
            break;
    }
};