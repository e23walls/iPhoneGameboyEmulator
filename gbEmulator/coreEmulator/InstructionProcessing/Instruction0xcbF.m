#import "emulatorMain.h"


void (^execute0xcbFInstruction)(romState *,
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
            // SET 6,B -- Set bit 6 of B
            prev = [state getB];
            [state setB:[state getB] | 0b01000000];
            PRINTDBG("0x%02x -- SET 6,B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff);
            break;
        case 1:
            // SET 6,C -- Set bit 6 of C
            prev = [state getC];
            [state setC:[state getC] | 0b01000000];
            PRINTDBG("0x%02x -- SET 6,C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff);
            break;
        case 2:
            // SET 6,D -- Set bit 6 of D
            prev = [state getD];
            [state setD:[state getD] | 0b01000000];
            PRINTDBG("0x%02x -- SET 6,D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff);
            break;
        case 3:
            // SET 6,E -- Set bit 6 of E
            prev = [state getE];
            [state setE:[state getE] | 0b01000000];
            PRINTDBG("0x%02x -- SET 6,E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff);
            break;
        case 4:
            // SET 6,H -- Set bit 6 of H
            prev = [state getH];
            [state setH:[state getH] | 0b01000000];
            PRINTDBG("0x%02x -- SET 6,H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff);
            break;
        case 5:
            // SET 6,L -- Set bit 6 of L
            prev = [state getL];
            [state setL:[state getL] | 0b01000000];
            PRINTDBG("0x%02x -- SET 6,L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff);
            break;
        case 6:
            // SET 6,(HL) -- Set bit 6 of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] |= 0b01000000;
            PRINTDBG("0x%02x -- SET 6,(HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff);
            break;
        case 7:
            // SET 6,A -- Set bit 6 of A
            prev = [state getA];
            [state setA:[state getA] | 0b01000000];
            PRINTDBG("0x%02x -- SET 6,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff);
            break;
        case 8:
            // SET 7,B -- Set bit 7 of B
            prev = [state getB];
            [state setB:[state getB] | 0b10000000];
            PRINTDBG("0x%02x -- SET 7,B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff);
            break;
        case 9:
            // SET 7,C -- Set bit 7 of C
            prev = [state getC];
            [state setC:[state getC] | 0b10000000];
            PRINTDBG("0x%02x -- SET 7,C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff);
            break;
        case 0xA:
            // SET 7,D -- Set bit 7 of D
            prev = [state getD];
            [state setD:[state getD] | 0b10000000];
            PRINTDBG("0x%02x -- SET 7,D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff);
            break;
        case 0xB:
            // SET 7,E -- Set bit 7 of E
            prev = [state getE];
            [state setE:[state getE] | 0b10000000];
            PRINTDBG("0x%02x -- SET 7,E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff);
            break;
        case 0xC:
            // SET 7,H -- Set bit 7 of H
            prev = [state getH];
            [state setH:[state getH] | 0b10000000];
            PRINTDBG("0x%02x -- SET 7,H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff);
            break;
        case 0xD:
            // SET 7,L -- Set bit 7 of L
            prev = [state getL];
            [state setL:[state getL] | 0b10000000];
            PRINTDBG("0x%02x -- SET 7,L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff);
            break;
        case 0xE:
            // SET 7,(HL) -- Set bit 7 of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] |= 0b10000000;
            PRINTDBG("0x%02x -- SET 7,(HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff);
            break;
        case 0xF:
            // SET 7,A -- Set bit 7 of A
            prev = [state getA];
            [state setA:[state getA] | 0b10000000];
            PRINTDBG("0x%02x -- SET 7,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff);
            break;
    }
};