#import "emulatorMain.h"


void (^execute0xcb5Instruction)(romState *,
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
    bool Z = false;
    switch (currentInstruction & 0x0F) {
        case 0:
            // BIT 2,B -- Test bit 2 of B
            Z = (bool)!([state getB] & 0x00000100);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 2,B -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 1:
            // BIT 2,C -- Test bit 2 of C
            Z = (bool)!([state getC] & 0x00000100);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 2,C -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 2:
            // BIT 2,D -- Test bit 2 of D
            Z = (bool)!([state getD] & 0x00000100);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 2,D -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 3:
            // BIT 2,E -- Test bit 2 of E
            Z = (bool)!([state getE] & 0x00000100);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 2,E -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 4:
            // BIT 2,H -- Test bit 2 of H
            Z = (bool)!([state getH] & 0x00000100);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 2,H -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 5:
            // BIT 2,L -- Test bit 2 of L
            Z = (bool)!([state getL] & 0x00000100);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 2,L -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 6:
            // BIT 2,(HL) -- Test bit 2 of (HL)
            Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00000100);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 2,(HL) -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 7:
            // BIT 2,A -- Test bit 2 of A
            Z = (bool)!([state getA] & 0x00000100);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 2,A -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 8:
            // BIT 3,B -- Test bit 3 of B
            Z = (bool)!([state getB] & 0x00001000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 3,B -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 9:
            // BIT 3,C -- Test bit 3 of C
            Z = (bool)!([state getC] & 0x00001000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 3,C -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xA:
            // BIT 3,D -- Test bit 3 of D
            Z = (bool)!([state getD] & 0x00001000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 3,D -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xB:
            // BIT 3,E -- Test bit 3 of E
            Z = (bool)!([state getE] & 0x00001000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 3,E -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xC:
            // BIT 3,H -- Test bit 3 of H
            Z = (bool)!([state getH] & 0x00001000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 3,H -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xD:
            // BIT 3,L -- Test bit 3 of L
            Z = (bool)!([state getL] & 0x00001000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 3,L -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xE:
            // BIT 3,(HL) -- Test bit 3 of (HL)
            Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00001000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 3,(HL) -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xF:
            // BIT 3,A -- Test bit 3 of A
            Z = (bool)!([state getA] & 0x00001000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 3,A -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
    }
};