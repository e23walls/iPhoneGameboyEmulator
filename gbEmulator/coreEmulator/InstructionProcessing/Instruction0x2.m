#import "emulatorMain.h"

void (^execute0x2Instruction)(romState *,
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
    unsigned short d16 = 0;
    int8_t d8 = 0;
    bool Z = true;
    bool H = true;
    bool C = true;
    switch (currentInstruction & 0x0F) {
        case 0:
            // JR NZ,r8 -- If !Z, add r8 to PC
            d8 = ram[[state getPC]];
            if ([state getZFlag] == false)
            {
                [state addToPC:d8];
            }
            [state incrementPC];
            PRINTDBG("0x%02x -- JR NZ, r8 -- if !Z, PC += %i; PC is now 0x%02x\n", currentInstruction, (int8_t)d8,
                     [state getPC]);
            *incrementPC =false;
            break;
        case 1:
            // LD HL,d16 -- Load d16 into HL
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x0ff);
            [state incrementPC];
            [state incrementPC];
            [state setHL_big:d16];
            PRINTDBG("0x%02x -- LD HL, d16 -- d16 = 0x%02x; HL = 0x%02x\n", currentInstruction, d16, \
                     [state getHL_big]);
            break;
        case 2:
            // LD (HL+),A -- Put A into (HL), and increment HL
            ram[(unsigned short)[state getHL_big]] = [state getA];
            [state setHL_big:([state getHL_big] + 1)];
            PRINTDBG("0x%02x -- LD (HL+),A -- HL = 0x%02x; (HL) = 0x%02x; A = %i\n", currentInstruction,
                     [state getHL_big], ram[(unsigned short)[state getHL_big]],
                     [state getA]);
            break;
        case 3:
            // INC HL -- Increment HL
            [state setHL_big:([state getHL_big] + 1)];
            PRINTDBG("0x%02x -- INC HL; HL is now %i\n", currentInstruction, [state getHL_big]);
            break;
        case 4:
            // INC H -- Increment H
            prev = [state getH];
            [state setH:([state getH] + 1)];
            [state setFlags:([state getH] == 0)
                          N:false
                          H:(prev > [state getH])
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- INC H; H is now %i\n", currentInstruction, [state getH]);
            break;
        case 5:
            // DEC H -- Decrement H
            prev = [state getH];
            [state setH:((int8_t)([state getH] - 1))];
            [state setFlags:([state getH] == 0)
                          N:true
                          H:!((char)(prev & 0xf) < (char)((([state getH] & 0xf) & 0xf)))
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- DEC H; H was %i; H is now %i\n", currentInstruction, prev, [state getH]);
            break;
        case 6:
            // LD H,d8 -- Load 8-bit immediate data into H
            d8 = ram[[state getPC]];
            [state setH:d8];
            [state incrementPC];
            PRINTDBG("0x%02x -- LD H, d8 -- d8 = %i\n", currentInstruction, (int)d8);
            break;
        case 7:
            // DAA -- Decimal adjust register A; adjust A so that correct BCD obtained
#warning Do this eventually!!!
            PRINTDBG("0x%02x - DAA -- this needs to be done sometime\n", currentInstruction);
            break;
        case 8:
            // JR Z,r8 -- If Z, add r8 to PC
            d8 = ram[[state getPC]];
            [state incrementPC];
            if ([state getZFlag])
            {
                [state addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR Z, r8 -- if Z, PC += %i; PC is now 0x%02x\n", currentInstruction,
                     (int8_t)d8, [state getPC]);
            *incrementPC =false;
            break;
        case 9:
            // ADD HL,HL -- Add HL to HL
            prev = [state getHL_little] & 0xf;
            prev_short = [state getHL_big];
            [state setHL_big:(2 * [state getHL_big])];
            Z = [state getZFlag];
            C = (unsigned short)prev_short > (unsigned short)[state getHL_big];
            H = prev_short > [state getHL_big];
            [state setFlags:Z
                          N:false
                          H:H
                          C:C];
            PRINTDBG("0x%02x -- ADD HL,HL -- add HL (%i) to itself = %i\n", currentInstruction, \
                     prev_short, [state getHL_big]);
            break;
        case 0xA:
            // LD A,(HL+) -- Put value at address at HL, (HL), into A, and increment HL
            [state setA:ram[(unsigned short)[state getHL_big]]];
            [state setHL_big:([state getHL_big]+1)];
            PRINTDBG("0x%02x -- LD A,(HL+) -- HL is now 0x%02x; A = 0x%02x\n", currentInstruction, \
                     [state getHL_big], [state getA]);
            break;
        case 0xB:
            // DEC HL -- Decrement HL
            prev_int = [state getHL_big];
            [state setHL_big:([state getHL_big] - 1)];
            PRINTDBG("0x%02x -- DEC HL -- HL was %i; HL is now %i\n", currentInstruction, \
                     prev_int, [state getHL_big]);
            break;
        case 0xC:
            // INC L -- Increment L
            prev = [state getL];
            [state setL:([state getL] + 1)];
            [state setFlags:([state getL] == 0)
                          N:false
                          H:(prev > [state getL])
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- INC L; L is now %i\n", currentInstruction, [state getL]);
            break;
        case 0xD:
            // DEC L -- Decrement L
            prev = [state getL];
            [state setL:([state getL] - 1)];
            Z = [state getL] == 0;
            H = !((char)(prev & 0xf) < (char)((([state getL] & 0xf) & 0xf)));
            [state setFlags:Z
                          N:true
                          H:H
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- DEC L -- L was %i; L is now %i\n", currentInstruction, \
                     prev, (int)[state getL]);
            break;
        case 0xE:
            // LD L,d8 -- Load 8-bit immediate data into L
            d8 = ram[[state getPC]];
            [state incrementPC];
            [state setL:d8];
            PRINTDBG("0x%02x -- LD L, d8 -- d8 = %i\n", currentInstruction, (short)d8);
            break;
        case 0xF:
            // CPL -- Complement A
            prev = [state getA];
            [state setA:([state getA] ^ 0xff)];
            [state setFlags:[state getZFlag]
                          N:true
                          H:true
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- CPL A -- A was %i; A is now %i\n", currentInstruction, prev, [state getA]);
            break;
    }
};

