#import "emulatorMain.h"


void (^execute0xcb6Instruction)(romState *,
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
            // BIT 4,B -- Test bit 4 of B
            Z = (bool)!([state getB] & 0x00010000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 4,B -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 1:
            // BIT 4,C -- Test bit 4 of C
            Z = (bool)!([state getC] & 0x00010000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 4,C -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 2:
            // BIT 4,D -- Test bit 4 of D
            Z = (bool)!([state getD] & 0x00010000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 4,D -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 3:
            // BIT 4,E -- Test bit 4 of E
            Z = (bool)!([state getE] & 0x00010000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 4,E -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 4:
            // BIT 4,H -- Test bit 4 of H
            Z = (bool)!([state getH] & 0x00010000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 4,H -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 5:
            // BIT 4,L -- Test bit 4 of L
            Z = (bool)!([state getL] & 0x00010000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 4,L -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 6:
            // BIT 4,(HL) -- Test bit 4 of (HL)
            Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00010000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 4,(HL) -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 7:
            // BIT 4,A -- Test bit 4 of A
            Z = (bool)!([state getA] & 0x00010000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 4,A -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 8:
            // BIT 5,B -- Test bit 5 of B
            Z = (bool)!([state getB] & 0x00100000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 5,B -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 9:
            // BIT 5,C -- Test bit 5 of C
            Z = (bool)!([state getC] & 0x00100000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 5,C -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xA:
            // BIT 5,D -- Test bit 5 of D
            Z = (bool)!([state getD] & 0x00100000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 5,D -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xB:
            // BIT 5,E -- Test bit 5 of E
            Z = (bool)!([state getE] & 0x00100000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 5,E -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xC:
            // BIT 5,H -- Test bit 5 of H
            Z = (bool)!([state getH] & 0x00100000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 5,H -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xD:
            // BIT 5,L -- Test bit 5 of L
            Z = (bool)!([state getL] & 0x00100000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 5,L -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xE:
            // BIT 5,(HL) -- Test bit 5 of (HL)
            Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00100000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 5,(HL) -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
        case 0xF:
            // BIT 5,A -- Test bit 5 of A
            Z = (bool)!([state getA] & 0x00100000);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- BIT 5,A -- Z is now %i\n", currentInstruction, [state getZFlag]);
            break;
    }
};