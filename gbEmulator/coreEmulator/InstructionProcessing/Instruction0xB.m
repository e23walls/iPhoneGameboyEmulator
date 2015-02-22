#import "emulatorMain.h"


void (^execute0xBInstruction)(romState *,
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
            // OR B -- A <- A | B
            prev = [state getA];
            [state setA:([state getA] | [state getB])];
            [state setFlags:([state getA] == 0)
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- OR B -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
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
            // OR A -- A = A | A
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- OR A -- Why?\n", currentInstruction);
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