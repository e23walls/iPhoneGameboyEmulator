#import "emulatorMain.h"

void (^execute0xcb1Instruction)(romState *,
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
            // RL B -- Rotate B left through C-flag
            prev = [state getB] << 1;
            C = (bool)([state getB] & 0b10000000);
            // Set LSb of B to its previous C-value
            [state getCFlag] ? [state setB:(prev | 1)] : [state setB:(prev & 0b11111110)];
            [state setFlags:[state getB] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RL B -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, prev, [state getB]);
            break;
        case 1:
            // RL C -- Rotate C left through C-flag
            prev = [state getC] << 1;
            C = (bool)([state getC] & 0b10000000);
            // Set LSb of C to its previous C-value
            [state getCFlag] ? [state setC:(prev | 1)] : [state setC:(prev & 0b11111110)];
            [state setFlags:[state getC] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RL C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, prev, [state getC]);
            break;
        case 2:
            // RL D -- Rotate D left through C-flag
            prev = [state getD] << 1;
            C = (bool)([state getD] & 0b10000000);
            // Set LSb of D to its previous C-value
            [state getCFlag] ? [state setD:(prev | 1)] : [state setD:(prev & 0b11111110)];
            [state setFlags:[state getD] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RL D -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, prev, [state getD]);
            break;
        case 3:
            // RL E -- Rotate E left through C-flag
            prev = [state getE] << 1;
            C = (bool)([state getE] & 0b10000000);
            // Set LSb of E to its previous C-value
            [state getCFlag] ? [state setE:(prev | 1)] : [state setE:(prev & 0b11111110)];
            [state setFlags:[state getE] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RL E -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, prev, [state getE]);
            break;
        case 4:
            // RL H -- Rotate H left through C-flag
            prev = [state getH] << 1;
            C = (bool)([state getH] & 0b10000000);
            // Set LSb of H to its previous C-value
            [state getCFlag] ? [state setH:(prev | 1)] : [state setH:(prev & 0b11111110)];
            [state setFlags:[state getH] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RL H -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, prev, [state getH]);
            break;
        case 5:
            // RL L -- Rotate L left through C-flag
            prev = [state getL] << 1;
            C = (bool)([state getL] & 0b10000000);
            // Set LSb of L to its previous C-value
            [state getCFlag] ? [state setL:(prev | 1)] : [state setL:(prev & 0b11111110)];
            [state setFlags:[state getL] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RL L -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, prev, [state getL]);
            break;
        case 6:
            // RL (HL) -- Rotate (HL) left through C-flag
            prev = ram[(unsigned short)[state getHL_big]] << 1;
            C = (bool)([state getC] & 0b10000000);
            // Set LSb of A to its previous C-value
            if ([state getCFlag])
            {
                ram[(unsigned short)[state getHL_big]] = prev | 1;
            }
            else
            {
                ram[(unsigned short)[state getHL_big]] = prev & 0b11111110;
            }
            [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RL (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, prev,
                     ram[(unsigned short)[state getHL_big]]);
            break;
        case 7:
            // RL A -- Rotate A left through C-flag
            prev = [state getA] << 1;
            C = (bool)([state getA] & 0b10000000);
            // Set LSb of A to its previous C-value
            [state getCFlag] ? [state setA:(prev | 1)] : [state setA:(prev & 0b11111110)];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RL A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, prev, [state getA]);
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 0xA:
            
            break;
        case 0xB:
            
            break;
        case 0xC:
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
};