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
    switch (currentInstruction & 0x0F) {
        case 0:
            // RLC B -- Rotate B left
            C = [state getB] & 0b10000000;
            [state setB:([state getB] << 1)];
            [state setFlags:[state getB] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 1:
            // RLC C -- Rotate C left
            C = [state getC] & 0b10000000;
            [state setC:([state getC] << 1)];
            [state setFlags:[state getC] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 2:
            // RLC D -- Rotate D left
            C = [state getD] & 0b10000000;
            [state setD:([state getD] << 1)];
            [state setFlags:[state getD] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 3:
            // RLC E -- Rotate E left
            C = [state getE] & 0b10000000;
            [state setE:([state getE] << 1)];
            [state setFlags:[state getE] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 4:
            // RLC H -- Rotate H left
            C = [state getH] & 0b10000000;
            [state setH:([state getH] << 1)];
            [state setFlags:[state getH] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 5:
            // RLC H -- Rotate H left
            C = [state getH] & 0b10000000;
            [state setH:([state getH] << 1)];
            [state setFlags:[state getH] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 6:
            // RLC (HL) -- Rotate (HL) left
            C = ram[(unsigned short)[state getHL_big]] & 0b10000000;
            ram[(unsigned short)[state getHL_big]] = ram[(unsigned short)[state getHL_big]] << 1;
            [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 7:
            // RLC A -- Rotate A left
            C = [state getA] & 0b10000000;
            [state setA:([state getA] << 1)];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 8:
            // RRC B -- Rotate B right
            C = [state getB] & 0b00000001;
            [state setB:([state getB] >> 1)];
            [state setFlags:[state getB] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 9:
            // RRC C -- Rotate C right
            C = [state getC] & 0b00000001;
            [state setC:([state getC] >> 1)];
            [state setFlags:[state getC] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 0xA:
            // RRC D -- Rotate D right
            C = [state getD] & 0b00000001;
            [state setD:([state getD] >> 1)];
            [state setFlags:[state getD] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 0xB:
            // RRC E -- Rotate E right
            C = [state getE] & 0b00000001;
            [state setE:([state getE] >> 1)];
            [state setFlags:[state getE] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 0xC:
            // RRC H -- Rotate H right
            C = [state getH] & 0b00000001;
            [state setH:([state getH] >> 1)];
            [state setFlags:[state getH] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 0xD:
            // RRC L -- Rotate L right
            C = [state getL] & 0b00000001;
            [state setL:([state getL] >> 1)];
            [state setFlags:[state getL] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 0xE:
            // RRC (HL) -- Rotate (HL) right
            C = ram[(unsigned short)[state getHL_big]] & 0b00000001;
            ram[(unsigned short)[state getHL_big]] = ram[(unsigned short)[state getHL_big]] >> 1;
            [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                          N:false
                          H:false
                          C:C];
            break;
        case 0xF:
            // RRC A -- Rotate A right
            C = [state getA] & 0b00000001;
            [state setA:([state getA] >> 1)];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:C];
            break;
    }
};