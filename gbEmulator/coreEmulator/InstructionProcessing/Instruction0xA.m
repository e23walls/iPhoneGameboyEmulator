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
    int8_t d8 = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // AND B -- A <- A & B
            prev = [state getA];
            [state setA:([state getA] & [state getB])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:true
                          C:false];
            PRINTDBG("0x%02x -- AND B -- A was 0x%02x; A is now 0x%02x; B = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getB] & 0xff);
            break;
        case 1:
            // AND C -- A <- A & C
            prev = [state getA];
            [state setA:([state getA] & [state getC])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:true
                          C:false];
            PRINTDBG("0x%02x -- AND C -- A was 0x%02x; A is now 0x%02x; C = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getC] & 0xff);
            break;
        case 2:
            // AND D -- A <- A & D
            prev = [state getA];
            [state setA:([state getA] & [state getD])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:true
                          C:false];
            PRINTDBG("0x%02x -- AND D -- A was 0x%02x; A is now 0x%02x; D = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getD] & 0xff);
            break;
        case 3:
            // AND E -- A <- A & E
            prev = [state getA];
            [state setA:([state getA] & [state getE])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:true
                          C:false];
            PRINTDBG("0x%02x -- AND E -- A was 0x%02x; A is now 0x%02x; E = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getE] & 0xff);
            break;
        case 4:
            // AND H -- A <- A & H
            prev = [state getA];
            [state setA:([state getA] & [state getH])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:true
                          C:false];
            PRINTDBG("0x%02x -- AND H -- A was 0x%02x; A is now 0x%02x; H = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getH] & 0xff);
            break;
        case 5:
            // AND L -- A <- A & L
            prev = [state getA];
            [state setA:([state getA] & [state getL])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:true
                          C:false];
            PRINTDBG("0x%02x -- AND L -- A was 0x%02x; A is now 0x%02x; L = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getL] & 0xff);
            break;
        case 6:
            // AND (HL) -- A <- A & (HL)
            d8 = ram[(unsigned short)[state getHL_big]];
            prev = [state getA];
            [state setA:([state getA] & d8)];
            [state setFlags:[state getA] == 0
                          N:false
                          H:true
                          C:false];
            PRINTDBG("0x%02x -- AND (HL) -- A was 0x%02x; A is now 0x%02x; HL = 0x%02x; (HL) = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getHL_big] & 0xffff, d8 & 0xff);
            break;
        case 7:
            // AND A -- A <- A & A (so, only changes the flags)
            prev = [state getA];
            [state setFlags:[state getA] == 0
                          N:false
                          H:true
                          C:false];
            PRINTDBG("0x%02x -- AND A -- A is 0x%02x\n", currentInstruction, [state getA] & 0xff);
            break;
        case 8:
            // XOR B -- A <- A ^ B
            prev = [state getA];
            [state setA:([state getA] ^ [state getB])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- XOR B -- A was 0x%02x; A is now 0x%02x; B = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getB] & 0xff);
            break;
        case 9:
            // XOR C -- A <- A ^ C
            prev = [state getA];
            [state setA:([state getA] ^ [state getC])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- XOR C -- A was 0x%02x; A is now 0x%02x; C = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getC] & 0xff);
            break;
        case 0xA:
            // XOR D -- A <- A ^ D
            prev = [state getA];
            [state setA:([state getA] ^ [state getD])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- XOR D -- A was 0x%02x; A is now 0x%02x; D = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getD] & 0xff);
            break;
        case 0xB:
            // XOR E -- A <- A ^ E
            prev = [state getA];
            [state setA:([state getA] ^ [state getE])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- XOR E -- A was 0x%02x; A is now 0x%02x; E = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getE] & 0xff);
            break;
        case 0xC:
            // XOR H -- A <- A ^ H
            prev = [state getA];
            [state setA:([state getA] ^ [state getH])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- XOR H -- A was 0x%02x; A is now 0x%02x; H = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getH] & 0xff);
            break;
        case 0xD:
            // XOR L -- A <- A ^ L
            prev = [state getA];
            [state setA:([state getA] ^ [state getL])];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- XOR L -- A was 0x%02x; A is now 0x%02x; L = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getL] & 0xff);
            break;
        case 0xE:
            // XOR (HL) -- A <- A ^ (HL)
            d8 = ram[(unsigned short)[state getHL_big]];
            prev = [state getA];
            [state setA:([state getA] ^ d8)];
            [state setFlags:[state getA] == 0
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- XOR (HL) -- A was 0x%02x; A is now 0x%02x; HL = 0x%02x; (HL) = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], [state getHL_big] & 0xffff, d8 & 0xff);
            break;
        case 0xF:
            // XOR A -- A <- A ^ A
            prev = [state getA];
            [state setA:0];
            [state setFlags:([state getA] == 0)
                          N:false
                          H:false
                          C:false];
            PRINTDBG("0x%02x -- XOR A -- A is now 0x00\n", currentInstruction);
            break;
    }
};