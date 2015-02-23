#import "emulatorMain.h"

void (^execute0x1Instruction)(romState *,
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
    //    int8_t previousButtons = self.buttons;
    switch (currentInstruction & 0x0F) {
        case 0:
            // STOP
            // Wait for button press before changing processor and screen
#warning Figure this out
            //            while ((self.buttons ^ previousButtons) == 0)
            //            {/* Do nothing but wait */}
            PRINTDBG("0x%02x -- STOP\n", currentInstruction);
            break;
        case 1:
            // LD DE, d16 -- Load d16 into DE
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x0ff);
            [state doubleIncPC];
            [state setDE_big:d16];
            PRINTDBG("0x%02x -- LD DE, d16 -- d16 = 0x%02x\n", currentInstruction, d16);
            break;
        case 2:
            // LD (DE), A -- put A into (DE)
            ram[(unsigned short)[state getDE_big]] = [state getA];
            PRINTDBG("0x%02x -- LD (DE), A -- A = %i\n", currentInstruction, (int)[state getA]);
            break;
        case 3:
            // INC DE -- Increment DE
            [state setDE_big:([state getDE_big] + 1)];
            PRINTDBG("0x%02x -- INC DE; DE is now %i\n", currentInstruction, [state getDE_big]);
            break;
        case 4:
            // INC D -- Increment D
            prev = [state getD];
            [state setD:([state getD] + 1)];
            [state setFlags:([state getD] == 0)
                          N:false
                          H:(prev > [state getD])
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- INC D; D is now %i\n", currentInstruction, [state getD]);
            break;
        case 5:
            // DEC D -- Decrement D
            prev = [state getD];
            [state setD:([state getD] - 1)];
            [state setFlags:([state getD] == 0)
                          N:true
                          H:!((char)(prev & 0xf) < (char)((([state getD] & 0xf) & 0xf)))
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- DEC D; D was %i; D is now %i\n", currentInstruction, prev, [state getD]);
            break;
        case 6:
            // LD D, d8 -- load 8-bit immediate value into D
            d8 = ram[[state getPC]];
            [state incrementPC];
            [state setD:d8];
            PRINTDBG("0x%02x -- LD D, d8 -- d8 = %i\n", currentInstruction, (int)d8);
            break;
        case 7:
            // RLA -- Rotate A left through carry flag -- Does this mean take previous C value for A[0]? Else, what's
            // the difference between it and the RLCA instruction?
            A = [state getA];
            temp = [state getCFlag];
            C = (bool)([state getA] & 0b10000000);
            [state setA:([state getA] << 1)];
            // Set LSb of A to its previous C-value
            temp ? [state setA:([state getA] | 1)] :
            [state setA:([state getA] & 0b11111110)];
            [state setFlags:false
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RLA -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, A, [state getA]);
            break;
        case 8:
            // JR r8 (8-bit signed data, added to PC)
            d8 = ram[[state getPC]];
            [state incrementPC];
            [state addToPC:d8];
            PRINTDBG("0x%02x -- JR r8 (r8 = %d) -- PC is now 0x%02x\n", currentInstruction, (int)d8, [state getPC]);
            *incrementPC = false;
            break;
        case 9:
            // ADD HL,DE -- add DE to HL
            // H = carry from bit 11; C = carry from bit 15; reset N; leave Z alone
            prev = [state getHL_little] & 0xf;
            prev_short = [state getHL_big];
            [state setHL_big:([state getDE_big]+[state getHL_big])];
            Z = [state getZFlag];
            C = (unsigned short)prev_short > (unsigned short)[state getHL_big];
            H = prev_short > [state getHL_big];
            [state setFlags:Z
                          N:false
                          H:H
                          C:C];
            PRINTDBG("0x%02x -- ADD HL,DE -- add DE (%i) and HL (%i) = %i\n", currentInstruction, \
                     [state getDE_big], prev_short, [state getHL_big]);
            break;
        case 0xA:
            // LD A,(DE) - load (DE) into A
            [state setA:(ram[(unsigned short)[state getDE_big]])];
            PRINTDBG("0x%02x -- LD A,(DE) -- load (DE == 0x%04x) = 0x%02x into A\n", currentInstruction, \
                     [state getDE_big] & 0xffff, ram[(unsigned short)[state getDE_big]] & 0xff);
            break;
        case 0xB:
            // DEC DE -- Decrement DE
            prev_int = [state getDE_big];
            [state setDE_big:([state getDE_big] - 1)];
            PRINTDBG("0x%02x -- DEC DE -- DE was %i; DE is now %i\n", currentInstruction, \
                     prev_int, [state getDE_big]);
            break;
        case 0xC:
            // INC E -- Increment E
            prev = [state getE];
            [state setE:([state getE] + 1)];
            [state setFlags:([state getE] == 0)
                          N:false
                          H:(prev > [state getE])
                          C:([state getCFlag])];
            PRINTDBG("0x%02x -- INC E; E = %i\n", currentInstruction, [state getE]);
            break;
        case 0xD:
            // DEC E -- Decrement E
            prev = [state getE];
            [state setE:([state getE] - 1)];
            Z = [state getE] == 0;
            H = !((char)(prev & 0xf) < (char)((([state getE] & 0xf) & 0xf)));
            [state setFlags:Z
                          N:true
                          H:H
                          C:[state getCFlag]];
            PRINTDBG("0x%02x -- DEC E -- E was %i; E is now %i\n", currentInstruction, \
                     prev, (int)[state getE]);
            break;
        case 0xE:
            // LD E,d8 -- Load immediate 8-bit data into E
            d8 = ram[[state getPC]];
            [state incrementPC];
            [state setE:d8];
            PRINTDBG("0x%02x -- LD E, d8 -- d8 = %i\n", currentInstruction, (short)d8);
            break;
        case 0xF:
            // RRA -- Rotate accumulator right through carry flag
            A = [state getA];
            temp = [state getCFlag];
            C = (bool)([state getA] & 0b00000001);
            [state setA:([state getA] >> 1)];
            // Set MSb of A to its previous C-value
            temp ? [state setA:([state getA] | 0b10000000)] :
            [state setA:([state getA] & 0b01111111)];
            [state setFlags:false
                          N:false
                          H:false
                          C:C];
            PRINTDBG("0x%02x -- RRA -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, A, [state getA]);
            break;
    }
};

