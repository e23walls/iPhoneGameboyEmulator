#import "emulatorMain.h"

void (^execute0x8Instruction)(romState *,
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
    int8_t d8 = 0;
    short prev_short = 0;
    bool C = false;
    bool H = false;
    switch (currentInstruction & 0x0F) {
        case 0:
            // ADD A,B -- Add B to A
            prev = [state getA];
            [state setA:([state getA] + [state getB])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                          N:false
                          H:H // carry from bit 3
                          C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,B -- add A (%i) and B (%i) = %i\n", currentInstruction, \
                     prev, [state getB], [state getA]);
            break;
        case 1:
            // ADD A,C -- Add C to A
            prev = [state getA];
            [state setA:([state getA] + [state getC])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                          N:false
                          H:H // carry from bit 3
                          C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,C -- add A (%i) and C (%i) = %i\n", currentInstruction, \
                     prev, [state getC], [state getA]);
            break;
        case 2:
            // ADD A,D -- Add D to A
            prev = [state getA];
            [state setA:([state getA] + [state getD])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                          N:false
                          H:H // carry from bit 3
                          C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,D -- add A (%i) and D (%i) = %i\n", currentInstruction, \
                     prev, [state getD], [state getA]);
            break;
        case 3:
            // ADD A,E -- Add E to A
            prev = [state getA];
            [state setA:([state getA] + [state getE])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                          N:false
                          H:H // carry from bit 3
                          C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,E -- add A (%i) and E (%i) = %i\n", currentInstruction, \
                     prev, [state getE], [state getA]);
            break;
        case 4:
            // ADD A,H -- Add H to A
            prev = [state getA];
            [state setA:([state getA] + [state getH])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                          N:false
                          H:H // carry from bit 3
                          C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,H -- add A (%i) and H (%i) = %i\n", currentInstruction, \
                     prev, [state getH], [state getA]);
            break;
        case 5:
            // ADD A,L -- Add L to A
            prev = [state getA];
            [state setA:([state getA] + [state getL])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                          N:false
                          H:H // carry from bit 3
                          C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,L -- add A (%i) and L (%i) = %i\n", currentInstruction, \
                     prev, [state getL], [state getA]);
            break;
        case 6:
            // ADD A,(HL) -- Add (HL) to A
            prev = [state getA];
            d8 = ram[(unsigned short)[state getHL_big]];
            [state setA:([state getA] + d8)];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                          N:false
                          H:H // carry from bit 3
                          C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,(HL) -- add A (%i) and (HL) (%i) = %i\n", currentInstruction, \
                     prev, d8, [state getA]);
            break;
        case 7:
            // ADD A,A -- Add A to A
            prev = [state getA];
            prev_short = [state getA];
            [state setA:(2 * [state getA])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                          N:false
                          H:H // carry from bit 3
                          C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,A -- add A (%i) and A (%i) = %i\n", currentInstruction, \
                     prev, prev, [state getA]);
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