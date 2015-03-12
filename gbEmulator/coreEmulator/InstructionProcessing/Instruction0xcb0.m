#import "emulatorMain.h"

void (^execute0xcb0Instruction)(romState *,
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
    bool C = false;
    int8_t prev = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // RLC B -- Rotate B left
            prev = [state getB];
            C = [state getB] & 0b10000000;
            [state setB:([state getB] << 1)];
            [state setFlags:[state getB] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RLC B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, prev, [state getB]);
            break;
        case 1:
            // RLC C -- Rotate C left
            prev = [state getC];
            C = [state getC] & 0b10000000;
            [state setC:([state getC] << 1)];
            [state setFlags:[state getC] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RLC C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, prev, [state getC]);
            break;
        case 2:
            // RLC D -- Rotate D left
            prev = [state getD];
            C = [state getD] & 0b10000000;
            [state setD:([state getD] << 1)];
            [state setFlags:[state getD] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RLC D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, prev, [state getD]);
            break;
        case 3:
            // RLC E -- Rotate E left
            prev = [state getE];
            C = [state getE] & 0b10000000;
            [state setE:([state getE] << 1)];
            [state setFlags:[state getE] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RLC E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, prev, [state getE]);
            break;
        case 4:
            // RLC H -- Rotate H left
            prev = [state getH];
            C = [state getH] & 0b10000000;
            [state setH:([state getH] << 1)];
            [state setFlags:[state getH] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RLC H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, prev, [state getH]);
            break;
        case 5:
            // RLC L -- Rotate L left
            prev = [state getL];
            C = [state getH] & 0b10000000;
            [state setL:([state getL] << 1)];
            [state setFlags:[state getL] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RLC L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, prev, [state getL]);
            break;
        case 6:
            // RLC (HL) -- Rotate (HL) left
            prev = ram[(unsigned short)[state getHL_big]];
            C = ram[(unsigned short)[state getHL_big]] & 0b10000000;
            ram[(unsigned short)[state getHL_big]] = ram[(unsigned short)[state getHL_big]] << 1;
            [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RLC (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 7:
            // RLC A -- Rotate A left
            prev = [state getA];
            C = [state getA] & 0b10000000;
            [state setA:([state getA] << 1)];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RLC A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, prev, [state getA]);
            break;
        case 8:
            // RRC B -- Rotate B right
            prev = [state getB];
            C = [state getB] & 0b00000001;
            [state setB:([state getB] >> 1)];
            [state setFlags:[state getB] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RRC B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, prev, [state getB]);
            break;
        case 9:
            // RRC C -- Rotate C right
            prev = [state getC];
            C = [state getC] & 0b00000001;
            [state setC:([state getC] >> 1)];
            [state setFlags:[state getC] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RRC C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, prev, [state getC]);
            break;
        case 0xA:
            // RRC D -- Rotate D right
            prev = [state getD];
            C = [state getD] & 0b00000001;
            [state setD:([state getD] >> 1)];
            [state setFlags:[state getD] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RRC D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, prev, [state getD]);
            break;
        case 0xB:
            // RRC E -- Rotate E right
            prev = [state getE];
            C = [state getE] & 0b00000001;
            [state setE:([state getE] >> 1)];
            [state setFlags:[state getE] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RRC E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, prev, [state getE]);
            break;
        case 0xC:
            // RRC H -- Rotate H right
            prev = [state getH];
            C = [state getH] & 0b00000001;
            [state setH:([state getH] >> 1)];
            [state setFlags:[state getH] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RRC H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, prev, [state getH]);
            break;
        case 0xD:
            // RRC L -- Rotate L right
            prev = [state getL];
            C = [state getL] & 0b00000001;
            [state setL:([state getL] >> 1)];
            [state setFlags:[state getL] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RRC L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, prev, [state getL]);
            break;
        case 0xE:
            // RRC (HL) -- Rotate (HL) right
            prev = ram[(unsigned short)[state getHL_big]];
            C = ram[(unsigned short)[state getHL_big]] & 0b00000001;
            ram[(unsigned short)[state getHL_big]] = ram[(unsigned short)[state getHL_big]] >> 1;
            [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RRC (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 0xF:
            // RRC A -- Rotate A right
            prev = [state getA];
            C = [state getA] & 0b00000001;
            [state setA:([state getA] >> 1)];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0xCB%02x -- RRC A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, prev, [state getA]);
            break;
    }
};