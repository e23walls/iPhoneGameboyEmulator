#import "emulatorMain.h"

void (^execute0x0Instruction)(romState *,
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
    int prev_int = 0;
    short prev_short = 0;
    int8_t A = 0;
    unsigned short d16 = 0;
    int8_t d8 = 0;
    bool Z = true;
    bool H = true;
    bool C = true;
    bool temp = true;
    switch (currentInstruction & 0x0F) {
        case 0:
            // No-op
            PRINTDBG("0x%02x -- no-op\n", currentInstruction);
            break;
        case 1:
            // LD BC, d16 -- Load 16-bit data into registers BC
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x00ff);
            [state incrementPC];
            [state incrementPC];
            [state setBC_big:d16];
            PRINTDBG("0x%02x -- LD BC, d16 -- d16 = %i\n", currentInstruction, d16);
            break;
        case 2:
            // LD BC, A -- Load A into (BC)
            // Cast to unsigned short for case where the number is negative, since it should
            // be interpreted unsigned, but becomes too large a value. -1 should be interpreted as RAMSIZE-1
            ram[(unsigned short)[state getBC_big]] = [state getA];
            PRINTDBG("0x%02x -- LD (BC), A -- A is now %d\n", currentInstruction, [state getA]);
            break;
        case 3:
            // INC BC -- increment BC
            [state setBC_big:([state getBC_big] + 1)];
            PRINTDBG("0x%02x -- INC BC; BC is now %i\n", currentInstruction, [state getBC_big]);
            break;
        case 4:
            // INC B -- increment B and set flags
            prev = [state getB];
            [state setB:([state getB] + 1)];
            [state setFlags:([state getB] == 0)
                          N:false
             // (If positive number becomes negative number)
                          H:(prev > [state getB])
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- INC B; B is now %i\n", currentInstruction, [state getB]);
            break;
        case 5:
            // DEC B -- decrement B and set flags
            prev = [state getB];
            [state setB:([state getB] - 1)];
            [state setFlags:([state getB] == 0)
                          N:true
                          H:!((char)(prev & 0xf) < (char)((([state getB] & 0xf) & 0xf)))
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- DEC B; B was %i; B is now %i\n", currentInstruction, prev, [state getB]);
            break;
        case 6:
            // LD B, d8 -- load following 8-bit data into B
            d8 = ram[[state getPC]];
            [state incrementPC];
            [state setB:d8];
            PRINTDBG("0x%02x -- LD B, d8 -- d8 = %i\n", currentInstruction, (int)d8);
            break;
        case 7:
            // RLCA -- Rotate A left; C = bit 7, A'[0] = A[7]
            A = [state getA];
            C = (bool)([state getA] & 0b10000000);
            [state setA:([state getA] << 1)];
            // Set LSb of A to its previous MSb
            C ? [state setA:([state getA] | 1)] :
            [state setA:([state getA] & 0b11111110)];
            Z = [state getA] == 0;
            [state setFlags:false
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RLCA -- A was %02x; A is now %02x\n", currentInstruction, A, [state getA]);
            break;
        case 8:
            // LD (a16), SP -- put (SP) at address a16
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
            [state incrementPC];
            [state incrementPC];
            prev_short =  (ram[(unsigned short)(d16+1)] << 8) | (ram[(unsigned short)d16] & 0x0ff);
            ram[(unsigned short)d16] = ram[(unsigned short)([state getSP]+1)];
            ram[(unsigned short)(d16+1)] = ram[[state getSP]];
            PRINTDBG("0x%02x -- LD (a16), SP -- put (SP = 0x%02x) at [d16 = 0x%02x] -- [SP] is 0x%02x -- [d16] was 0x%02x; now 0x%02x\n", currentInstruction, [state getSP], d16,
                     (ram[[state getSP]] & 0x0ff) | (ram[[state getSP]+1] << 8),
                     prev_short, (ram[(unsigned short)(d16+1)] & 0x0ff) | (ram[(unsigned short)d16] << 8));
            break;
        case 9:
            // ADD HL,BC -- add BC to HL
            // H == carry from bit 11
            // C == carry from bit 15
            prev_short = [state getHL_big];
            [state setHL_big:([state getBC_big]+[state getHL_big])];
            Z = [state getZFlag];
            C = (unsigned short)prev_short > (unsigned short)[state getHL_big];
            H = prev_short > [state getHL_big];
            [state setFlags:Z
                          N:false
                          H:H
                          C:C];
            PRINTDBG("0x%02x -- ADD HL,BC -- add BC (%i) and HL (%i) = %i\n", currentInstruction, \
                     [state getBC_big], prev_short, [state getHL_big]);
            break;
        case 0xA:
            // LD A,(BC) -- load (BC) into A
            [state setA:ram[(unsigned short)[state getBC_big]]];
            PRINTDBG("0x%02x -- LD A,(BC) -- load (BC == %i -> %i) into A\n", currentInstruction, \
                     [state getBC_big], (int)ram[(unsigned short)[state getBC_big]]);
            break;
        case 0xB:
            // DEC BC -- decrement BC
            prev_int = [state getBC_big];
            [state setBC_big:([state getBC_big] - 1)];
            PRINTDBG("0x%02x -- DEC BC -- BC was %i; BC is now %i\n", currentInstruction, \
                     prev_int, [state getBC_big]);
            break;
        case 0xC:
            // INC C -- increment C
            prev = [state getC];
            [state setC:([state getC] + 1)];
            Z = [state getC] == 0;
            H = [state getC] < prev;
            [state setFlags:Z
                          N:false
                          H:H
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- INC C -- C was %i; C is now %i\n", currentInstruction, \
                     prev, (int)[state getC]);
            break;
        case 0xD:
            // DEC C -- decrement C
            prev = [state getC];
            [state setC:([state getC] - 1)];
            Z = [state getC] == 0;
            H = !((char)(prev & 0xf) < (char)((([state getC] & 0xf) & 0xf)));
            [state setFlags:Z
                          N:true
                          H:H
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- DEC C -- C was %i; C is now %i\n", currentInstruction, \
                     prev, (int)[state getC]);
            break;
        case 0xE:
            // LD C, d8 -- load immediate 8-bit data into C
            d8 = ram[[state getPC]];
            [state incrementPC];
            [state setC:d8];
            PRINTDBG("0x%02x -- LD C, d8 -- d8 = %i\n", currentInstruction, (short)d8);
            break;
        case 0xF:
            // RRCA -- rotate A right
            A = [state getA];
            temp = [state getCFlag];
            C = (bool)([state getA] & 0b00000001);
            [state setA:([state getA] >> 1)];
            // Set MSb of A to its previous LSb
            C ? [state setA:([state getA] | 0b10000000)] :
            [state setA:([state getA] & 0b01111111)];
            [state setFlags:false
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RRCA -- A was %02x; A is now %02x\n", currentInstruction, A, [state getA]);
            break;
    }
};

