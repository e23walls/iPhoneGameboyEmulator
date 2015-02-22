#import "emulatorMain.h"

void (^execute0xcb7Instruction)(romState *,
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
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
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
            // BIT 7,H -- test 7th bit of H register
            [state setFlags:(bool)([state getH] & (int8_t)0b10000000)
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0xCB%02x -- BIT 7,H -- H is 0x%02x -- Z is now %i\n", currentInstruction, \
                     [state getH], [state getZFlag]);
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
};