#import "emulatorMain.h"


void (^execute0xcb3Instruction)(romState *,
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
    bool C = false;
    switch (currentInstruction & 0x0F) {
        case 0:
            // SWAP B -- swap upper and lower nybbles of B
            prev = [state getB];
            [state setB:(([state getB] & 0x0f) << 4) | (([state getB] & 0xf0) >> 4)];
            [state setFlags:[state getB] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0xCB%02x -- SWAP B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction,
                     prev, [state getB]);
            break;
        case 1:
            // SWAP C -- swap upper and lower nybbles of C
            prev = [state getC];
            [state setC:(([state getC] & 0x0f) << 4) | (([state getC] & 0xf0) >> 4)];
            [state setFlags:[state getC] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0xCB%02x -- SWAP C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction,
                     prev, [state getC]);
            break;
        case 2:
            // SWAP D -- swap upper and lower nybbles of D
            prev = [state getD];
            [state setD:(([state getD] & 0x0f) << 4) | (([state getD] & 0xf0) >> 4)];
            [state setFlags:[state getD] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0xCB%02x -- SWAP D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction,
                     prev, [state getD]);
            break;
        case 3:
            // SWAP E -- swap upper and lower nybbles of E
            prev = [state getE];
            [state setE:(([state getE] & 0x0f) << 4) | (([state getE] & 0xf0) >> 4)];
            [state setFlags:[state getE] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0xCB%02x -- SWAP E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction,
                     prev, [state getE]);
            break;
        case 4:
            // SWAP H -- swap upper and lower nybbles of H
            prev = [state getH];
            [state setH:(([state getH] & 0x0f) << 4) | (([state getH] & 0xf0) >> 4)];
            [state setFlags:[state getH] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0xCB%02x -- SWAP H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction,
                     prev, [state getH]);
            break;
        case 5:
            // SWAP L -- swap upper and lower nybbles of L
            prev = [state getL];
            [state setL:(([state getL] & 0x0f) << 4) | (([state getL] & 0xf0) >> 4)];
            [state setFlags:[state getL] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0xCB%02x -- SWAP L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction,
                     prev, [state getL]);
            break;
        case 6:
            // SWAP (HL) -- swap upper and lower nybbles of (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = ((ram[(unsigned short)[state getHL_big]] & 0x0f) << 4) |
                                        ((ram[(unsigned short)[state getHL_big]] & 0xf0) >> 4);
            [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0xCB%02x -- SWAP (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction,
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 7:
            // SWAP A -- swap upper and lower nybbles of A
            prev = [state getA];
            [state setA:(([state getA] & 0x0f) << 4) | (([state getA] & 0xf0) >> 4)];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0xCB%02x -- SWAP A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 8:
            // SRL B -- Shift B right into Carry; MSb reset
            prev = [state getB];
            C = (bool)([state getB] & 0b00000001);
            [state setB:([state getB] >> 1) & 0xff];
            [state setFlags:[state getB] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- SRL B -- B was 0x%02x; B is now 0x%02x; C-flag = %i\n", currentInstruction,
                     prev & 0xff, [state getB] & 0xff, [state getCFlag]);
            break;
        case 9:
            // SRL C -- Shift C right into Carry; MSb reset
            prev = [state getC];
            C = (bool)([state getC] & 0b00000001);
            [state setC:([state getC] >> 1) & 0xff];
            [state setFlags:[state getC] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- SRL C -- C was 0x%02x; C is now 0x%02x; C-flag = %i\n", currentInstruction,
                     prev & 0xff, [state getC] & 0xff, [state getCFlag]);
            break;
        case 0xA:
            // SRL D -- Shift D right into Carry; MSb reset
            prev = [state getD];
            C = (bool)([state getD] & 0b00000001);
            [state setD:([state getD] >> 1) & 0xff];
            [state setFlags:[state getD] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- SRL D -- D was 0x%02x; D is now 0x%02x; C-flag = %i\n", currentInstruction,
                     prev & 0xff, [state getD] & 0xff, [state getCFlag]);
            break;
        case 0xB:
            // SRL E -- Shift E right into Carry; MSb reset
            prev = [state getE];
            C = (bool)([state getE] & 0b00000001);
            [state setE:([state getE] >> 1) & 0xff];
            [state setFlags:[state getE] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- SRL E -- E was 0x%02x; E is now 0x%02x; C-flag = %i\n", currentInstruction,
                     prev & 0xff, [state getE] & 0xff, [state getCFlag]);
            break;
        case 0xC:
            // SRL H -- Shift H right into Carry; MSb reset
            prev = [state getH];
            C = (bool)([state getH] & 0b00000001);
            [state setH:([state getH] >> 1) & 0xff];
            [state setFlags:[state getH] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- SRL H -- H was 0x%02x; H is now 0x%02x; C-flag = %i\n", currentInstruction,
                     prev & 0xff, [state getH] & 0xff, [state getCFlag]);
            break;
        case 0xD:
            // SRL L -- Shift L right into Carry; MSb reset
            prev = [state getL];
            C = (bool)([state getL] & 0b00000001);
            [state setL:([state getL] >> 1) & 0xff];
            [state setFlags:[state getL] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- SRL L -- L was 0x%02x; L is now 0x%02x; C-flag = %i\n", currentInstruction,
                     prev & 0xff, [state getL] & 0xff, [state getCFlag]);
            break;
        case 0xE:
            // SRL (HL) -- Shift (HL) right into Carry; MSb reset
            prev = ram[(unsigned short)[state getHL_big]];
            C = (bool)(ram[(unsigned short)[state getHL_big]] & 0b00000001);
            ram[(unsigned short)[state getHL_big]] = (ram[(unsigned short)[state getHL_big]] << 1)
                                                      & 0xff;
            [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- SRL (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x; C-flag = %i\n", currentInstruction,
                     prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff, [state getCFlag]);
            break;
        case 0xF:
            // SRL A -- Shift A right into Carry; MSb reset
            prev = [state getA];
            C = (bool)([state getA] & 0b00000001);
            [state setA:([state getA] >> 1) & 0xff];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- SRL A -- A was 0x%02x; A is now 0x%02x; C-flag = %i\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff, [state getCFlag]);
            break;
    }
};