#import "emulatorMain.h"


void (^execute0xcb4Instruction)(romState *,
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
            // BIT 0,B -- Test bit 0 of B
            Z = (bool)!([state getB] & 0x00000001);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 1:
            // BIT 0,C -- Test bit 0 of C
            Z = (bool)!([state getC] & 0x00000001);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 2:
            // BIT 0,D -- Test bit 0 of D
            Z = (bool)!([state getD] & 0x00000001);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 3:
            // BIT 0,E -- Test bit 0 of E
            Z = (bool)!([state getE] & 0x00000001);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 4:
            // BIT 0,H -- Test bit 0 of H
            Z = (bool)!([state getH] & 0x00000001);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 5:
            // BIT 0,L -- Test bit 0 of L
            Z = (bool)!([state getL] & 0x00000001);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 6:
            // BIT 0,(HL) -- Test bit 0 of (HL)
            Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00000001);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 7:
            // BIT 0,A -- Test bit 0 of A
            Z = (bool)!([state getA] & 0x00000001);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 8:
            // BIT 1,B -- Test bit 1 of B
            Z = (bool)!([state getB] & 0x00000010);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 9:
            // BIT 1,C -- Test bit 1 of C
            Z = (bool)!([state getC] & 0x00000010);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 0xA:
            // BIT 1,D -- Test bit 1 of D
            Z = (bool)!([state getD] & 0x00000010);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 0xB:
            // BIT 1,E -- Test bit 1 of E
            Z = (bool)!([state getE] & 0x00000010);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 0xC:
            // BIT 1,H -- Test bit 1 of H
            Z = (bool)!([state getH] & 0x00000010);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 0xD:
            // BIT 1,L -- Test bit 1 of L
            Z = (bool)!([state getL] & 0x00000010);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 0xE:
            // BIT 1,(HL) -- Test bit 1 of (HL)
            Z = (bool)!(ram[(unsigned short)[state getHL_big]] & 0x00000010);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
        case 0xF:
            // BIT 1,A -- Test bit 1 of A
            Z = (bool)!([state getA] & 0x00000010);
            [state setFlags:Z
                          N:false
                          H:true
                          C:[state getCFlag]];
            break;
    }
};