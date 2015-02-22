#import "emulatorMain.h"


void (^execute0xAInstruction)(romState *,
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
            
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            // XOR A -- A <- A ^ A
            prev = [state getA];
            [state setA:(prev ^ prev)];
            [state setFlags:([state getA] == 0)
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- XOR A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
    }
};