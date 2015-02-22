#import "emulatorMain.h"

void (^execute0x3Instruction)(romState *,
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
            // JR NC,r8 -- If !C, add 8-bit immediate data to PC
            d8 = ram[[state getPC]];
            [state incrementPC];
            if (![state getCFlag])
            {
                [state addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR NC, r8 -- if !C, PC += %i; PC is now 0x%02x\n", currentInstruction,
                     (int8_t)d8, [state getPC]);
            *incrementPC =false;
            break;
        case 1:
            // LD SP,d16 -- load immediate 16-bit data into SP
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x0ff);
            [state incrementPC];
            [state incrementPC];
            [state setSP:d16];
            PRINTDBG("0x%02x -- LD SP, d16 -- d16 = %i\n", currentInstruction, d16);
            break;
        case 2:
            // LD (HL-),A -- put A into (HL), and decrement HL
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getA];
            [state setHL_big:([state getHL_big] - 1)];
            PRINTDBG("0x%02x -- LD (HL-),A -- HL-1 = 0x%02x; (HL) was 0x%02x; (HL) = 0x%02x; A = 0x%02x\n", currentInstruction,
                     [state getHL_big], prev,
                     ram[(unsigned short)[state getHL_big]+1], [state getA]);
            break;
        case 3:
            // INC SP -- Increment SP
            [state setSP:([state getSP] + 1)];
            PRINTDBG("0x%02x -- INC SP; SP is now 0x%02x\n", currentInstruction, [state getSP] & 0xffff);
            break;
        case 4:
            // INC (HL) -- Increment (HL)
            prev = ram[[state getHL_big]];
            ram[[state getHL_big]] += 1;
            [state setFlags:(ram[(unsigned short)[state getHL_big]] == 0)
                          N:false
                          H:(prev > ram[(unsigned short)[state getHL_big]])
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- INC (HL); (HL) is now %i\n", currentInstruction, ram[[state getHL_big]]);
            break;
        case 5:
            // DEC (HL) -- Decrement (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] -= 1;
            [state setFlags:(ram[(unsigned short)[state getHL_big]] == 0)
                          N:true
                          H:!((char)(prev & 0xf) < (char)(((ram[(unsigned short)[state getHL_big]] & 0xf) & 0xf)))
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- DEC (HL); (HL) was %i; (HL) is now %i\n", currentInstruction, prev,
                     ram[(unsigned short)[state getHL_big]]);
            break;
        case 6:
            // LD (HL),d8 -- Load 8-bit immediate data into (HL)
            d8 = ram[[state getPC]];
            [state incrementPC];
            ram[(unsigned short)[state getHL_big]] = d8;
            PRINTDBG("0x%02x -- LD (HL), d8 -- d8 = 0x%02x\n", currentInstruction, (int)d8);
            break;
        case 7:
            // SCF -- Set carry flag
            [state setFlags:[state getZFlag]
                          N:false
                          H:false
                          C:true];
            PRINTDBG("0x%02x -- SCF\n", currentInstruction);
            break;
        case 8:
            // JR C,r8 -- If C, add 8-bit immediate data to PC
            d8 = ram[[state getPC]];
            [state incrementPC];
            if ([state getCFlag])
            {
                [state addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR C, r8 -- if C, PC += %i; PC is now 0x%02x\n", currentInstruction,
                     (int8_t)d8, [state getPC]);
            *incrementPC =false;
            break;
        case 9:
            // ADD HL,SP -- Add SP to HL
            // H = carry from bit 11; C = carry from bit 15; reset N; leave Z alone
            prev = [state getHL_little] & 0xf;
            prev_short = [state getHL_big];
            [state setHL_big:([state getSP]+[state getHL_big])];
            Z = [state getZFlag];
            C = (unsigned short)prev_short > (unsigned short)[state getHL_big];
            H = prev_short > [state getHL_big];
            [state setFlags:Z
                          N:false
                          H:H
                          C:C];
            PRINTDBG("0x%02x -- ADD HL,SP -- add SP (%i) and HL (%i) = %i\n", currentInstruction, \
                     [state getSP], prev_short, [state getHL_big]);
            break;
        case 0xA:
            // LD A,(HL-) -- Put value at address at HL, (HL), into A, and decrement HL
            [state setA:ram[(unsigned short)[state getHL_big]]];
            [state setHL_big:([state getHL_big]-1)];
            PRINTDBG("0x%02x -- LD A,(HL-) -- HL is now 0x%02x; A = 0x%02x\n", currentInstruction, \
                     [state getHL_big], [state getA]);
            break;
        case 0xB:
            // DEC SP -- Decrement SP
            prev_int = [state getSP];
            [state setHL_big:([state getSP] - 1)];
            PRINTDBG("0x%02x -- DEC SP -- SP was %i; SP is now %i\n", currentInstruction, \
                     prev_int, [state getSP]);
            break;
        case 0xC:
            // INC A -- Increment A
            prev = [state getA];
            [state setA:([state getA] + 1)];
            [state setFlags:([state getA] == 0)
                          N:false
                          H:(prev > [state getA])
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- INC A; A is now %i\n", currentInstruction, [state getA]);
            break;
        case 0xD:
            // DEC A -- Decrement A
            prev = [state getA];
            [state setA:([state getA] - 1)];
            Z = [state getA] == 0;
            H = !((char)(prev & 0xf) < (char)((([state getA] & 0xf) & 0xf)));
            [state setFlags:Z
                          N:true
                          H:H
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- DEC A -- A was %i; A is now %i\n", currentInstruction, \
                     prev, (int)[state getA]);
            break;
        case 0xE:
            // LD A,d8 -- Load 8-bit immediate data into A
            d8 = ram[[state getPC]];
            [state incrementPC];
            [state setA:d8];
            PRINTDBG("0x%02x -- LD A, d8 -- d8 = %i\n", currentInstruction, (short)d8);
            break;
        case 0xF:
            // CCF -- Complement carry flag
            [state setFlags:[state getZFlag]
                          N:false
                          H:false
                          C:![state getCFlag]];
            PRINTDBG("0x%02x -- CCF\n", currentInstruction);
            break;
    }
};

