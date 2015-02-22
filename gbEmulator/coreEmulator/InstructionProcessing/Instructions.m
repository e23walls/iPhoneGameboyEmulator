/*
 * Think of these instruction blocks as applying some
 * change to the current state, like an add method
 * would simply add its given input, regardless of which
 * class the inputs were from. Instructions don't need
 * to be seen as methods that only belong to the emulator
 * class. Plus, this makes that class not have a 6000-line
 * implementation file.
 */

#import "emulatorMain.h"

void (^execute0x0Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x1Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x2Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x3Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x4Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x5Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x6Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x7Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x8Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0x9Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xAInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xBInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xCInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xDInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xEInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xFInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbInstruction)(romState *, char *, bool *, int8_t *);
void (^execute0xcb0Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb1Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb2Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb3Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb4Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb5Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb6Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb7Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb8Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcb9Instruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbAInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbBInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbCInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbDInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbEInstruction)(romState *, int8_t, char *, bool *, int8_t *);
void (^execute0xcbFInstruction)(romState *, int8_t, char *, bool *, int8_t *);

#pragma mark - Normal instructions

void (^enableInterrupts)(bool, char *) = ^(bool maybe, char * ram)
{
    if (maybe == true)
    {
        PRINTDBG("Interrupts have been ENabled...\n");
        ram[0x0ffff] = 1;
    }
    else
    {
        PRINTDBG("Interrupts have been DISabled...\n");
        ram[0x0ffff] = 0;
    }
};

void (^setKeysInMemory)(char *, int) = ^(char * ram, int buttons)
{
    if (ram[0xff00] & 0b00100000) // a, b, start, select
    {
        ram[0xff00] |= (buttons & 0b11110000) >> 4;
    }
    else if (ram[0xff00] & 0b00010000) // arrows
    {
        ram[0xff00] |= buttons & 0b00001111;
    }
};

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
            [state incrementPC];
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x00ff);
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
            [state incrementPC];
            d8 = ram[[state getPC]];
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
            [state incrementPC];
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0xff);
            [state incrementPC];
            prev_short =  (ram[(unsigned short)(d16+1)] << 8) | (ram[(unsigned short)d16] & 0x0ff);
            ram[(unsigned short)d16] = ram[(unsigned short)([state getSP]+1)];
            ram[(unsigned short)(d16+1)] = ram[[state getSP]];
            PRINTDBG("0x%02x -- LD (a16), SP -- put (SP = 0x%02x) at [d16 = 0x%02x] -- [SP] is 0x%02x -- [d16] was 0x%02x; now 0x%02x\n", \
                     currentInstruction, [state getSP], d16, \
                     (ram[[state getSP]] & 0x0ff) | (ram[[state getSP]+1] << 8), \
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
            [state incrementPC];
            d8 = ram[[state getPC]];
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
            [state incrementPC];
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x0ff);
            [state incrementPC];
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
            [state incrementPC];
            d8 = ram[[state getPC]];
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
            [state incrementPC];
            d8 = ram[[state getPC]];
            [state addToPC:d8];
            PRINTDBG("0x%02x -- JR r8 (r8 = %d) -- PC is now 0x%02x\n",
                     currentInstruction, (int)d8, [state getPC]);
            *incrementPC =false;
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
            PRINTDBG("0x%02x -- LD A,(DE) -- load (DE == %i -> %i) into A\n", currentInstruction, \
                     [state getDE_big], (int)ram[(unsigned short)[state getDE_big]]);
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
            [state incrementPC];
            d8 = ram[[state getPC]];
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
            PRINTDBG("0x%02x -- RRA -- A was %02x; A is now %02x\n", currentInstruction, A, [state getA]);
            break;
    }
};
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
            [state incrementPC];
            d8 = ram[[state getPC]];
            if ([state getZFlag] == false)
            {
                [state addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR NZ, r8 -- if !Z, PC += %i; PC is now 0x%02x\n",
                     currentInstruction, (int8_t)d8, [state getPC]);
            *incrementPC =false;
            break;
        case 1:
            // LD HL,d16 -- Load d16 into HL
            [state incrementPC];
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x0ff);
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
            [state incrementPC];
            d8 = ram[[state getPC]];
            [state setH:d8];
            PRINTDBG("0x%02x -- LD H, d8 -- d8 = %i\n", currentInstruction, (int)d8);
            break;
        case 7:
            // DAA -- Decimal adjust register A; adjust A so that correct BCD obtained
#warning Do this eventually!!!
            PRINTDBG("0x%02x - DAA -- this needs to be done sometime\n", currentInstruction);
            break;
        case 8:
            // JR Z,r8 -- If Z, add r8 to PC
            [state incrementPC];
            d8 = ram[[state getPC]];
            if ([state getZFlag])
            {
                [state addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR Z, r8 -- if Z, PC += %i; PC is now 0x%02x\n",
                     currentInstruction, (int8_t)d8, [state getPC]);
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
            [state incrementPC];
            d8 = ram[[state getPC]];
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
            [state incrementPC];
            d8 = ram[[state getPC]];
            if (![state getCFlag])
            {
                [state addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR NC, r8 -- if !C, PC += %i; PC is now 0x%02x\n",
                     currentInstruction, (int8_t)d8, [state getPC]);
            *incrementPC =false;
            break;
        case 1:
            // LD SP,d16 -- load immediate 16-bit data into SP
            [state incrementPC];
            d16 = (ram[[state getPC] + 1] << 8) | (ram[[state getPC]] & 0x0ff);
            [state incrementPC];
            [state setSP:d16];
            PRINTDBG("0x%02x -- LD SP, d16 -- d16 = %i\n", currentInstruction, d16);
            break;
        case 2:
            // LD (HL-),A -- put A into (HL), and decrement HL
            ram[(unsigned short)[state getHL_big]] = [state getA];
            [state setHL_big:([state getHL_big] - 1)];
            PRINTDBG("0x%02x -- LD (HL-),A -- HL = 0x%02x; (HL) = 0x%02x; A = 0x%02x\n", currentInstruction,
                     [state getHL_big], ram[(unsigned short)[state getHL_big]],
                     [state getA]);
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
            PRINTDBG("0x%02x -- DEC (HL); (HL) was %i; (HL) is now %i\n",
                     currentInstruction, prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 6:
            // LD (HL),d8 -- Load 8-bit immediate data into (HL)
            [state incrementPC];
            d8 = ram[[state getPC]];
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
            [state incrementPC];
            d8 = ram[[state getPC]];
            if ([state getCFlag])
            {
                [state addToPC:d8];
            }
            PRINTDBG("0x%02x -- JR C, r8 -- if C, PC += %i; PC is now 0x%02x\n",
                     currentInstruction, (int8_t)d8, [state getPC]);
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
            [state incrementPC];
            d8 = ram[[state getPC]];
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
void (^execute0x4Instruction)(romState *,
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
            // LD B,B -- Load B into B (effectively a no-op?)
            PRINTDBG("0x%02x -- LD B,B -- WTH!\n", currentInstruction);
            break;
        case 1:
            // LD B,C -- Load C into B
            prev = [state getB];
            [state setB:[state getC]];
            PRINTDBG("0x%02x -- LD B,C -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 2:
            // LD B,D -- Load D into B
            prev = [state getB];
            [state setB:[state getD]];
            PRINTDBG("0x%02x -- LD B,D -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 3:
            // LD B,E -- Load E into B
            prev = [state getB];
            [state setB:[state getE]];
            PRINTDBG("0x%02x -- LD B,E -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 4:
            // LD B,H -- Load H into B
            prev = [state getB];
            [state setB:[state getH]];
            PRINTDBG("0x%02x -- LD B,H -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 5:
            // LD B,L -- Load L into B
            prev = [state getB];
            [state setB:[state getL]];
            PRINTDBG("0x%02x -- LD B,L -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 6:
            // LD B,(HL) -- Load (HL) into B
            prev = [state getB];
            [state setB:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD B,(HL) -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 7:
            // LD B,A -- Load A into B
            prev = [state getB];
            [state setB:[state getA]];
            PRINTDBG("0x%02x -- LD B,A -- B was 0x%02x; B is now 0x%02x\n", currentInstruction, \
                     prev, [state getB]);
            break;
        case 8:
            // LD C,B -- Load B into C
            prev = [state getC];
            [state setC:[state getB]];
            PRINTDBG("0x%02x -- LD C,B -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 9:
            // LD C,C -- Load C into C -- Again, effectively a no-op
            PRINTDBG("0x%02x -- LD C,C\n", currentInstruction);
            break;
        case 0xA:
            // LD C,D -- Load D into C
            prev = [state getC];
            [state setC:[state getD]];
            PRINTDBG("0x%02x -- LD C,D -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 0xB:
            // LD C,E -- Load E into C
            prev = [state getC];
            [state setC:[state getE]];
            PRINTDBG("0x%02x -- LD C,E -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 0xC:
            // LD C,H -- Load H into C
            prev = [state getC];
            [state setC:[state getH]];
            PRINTDBG("0x%02x -- LD C,H -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 0xD:
            // LD C,L -- Load L into C
            prev = [state getC];
            [state setC:[state getL]];
            PRINTDBG("0x%02x -- LD C,L -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 0xE:
            // LD C,(HL)
            prev = [state getC];
            [state setC:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD C,(HL) -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
        case 0xF:
            // LD C,A -- Load A into C
            prev = [state getC];
            [state setC:[state getA]];
            PRINTDBG("0x%02x -- LD C,A -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, \
                     prev, [state getC]);
            break;
    }
};
void (^execute0x5Instruction)(romState *,
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
            // LD D,B -- Load B into D
            prev = [state getD];
            [state setD:[state getB]];
            PRINTDBG("0x%02x -- LD D,B -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 1:
            // LD D,C -- Load C into D
            prev = [state getD];
            [state setC:[state getB]];
            PRINTDBG("0x%02x -- LD D,C -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 2:
            // LD D,D -- Load D into D -- No-op
            PRINTDBG("0x%02x -- LD D,D\n", currentInstruction);
            break;
        case 3:
            // LD D,E -- Load E into D
            prev = [state getD];
            [state setD:[state getE]];
            PRINTDBG("0x%02x -- LD D,E -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 4:
            // LD D,H -- Load H into D
            prev = [state getD];
            [state setD:[state getH]];
            PRINTDBG("0x%02x -- LD D,H -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 5:
            // LD D,L -- Load L into D
            prev = [state getD];
            [state setD:[state getL]];
            PRINTDBG("0x%02x -- LD D,L -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 6:
            // LD D,(HL) -- Load (HL) into D
            prev = [state getD];
            [state setD:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD D,(HL) -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 7:
            // LD D,A -- Load A into D
            prev = [state getD];
            [state setD:[state getA]];
            PRINTDBG("0x%02x -- LD D,A -- D was 0x%02x; D is now 0x%02x\n", currentInstruction, \
                     prev, [state getD]);
            break;
        case 8:
            // LD E,B -- Load B into E
            prev = [state getE];
            [state setE:[state getB]];
            PRINTDBG("0x%02x -- LD E,B -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 9:
            // LD E,C -- Load C into E
            prev = [state getE];
            [state setE:[state getC]];
            PRINTDBG("0x%02x -- LD E,C -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 0xA:
            // LD E,D -- Load D into E
            prev = [state getE];
            [state setE:[state getD]];
            PRINTDBG("0x%02x -- LD E,D -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 0xB:
            // LD E,E -- Load E into E -- No-op
            prev = [state getE];
            [state setE:[state getB]];
            PRINTDBG("0x%02x -- LD E,E\n", currentInstruction);
            break;
        case 0xC:
            // LD E,H -- Load H into E; A very Canadian instruction
            prev = [state getE];
            [state setE:[state getH]];
            PRINTDBG("0x%02x -- Load, eh? -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 0xD:
            // LD E,L -- Load L into E
            prev = [state getE];
            [state setE:[state getL]];
            PRINTDBG("0x%02x -- LD E,L -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 0xE:
            // LD E,(HL) -- Load (HL) into E
            prev = [state getE];
            [state setE:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD E,(HL) -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
        case 0xF:
            // LD E,A -- Load A into E
            prev = [state getE];
            [state setE:[state getA]];
            PRINTDBG("0x%02x -- LD E,A -- E was 0x%02x; E is now 0x%02x\n", currentInstruction, \
                     prev, [state getE]);
            break;
    }
};
void (^execute0x6Instruction)(romState *,
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
    short prev_short = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // LD H,B -- Load B into H
            prev = [state getH];
            [state setH:[state getB]];
            PRINTDBG("0x%02x -- LD H,B -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 1:
            // LD H,C -- Load C into H
            prev = [state getH];
            [state setH:[state getC]];
            PRINTDBG("0x%02x -- LD H,C -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 2:
            // LD H,D -- Load D into H
            prev = [state getH];
            [state setH:[state getD]];
            PRINTDBG("0x%02x -- LD H,D -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 3:
            // LD H,E -- Load E into H
            prev = [state getH];
            [state setH:[state getE]];
            PRINTDBG("0x%02x -- LD H,E -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 4:
            // LD H,H -- Load H into H -- No-op
            PRINTDBG("0x%02x -- LD H,H\n", currentInstruction);
            break;
        case 5:
            // LD H,L -- Load L into H
            prev = [state getH];
            [state setH:[state getL]];
            PRINTDBG("0x%02x -- LD H,L -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 6:
            // LD H,(HL) -- Load (HL) into H
            prev = [state getH];
            prev_short = [state getHL_big];
            [state setH:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD H,(HL) -- H was 0x%02x; HL was 0x%04x; (HL) was 0x%02x; H is now 0x%02x\n", \
                     currentInstruction, prev & 0xff, prev_short & 0xffff, \
                     ram[(unsigned short)prev_short] & 0xff, [state getH] & 0xff);
            break;
        case 7:
            // LD H,A -- Load A into H
            prev = [state getH];
            [state setH:[state getA]];
            PRINTDBG("0x%02x -- LD H,A -- H was 0x%02x; H is now 0x%02x\n", currentInstruction, \
                     prev, [state getH]);
            break;
        case 8:
            // LD L,B -- Load B into L
            prev = [state getL];
            [state setL:[state getB]];
            PRINTDBG("0x%02x -- LD L,B -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 9:
            // LD L,C -- Load C into L
            prev = [state getL];
            [state setL:[state getC]];
            PRINTDBG("0x%02x -- LD L,C -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 0xA:
            // LD L,D -- Load D into L
            prev = [state getL];
            [state setL:[state getD]];
            PRINTDBG("0x%02x -- LD L,D -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 0xB:
            // LD L,E -- Load E into L
            prev = [state getL];
            [state setL:[state getE]];
            PRINTDBG("0x%02x -- LD L,E -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 0xC:
            // LD L,H -- Load H into L
            prev = [state getL];
            [state setL:[state getH]];
            PRINTDBG("0x%02x -- LD L,H -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 0xD:
            // LD L,L -- Load L into L -- No-op
            PRINTDBG("0x%02x -- LD L,L\n", currentInstruction);
            break;
        case 0xE:
            // LD L,(HL) -- Load (HL) into L
            prev = [state getL];
            [state setL:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD L,(HL) -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
        case 0xF:
            // LD L,A -- Load A into L
            prev = [state getL];
            [state setL:[state getA]];
            PRINTDBG("0x%02x -- LD L,A -- L was 0x%02x; L is now 0x%02x\n", currentInstruction, \
                     prev, [state getL]);
            break;
    }
};
void (^execute0x7Instruction)(romState *,
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
            // LD (HL),B -- Load B into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getB];
            PRINTDBG("0x%02x -- LD (HL),B -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 1:
            // LD (HL),C -- Load C into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getC];
            PRINTDBG("0x%02x -- LD (HL),C -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 2:
            // LD (HL),D -- Load D into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getD];
            PRINTDBG("0x%02x -- LD (HL),D -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 3:
            // LD (HL),E -- Load E into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getE];
            PRINTDBG("0x%02x -- LD (HL),E -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 4:
            // LD (HL),H -- Load H into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getH];
            PRINTDBG("0x%02x -- LD (HL),H -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 5:
            // LD (HL),L -- Load L into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getL];
            PRINTDBG("0x%02x -- LD (HL),L -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 6:
            // HALT -- Power down CPU until interrupt occurs
#warning DO THIS EVENTUALLY!
            PRINTDBG("0x%02x -- HALT\n", currentInstruction);
            break;
        case 7:
            // LD (HL),A -- Load A into (HL)
            prev = ram[(unsigned short)[state getHL_big]];
            ram[(unsigned short)[state getHL_big]] = [state getA];
            PRINTDBG("0x%02x -- LD (HL),A -- (HL) was 0x%02x; (HL) is now 0x%02x\n", currentInstruction, \
                     prev, ram[(unsigned short)[state getHL_big]]);
            break;
        case 8:
            // LD A,B -- Load B into A
            prev = [state getA];
            [state setA:[state getB]];
            PRINTDBG("0x%02x -- LD A,B -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 9:
            // LD A,C -- Load C into A
            prev = [state getA];
            [state setA:[state getC]];
            PRINTDBG("0x%02x -- LD A,C -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xA:
            // LD A,D -- Load D into A
            prev = [state getA];
            [state setA:[state getD]];
            PRINTDBG("0x%02x -- LD A,D -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xB:
            // LD A,E -- Load E into A
            prev = [state getA];
            [state setA:[state getE]];
            PRINTDBG("0x%02x -- LD A,E -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xC:
            // LD A,H -- Load H into A
            prev = [state getA];
            [state setA:[state getH]];
            PRINTDBG("0x%02x -- LD A,H -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xD:
            // LD A,L -- Load L into A
            prev = [state getA];
            [state setA:[state getL]];
            PRINTDBG("0x%02x -- LD A,L -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xE:
            // LD A,(HL) -- Load (HL) into A
            prev = [state getA];
            [state setA:ram[(unsigned short)[state getHL_big]]];
            PRINTDBG("0x%02x -- LD A,(HL) -- A was 0x%02x; A is now 0x%02x\n", currentInstruction, \
                     prev, [state getA]);
            break;
        case 0xF:
            // LD A,A -- Load A into A -- No-op
            PRINTDBG("0x%02x -- LD A,A\n", currentInstruction);
            break;
    }
};
void (^execute0x8Instruction)(romState *,
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
    short prev_short = 0;
    bool C = false;
    bool H = false;
    switch (currentInstruction & 0x0F) {
        case 0:
            // ADD A,B -- Add B to A
            prev = [state getA];
            [state setA:([state getA] + [state getB])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:H // carry from bit 3
                                      C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,B -- add A (%i) and B (%i) = %i\n", currentInstruction, \
                     prev, [state getB], [state getA]);
            break;
        case 1:
            // ADD A,C -- Add C to A
            prev = [state getA];
            [state setA:([state getA] + [state getC])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:H // carry from bit 3
                                      C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,C -- add A (%i) and C (%i) = %i\n", currentInstruction, \
                     prev, [state getC], [state getA]);
            break;
        case 2:
            // ADD A,D -- Add D to A
            prev = [state getA];
            [state setA:([state getA] + [state getD])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:H // carry from bit 3
                                      C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,D -- add A (%i) and D (%i) = %i\n", currentInstruction, \
                     prev, [state getD], [state getA]);
            break;
        case 3:
            // ADD A,E -- Add E to A
            prev = [state getA];
            [state setA:([state getA] + [state getE])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:H // carry from bit 3
                                      C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,E -- add A (%i) and E (%i) = %i\n", currentInstruction, \
                     prev, [state getE], [state getA]);
            break;
        case 4:
            // ADD A,H -- Add H to A
            prev = [state getA];
            [state setA:([state getA] + [state getH])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:H // carry from bit 3
                                      C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,H -- add A (%i) and H (%i) = %i\n", currentInstruction, \
                     prev, [state getH], [state getA]);
            break;
        case 5:
            // ADD A,L -- Add L to A
            prev = [state getA];
            [state setA:([state getA] + [state getL])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:H // carry from bit 3
                                      C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,L -- add A (%i) and L (%i) = %i\n", currentInstruction, \
                     prev, [state getL], [state getA]);
            break;
        case 6:
            // ADD A,(HL) -- Add (HL) to A
            prev = [state getA];
            d8 = ram[(unsigned short)[state getHL_big]];
            [state setA:([state getA] + d8)];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:H // carry from bit 3
                                      C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,(HL) -- add A (%i) and (HL) (%i) = %i\n", currentInstruction, \
                     prev, d8, [state getA]);
            break;
        case 7:
            // ADD A,A -- Add A to A
            prev = [state getA];
            prev_short = [state getA];
            [state setA:(2 * [state getA])];
            C = (unsigned char)prev > (unsigned char)[state getA];
            H = prev > [state getA];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:H // carry from bit 3
                                      C:C]; // carry from bit 7
            PRINTDBG("0x%02x -- ADD A,A -- add A (%i) and A (%i) = %i\n", currentInstruction, \
                     prev, prev, [state getA]);
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
void (^execute0x9Instruction)(romState *,
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
            // SUB (HL) -- Subtract (HL) from A
            d8 = ram[(unsigned short)[state getHL_big]];
            prev = [state getA];
            [state setA:([state getA]-d8)];
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:!((char)(prev & 0xf) < (char)(((d8 & 0xf) & 0xf)))
                                      C:!((unsigned char)prev < (unsigned char)d8)];
            PRINTDBG("0x%02x -- SUB (HL) -- HL is 0x%02x; (HL) is 0x%02x; A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     [state getHL_big], d8, prev, [state getA]);
            break;
        case 7:
            
            break;
        case 8:
            // SBC A,B -- Subtract B + carry flag from A, so A = 0 - C-flag
            prev = [state getA];
            if ([state getCFlag] == true)
            {
                [state setA:([state getA]-[state getB]-1)];
            }
            else
            {
                [state setA:([state getA]-[state getB])];
            }
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:!((char)(prev & 0xf) < (char)((([state getB] & 0xf + \
                                                                        ([state getCFlag] ? 1 : 0)) & 0xf)))
                                      C:!((unsigned char)(prev) < (unsigned char)([state getB] + \
                                                                                  ([state getCFlag] ? 1 : 0)))];
            PRINTDBG("0x%02x -- SBC A,B -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 9:
            // SBC A,C -- Subtract C + carry flag from A, so A = 0 - C-flag
            prev = [state getA];
            if ([state getCFlag] == true)
            {
                [state setA:([state getA]-[state getC]-1)];
            }
            else
            {
                [state setA:([state getA]-[state getC])];
            }
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:!((char)(prev & 0xf) < (char)((([state getC] & 0xf + \
                                                                        ([state getCFlag] ? 1 : 0)) & 0xf)))
                                      C:!((unsigned char)(prev) < (unsigned char)([state getC] + \
                                                                                  ([state getCFlag] ? 1 : 0)))];
            PRINTDBG("0x%02x -- SBC A,C -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xA:
            // SBC A,D -- Subtract D + carry flag from A, so A = 0 - C-flag
            prev = [state getA];
            if ([state getCFlag] == true)
            {
                [state setA:([state getA]-[state getD]-1)];
            }
            else
            {
                [state setA:([state getA]-[state getD])];
            }
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:!((char)(prev & 0xf) < (char)((([state getD] & 0xf + \
                                                                        ([state getCFlag] ? 1 : 0)) & 0xf)))
                                      C:!((unsigned char)(prev) < (unsigned char)([state getD] + \
                                                                                  ([state getCFlag] ? 1 : 0)))];
            PRINTDBG("0x%02x -- SBC A,D -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xB:
            // SBC A,E -- Subtract E + carry flag from A, so A = 0 - C-flag
            prev = [state getA];
            if ([state getCFlag] == true)
            {
                [state setA:([state getA]-[state getE]-1)];
            }
            else
            {
                [state setA:([state getA]-[state getE])];
            }
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:!((char)(prev & 0xf) < (char)((([state getE] & 0xf + \
                                                                        ([state getCFlag] ? 1 : 0)) & 0xf)))
                                      C:!((unsigned char)(prev) < (unsigned char)([state getE] + \
                                                                                  ([state getCFlag] ? 1 : 0)))];
            PRINTDBG("0x%02x -- SBC A,E -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xC:
            // SBC A,H -- Subtract H + carry flag from A, so A = 0 - C-flag
            prev = [state getA];
            if ([state getCFlag] == true)
            {
                [state setA:([state getA]-[state getH]-1)];
            }
            else
            {
                [state setA:([state getA]-[state getH])];
            }
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:!((char)(prev & 0xf) < (char)((([state getH] & 0xf + \
                                                                        ([state getCFlag] ? 1 : 0)) & 0xf)))
                                      C:!((unsigned char)(prev) < (unsigned char)([state getH] + \
                                                                                  ([state getCFlag] ? 1 : 0)))];
            PRINTDBG("0x%02x -- SBC A,H -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xD:
            // SBC A,L -- Subtract L + carry flag from A, so A = 0 - C-flag
            prev = [state getA];
            if ([state getCFlag] == true)
            {
                [state setA:([state getA]-[state getL]-1)];
            }
            else
            {
                [state setA:([state getA]-[state getL])];
            }
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:!((char)(prev & 0xf) < (char)((([state getL] & 0xf + \
                                                                        ([state getCFlag] ? 1 : 0)) & 0xf)))
                                      C:!((unsigned char)(prev) < (unsigned char)([state getL] + \
                                                                                  ([state getCFlag] ? 1 : 0)))];
            PRINTDBG("0x%02x -- SBC A,L -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xE:
            // SBC A,(HL) -- Subtract (HL) + carry flag from A
            prev = [state getA];
            d8 = ram[[state getHL_big]];
            if ([state getCFlag] == true)
            {
                [state setA:([state getA]-d8-1)];
            }
            else
            {
                [state setA:([state getA]-d8)];
            }
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:!((char)(prev & 0xf) < (char)(((d8 & 0xf + \
                                                                        ([state getCFlag] ? 1 : 0)) & 0xf)))
                                      C:!((unsigned char)(prev) < (unsigned char)(d8 + \
                                                                                  ([state getCFlag] ? 1 : 0)))];
            PRINTDBG("0x%02x -- SBC A,(HL) -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
        case 0xF:
            // SBC A,A -- Subtract A + carry flag from A, so A = 0 - C-flag
            prev = [state getA];
            if ([state getCFlag] == true)
            {
                [state setA:-1];
            }
            else
            {
                [state setA:0];
            }
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:true
                                      C:true];
            PRINTDBG("0x%02x -- SBC A,A -- A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     prev, [state getA]);
            break;
    }
};
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
void (^execute0xCInstruction)(romState *,
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
    int16_t d16 = 0;
    unsigned short prev_short = 0;
    int8_t prev = 0;
    int8_t d8 = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // RET NZ -- If !Z, return from subroutine
            prev_short = [state getSP];
            if ([state getZFlag] == false)
            {
                d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
                (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [state setSP:([state getSP]+2)];
                [state setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET NZ -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction, \
                     prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
            break;
        case 1:
            // POP BC -- Pop two bytes from SP into BC, and increment SP twice
            d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
            (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [state setBC_big:d16];
            [state setSP:([state getSP] + 2)];
            PRINTDBG("0x%02x -- POP BC -- BC = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getBC_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 2:
            
            break;
        case 3:
            // JP a16 -- Jump to address a16
            [state incrementPC];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state setPC:d16];
            PRINTDBG("0x%02x -- JP a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", currentInstruction,
                     d16 & 0xffff, [state getPC]);
            *incrementPC = false;
            break;
        case 4:
            // CALL NZ,a16 -- If !Z, push PC onto stack, and jump to a16
            [state incrementPC];
            prev_short = [state getSP];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) |
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getZFlag] == false)
            {
                [state setSP:([state getSP] - 2)];
                ram[[state getSP]] = (int8_t)(([state getPC]+1) & 0xff00) >> 8;
                ram[[state getSP]+1] = (int8_t)(([state getPC]+1) & 0x00ff);
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- CALL NZ,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x; (SP) = 0x%02x\n",
                     currentInstruction, d16 & 0xffff, prev_short, [state getSP],
                     [state getPC],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 5:
            // PUSH BC -- push BC onto SP, and decrement SP twice
            d16 = [state getBC_little];
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            PRINTDBG("0x%02x -- PUSH BC -- BC = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getBC_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 6:
            // ADD A,d8 -- A <- A + d8
            [state incrementPC];
            prev = [state getA];
            d8 = ram[[state getPC]];
            [state setA:([state getA] + d8)];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:prev > [state getA]
                                      C:((unsigned char)prev > (unsigned char)[state getA])];
            PRINTDBG("0x%02x -- ADD d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], d8 & 0xff);
            break;
        case 7:
            // RST 00H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC];
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x00];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 00H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 8:
            // RET Z -- If Z, return from subroutine
            prev_short = [state getSP];
            if ([state getZFlag] == true)
            {
                d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
                (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [state setSP:([state getSP]+2)];
                [state setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET Z -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction, \
                     prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
            break;
        case 9:
            // RET -- return from subroutine; pop two bytes from SP and go to that address
            d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
            (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [state setSP:([state getSP]+2)];
            [state setPC:(unsigned short)d16];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RET -- PC is now 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getPC],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 0xA:
            // JP Z,a16 -- If Z, jump to address a16
            [state incrementPC];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getZFlag] == true)
            {
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- JP Z,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, [state getPC]);
            break;
        case 0xB:
            // Instruction with 0xCB prefix
            PRINTDBG("CB instruction...\n");
            execute0xcbInstruction(state, ram, incrementPC, interruptsEnabled);
            break;
        case 0xC:
            // CALL Z,a16 -- If Z, call subroutine at address a16
            [state incrementPC];
            prev_short = [state getSP];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getZFlag] == true)
            {
                [state setSP:([state getSP] - 2)];
                ram[[state getSP]] = (int8_t)(([state getPC]+1) & 0xff00) >> 8;
                ram[[state getSP]+1] = (int8_t)(([state getPC]+1) & 0x00ff);
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- CALL Z,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n",
                     currentInstruction, d16 & 0xffff, prev_short, [state getSP],
                     [state getPC]);
            break;
        case 0xD:
            // CALL a16 -- call subroutine at address a16
            [state incrementPC];
            prev_short = [state getSP];
            d16 = ((ram[[state getPC]] & 0x00ff)) | \
            ((ram[[state getPC]+1] << 8) & 0xff00);
            [state incrementPC];
            [state setSP:(prev_short - 2)];
            ram[[state getSP]] = (int8_t)(([state getPC]+1) & 0xff);
            ram[[state getSP]+1] = (int8_t)((([state getPC]+1) & 0xff00) >> 8);
            [state setPC:d16];
            *incrementPC =false;
            PRINTDBG("0x%02x -- CALL a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x; (SP) = 0x%02x\n", currentInstruction, d16 & 0xffff,
                     [state getPC],
                     prev_short, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 0xE:
            // ADC A,d8 -- Add d8 + C-flag to A
            prev = [state getA];
            [state incrementPC];
            d8 = ram[[state getPC]];
            if ([state getCFlag])
            {
                [state setA:([state getA]+d8+1)];
            }
            else
            {
                [state setA:([state getA]+d8)];
            }
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if carry from bit 4.
             C - Set if carry (from bit 7).
             */
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:((char)(prev & 0xf) > (char)((([state getA] & 0xf + \
                                                                       ([state getCFlag] ? 1 : 0)) & 0xf)))
                                      C:((unsigned char)(prev) > (unsigned char)([state getA] + \
                                                                                 ([state getCFlag] ? 1 : 0)))];
            PRINTDBG("0x%02x -- ADC A,d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n", currentInstruction,
                     prev, [state getA], d8 & 0xff);
            break;
        case 0xF:
            // RST 08H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC] + 1;
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x08];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 08H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
    }
};
void (^execute0xDInstruction)(romState *,
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
    int16_t d16 = 0;
    int8_t d8 = 0;
    int8_t prev = 0;
    unsigned short prev_short = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // RET NC -- If !C, return from subroutine
            prev_short = [state getSP];
            if ([state getCFlag] == false)
            {
                d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
                (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [state setSP:([state getSP]+2)];
                [state setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET NC -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction, \
                     prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
            break;
        case 1:
            // POP DE - Pop two bytes from SP into DE, and increment SP twice
            d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
            (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [state setDE_big:d16];
            [state setSP:([state getSP] + 2)];
            PRINTDBG("0x%02x -- POP DE -- DE = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getDE_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 2:
            // JP NC,a16 -- If !C, jump to address a16
            [state incrementPC];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getCFlag] == false)
            {
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- JP NC,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, [state getPC]);
            break;
        case 3:
            // no instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 4:
            // CALL NC,a16 -- If !C, call subroutine at address a16
            [state incrementPC];
            prev_short = [state getSP];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getCFlag] == false)
            {
                [state setSP:([state getSP] - 2)];
                ram[[state getSP]] = (([state getPC]+1) & 0xff00) >> 8;
                ram[[state getSP]+1] = ([state getPC]+1) & 0x00ff;
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- CALL NC,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, prev_short, [state getSP], \
                     [state getPC]);
            break;
        case 5:
            // PUSH DE -- push DE onto SP, and decrement SP twice
            d16 = [state getDE_little];
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            PRINTDBG("0x%02x -- PUSH DE -- DE = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getDE_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 6:
            // SUB d8 -- A <- A - d8
            [state incrementPC];
            d8 = ram[[state getPC]];
            prev = [state getA];
            [state setA:([state getA]-d8)];
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:!((char)(prev & 0xf) < (char)(((d8 & 0xf) & 0xf)))
                                      C:!((unsigned char)prev < (unsigned char)d8)];
            PRINTDBG("0x%02x -- SUB d8 -- d8 is 0x%02x; A was 0x%02x; A is now 0x%02x\n", currentInstruction,
                     d8 & 0xff, prev, [state getA]);
            break;
        case 7:
            // RST 10H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC] + 1;
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x10];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 10H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 8:
            // RET C -- If C, return from subroutine
            prev_short = [state getSP];
            if ([state getCFlag] == true)
            {
                d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
                (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
                [state setSP:([state getSP]+2)];
                [state setPC:(unsigned short)d16];
            }
            PRINTDBG("0x%02x -- RET C -- PC is now 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", currentInstruction, \
                     prev_short & 0xffff, [state getSP] & 0xffff, [state getPC]);
            break;
        case 9:
            // RETI -- RET + enable interrupts
            d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
            (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [state setSP:([state getSP]+2)];
            [state setPC:(unsigned short)d16];
            *incrementPC = false;
            enableInterrupts(true, ram);
            PRINTDBG("0x%02x -- RETI -- PC is now 0x%02x\n", currentInstruction,
                     [state getPC]);
            break;
        case 0xA:
            // JP C,a16 -- If C, jump to address a16
            [state incrementPC];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getCFlag] == true)
            {
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- JP C,a16 -- a16 = 0x%02x -- PC is now at 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, [state getPC]);
            break;
        case 0xB:
            // no instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 0xC:
            // CALL C,a16 -- If C, call subroutine at address a16
            [state incrementPC];
            prev_short = [state getSP];
            d16 = ((ram[[state getPC]] & 0x00ff) << 8) | \
            (((ram[[state getPC]+1] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            if ([state getCFlag] == true)
            {
                [state setSP:([state getSP] - 2)];
                ram[[state getSP]] = (int8_t)(([state getPC]+1) & 0xff00) >> 8;
                ram[[state getSP]+1] = (int8_t)(([state getPC]+1) & 0x00ff);
                [state setPC:d16];
                *incrementPC =false;
            }
            PRINTDBG("0x%02x -- CALL C,a16 -- a16 = 0x%02x -- PC is now at 0x%02x; SP was 0x%02x; SP is now 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, prev_short, [state getSP], \
                     [state getPC]);
            break;
        case 0xD:
            // no instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 0xE:
            // SBC A,d8 -- Subtract d8 + carry flag from A, so A = A - (d8 + C-flag)
            prev = [state getA];
            [state incrementPC];
            d8 = ram[[state getPC]];
            if ([state getCFlag])
            {
                [state setA:([state getA]-d8-1)];
            }
            else
            {
                [state setA:([state getA]-d8)];
            }
            /*
             Z - Set if result is zero.
             N - Set.
             H - Set if no borrow from bit 4.
             C - Set if no borrow.
             */
            [state setFlags:[state getA] == 0
                                      N:true
                                      H:!((char)(prev & 0xf) < (char)(((d8 & 0xf + \
                                                                        ([state getCFlag] ? 1 : 0)) & 0xf)))
                                      C:!((unsigned char)(prev) < (unsigned char)(d8 + \
                                                                                  ([state getCFlag] ? 1 : 0)))];
            PRINTDBG("0x%02x -- SBC A,d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n", currentInstruction,
                     prev, [state getA], d8 & 0xff);
            
            break;
        case 0xF:
            // RST 18H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC] + 1;
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x18];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 18H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
    }
};
void (^execute0xEInstruction)(romState *,
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
    int8_t d8 = 0;
    int16_t d16 = 0;
    unsigned short prev_short = 0;
    int8_t prev = 0;
    bool H = false;
    bool C = false;
    switch (currentInstruction & 0x0F) {
        case 0:
            // LDH (a8),A -- Load A into (0xFF00 + a8)
#warning This is for I/O
            [state incrementPC];
            d8 = ram[[state getPC]];
            d16 = (unsigned short)0xff00 + (unsigned short)d8;
            prev = ram[(unsigned short)d16];
            ram[(unsigned short)d16] = [state getA];
            PRINTDBG("0x%02x -- LDH (a8),A -- 0xFF00+a8 = 0x%02x; (0xff00+a8) was 0x%02x and is now 0x%02x; A is 0x%02x\n",
                     currentInstruction, d16 & 0xffff, prev & 0xff, ram[(unsigned short)d16] & 0xff,
                     [state getA] & 0xff);
            break;
        case 1:
            // POP HL - Pop two bytes from SP into HL, and increment SP twice
            d16 = ((ram[[state getSP]] & 0x00ff) << 8) | \
            (((ram[[state getSP]+1] & 0xff00) >> 8) & 0x0ff);
            [state setHL_big:d16];
            [state setSP:([state getSP] + 2)];
            PRINTDBG("0x%02x -- POP HL -- HL = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getHL_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 2:
            // LD (C),A -- Load A into (0xFF00 + C)
#warning This is for I/O
            d16 = (unsigned short)0xff00 + (unsigned short)[state getC];
            prev = ram[(unsigned short)d16];
            ram[(unsigned short)d16] = [state getA];
            PRINTDBG("0x%02x -- LD (C),A -- 0xFF00+C = 0x%02x; (C) was 0x%02x and is now 0x%02x; A is 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, prev & 0xff, ram[(unsigned short)d16] & 0xff, \
                     [state getA] & 0xff);
            break;
        case 3:
            // No instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 4:
            // No instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 5:
            // PUSH HL -- push HL onto SP, and decrement SP twice
            d16 = [state getHL_little];
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            PRINTDBG("0x%02x -- PUSH HL -- HL = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getHL_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 6:
            // AND d8 -- A <- A & d8
            [state incrementPC];
            prev = [state getA];
            d8 = ram[[state getPC]];
            [state setA:([state getA] & d8)];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:true
                                      C:false];
            PRINTDBG("0x%02x -- AND d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], d8 & 0xff);
            break;
        case 7:
            // RST 20H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC] + 1;
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x20];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 20H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 8:
            // ADD SP,r8 -- Add 8-bit immediate value to SP
            [state incrementPC];
            prev_short = [state getSP];
            d8 = ram[[state getPC]];
            [state addToSP:d8];
            C = (unsigned short)prev_short > (unsigned short)[state getSP];
            H = prev_short > [state getSP];
            [state setFlags:false
                                      N:false
                                      H:H
                                      C:C];
            PRINTDBG("0x%02x -- ADD SP,r8 (r8 = %d) -- SP was 0x%02x; SP is now 0x%02x\n", \
                     currentInstruction, (int)d8, prev_short, [state getSP]);
            break;
        case 9:
            // JP (HL) -- Jump to address in register HL
            [state incrementPC];
            d16 = (([state getHL_big] & 0x00ff) << 8) | \
            ((([state getHL_big] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            [state setPC:d16];
            *incrementPC =false;
            PRINTDBG("0x%02x -- JP (HL) -- HL = 0x%02x -- PC is now at 0x%02x\n", \
                     currentInstruction, d16 & 0xffff, [state getPC]);
            break;
        case 0xA:
            // LD (a16),A -- Put A into (a16)
            [state incrementPC];
            d16 = (([state getPC] & 0x00ff) << 8) | \
            ((([state getPC] & 0xff00) >> 8) & 0x0ff);
            [state incrementPC];
            prev_short = ram[(unsigned short)d16];
            ram[(unsigned short)d16] = [state getA];
            PRINTDBG("0x%02x -- LD (a16),A -- A = 0x%02x; a16 = 0x%02x; [a16] was 0x%02x and is now 0x%02x\n", \
                     currentInstruction, [state getA], (unsigned short)d16, \
                     (unsigned short)prev_short, ram[(unsigned short)d16]);
            break;
        case 0xB:
            // No instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 0xC:
            // No instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 0xD:
            // No instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 0xE:
            // XOR d8 -- A <- A ^ d8
            [state incrementPC];
            prev = [state getA];
            d8 = ram[[state getPC]];
            [state setA:([state getA] ^ d8)];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:false
                                      C:false];
            PRINTDBG("0x%02x -- XOR d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], d8 & 0xff);
            break;
        case 0xF:
            // RST 28H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC] + 1;
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x28];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 28H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
    }
};
void (^execute0xFInstruction)(romState *,
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
    int16_t d16 = 0;
    short prev_short = 0;
    int8_t d8 = 0;
    int8_t prev = 0;
    switch (currentInstruction & 0x0F) {
        case 0:
            // LDH A,(a8) -- Put (0xFF00+a8) into A
#warning This is for I/O
            [state incrementPC];
            d8 = ram[[state getPC]];
            d16 = (unsigned short)0xff00 + (unsigned short)d8;
            prev = [state getA];
            [state setA:ram[(unsigned short)d16]];
            PRINTDBG("0x%02x -- LDH A,(a8) -- 0xFF00+a8 = 0x%02x; A was 0x%02x and is now 0x%02x; (0xff00+a8) is 0x%02x\n",
                     currentInstruction, d16 & 0xffff, prev & 0xff,
                     [state getA] & 0xff,
                     ram[(unsigned short)d16] & 0xff);
            break;
        case 1:
            // POP AF -- Pop two bytes from SP into AF, and increment SP twice
            [state setA:ram[(([state getSP] & 0xff00) >> 8)]];
            // We don't want to change F
            [state setSP:([state getSP] + 2)];
            PRINTDBG("0x%02x -- POP AF -- AF = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getAF_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 2:
            // LD A,(C) -- Put value (0xff00+C) into A
#warning This is for I/O
            d16 = (unsigned short)0xff00 + (unsigned short)[state getC];
            prev = [state getA];
            [state setA:ram[(unsigned short)d16]];
            PRINTDBG("0x%02x -- LD A,(C) -- 0xFF00+C = 0x%02x; A was 0x%02x and is now 0x%02x; (0xff00+C) is 0x%02x\n",
                     currentInstruction, d16 & 0xffff, prev & 0xff, [state getA] & 0xff,
                     ram[(unsigned short)d16] & 0xff);
            break;
        case 3:
            // DI -- disable interrupts
            *interruptsEnabled = -1;
            PRINTDBG("0x%02x -- DI -- disabling interrupts after the next instruction\n", currentInstruction);
            break;
        case 4:
            // no instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 5:
            // PUSH AF -- push AF onto SP, and decrement SP twice
            d16 = [state getAF_little];
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            PRINTDBG("0x%02x -- PUSH AF -- AF = 0x%02x -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction,
                     [state getAF_big], [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 6:
            // OR d8 -- A <- A | d8
            [state incrementPC];
            prev = [state getA];
            d8 = ram[[state getPC]];
            [state setA:([state getA] | d8)];
            [state setFlags:[state getA] == 0
                                      N:false
                                      H:false
                                      C:false];
            PRINTDBG("0x%02x -- OR d8 -- A was 0x%02x; A is now 0x%02x; d8 = 0x%02x\n",
                     currentInstruction, prev & 0xff, [state getA], d8 & 0xff);
            break;
        case 7:
            // RST 30H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC] + 1;
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x30];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 30H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
        case 8:
            // LD HL,SP+r8 -- Put (SP+r8) into HL
            [state incrementPC];
            d8 = ram[[state getPC]];
            prev_short = [state getHL_big];
            d16 = (unsigned short)[state getSP] + (short)d8;
            [state setHL_big:ram[(unsigned short)d16]];
            PRINTDBG("0x%02x -- LD HL,SP+r8 -- HL was 0x%02x; HL is now 0x%02x; SP=0x%02x; d8=0x%02x, (SP+d8)=0x%02x\n",
                     currentInstruction, prev_short & 0xffff, [state getHL_big] & 0xffff,
                     [state getSP] & 0xffff, d8 & 0xff, ram[(unsigned short)d16]);
            break;
        case 9:
            // LD SP,HL -- Load LH into SP
            prev_short = [state getSP];
            [state setSP:[state getHL_big]];
            PRINTDBG("0x%02x -- LD SP,HL -- SP was 0x%02x, and is now 0x%02x\n", currentInstruction, \
                     prev_short, [state getSP]);
            break;
        case 0xA:
            // LD A,(a16) -- Load (a16) into A
            [state incrementPC];
            d16 = (([state getPC] & 0x00ff) << 8) | \
            ((([state getPC] & 0xff00) >> 8) & 0x0ff);
            d8 = ram[(unsigned short)d16];
            prev = [state getA];
            [state setA:d8];
            PRINTDBG("0x%02x -- LD A,(a16) -- A was 0x%02x, and is now 0x%02x; a16 = 0%02x\n", currentInstruction,
                     prev & 0xff, [state getA] & 0xff, d16 & 0xffff);
            break;
        case 0xB:
            // EI -- Enable interrupts after next instruction
            *interruptsEnabled = 1;
            PRINTDBG("0x%02x -- EI -- enabling interrupts after next instruction\n", currentInstruction);
            break;
        case 0xC:
            // no instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 0xD:
            // no instruction
            PRINTDBG("0x%02x -- invalid instruction\n", currentInstruction);
            break;
        case 0xE:
            // CP d8 -- Compare A with 8-bit data
            [state incrementPC];
            d8 = ram[[state getPC]];
            d16 = [state getA] - d8;
            [state setFlags:d16 == 0
                                      N:true
                                      H:!((char)([state getA] & 0xf) < \
                                          (char)(((d8 & 0xf + ([state getCFlag] ? 1 : 0)) & 0xf)))
                                      C:!((char)([state getA]) < \
                                          (char)(((d8 + ([state getCFlag] ? 1 : 0)))))];
            PRINTDBG("0x%02x -- CP d8 -- A = 0x%02x, d8 = 0x%02x; C-flag = %i\n", currentInstruction,
                     [state getA] & 0xff, d8 & 0xff, [state getCFlag] ? 1 : 0);
            break;
        case 0xF:
            // RST 38H -- push PC onto stack, and jump to address 0x00
            d16 = [state getPC] + 1;
            [state setSP:([state getSP] - 2)];
            ram[[state getSP]] = (d16 & 0xff00) >> 8;
            ram[[state getSP]+1] = d16 & 0x00ff;
            [state setPC:0x38];
            *incrementPC =false;
            PRINTDBG("0x%02x -- RST 38H -- SP is now at 0x%02x; (SP) = 0x%02x\n", currentInstruction, [state getSP],
                     (((ram[[state getSP]]) & 0x00ff)) |
                     (((ram[[state getSP]+1]) << 8) & 0xff00));
            break;
    }
};

#pragma mark - CB Instructions


void (^execute0xcbInstruction)(romState *,
                               char *,
                               bool *,
                               int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    [state incrementPC];
    int8_t CBInstruction = ram[[state getPC]];
    switch ((CBInstruction & 0xF0) >> 4) {
        case 0:
            //            [self CBexecute0x0Instruction:CBInstruction];
            execute0xcb0Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 1:
            //            [self CBexecute0x1Instruction:CBInstruction];
            execute0xcb1Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 2:
            //            [self CBexecute0x2Instruction:CBInstruction];
            execute0xcb2Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 3:
            //            [self CBexecute0x3Instruction:CBInstruction];
            execute0xcb3Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 4:
            //            [self CBexecute0x4Instruction:CBInstruction];
            execute0xcb4Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 5:
            //            [self CBexecute0x5Instruction:CBInstruction];
            execute0xcb6Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 6:
            //            [self CBexecute0x6Instruction:CBInstruction];
            execute0xcb6Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 7:
            //            [self CBexecute0x7Instruction:CBInstruction];
            execute0xcb7Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 8:
            //            [self CBexecute0x8Instruction:CBInstruction];
            execute0xcb8Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 9:
            //            [self CBexecute0x9Instruction:CBInstruction];
            execute0xcb9Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xA:
            //            [self CBexecute0xAInstruction:CBInstruction];
            execute0xcbAInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xB:
            //            [self CBexecute0xBInstruction:CBInstruction];
            execute0xcbBInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xC:
            //            [self CBexecute0xCInstruction:CBInstruction];
            execute0xcbCInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xD:
            //            [self CBexecute0xDInstruction:CBInstruction];
            execute0xcbDInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xE:
            //            [self CBexecute0xEInstruction:CBInstruction];
            execute0xcbEInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xF:
            //            [self CBexecute0xFInstruction:CBInstruction];
            execute0xcbFInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
    }
};


void (^execute0xcb0Instruction)(romState *,
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
            
            break;
    }
};
void (^execute0xcb1Instruction)(romState *,
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
    int8_t temp = 0;
    bool C = false;
    switch (currentInstruction & 0x0F) {
        case 0:
            
            break;
        case 1:
            // RL C -- Rotate C left through C-flag
            prev = [state getC];
            temp = [state getCFlag];
            C = (bool)([state getC] & 0b10000000);
            [state setC:([state getC] << 1)];
            // Set LSb of C to its previous C-value
            temp ? [state setC:([state getC] | 1)] :
            [state setC:([state getC] & 0b11111110)];
            [state setFlags:[state getC] == 0
                                      N:false
                                      H:false
                                      C:C];
            PRINTDBG("0x%02x -- RL C -- C was 0x%02x; C is now 0x%02x\n", currentInstruction, prev, [state getC]);
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
            
            break;
    }
};
void (^execute0xcb2Instruction)(romState *,
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
            
            break;
    }
};
void (^execute0xcb3Instruction)(romState *,
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
            
            break;
    }
};
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
            
            break;
    }
};
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
            
            break;
    }
};
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
            
            break;
    }
};
void (^execute0xcb7Instruction)(romState *,
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
            // BIT 7,H -- test 7th bit of H register
            [state setFlags:(bool)([state getH] & (int8_t)0b10000000)
                                      N:false
                                      H:true
                                      C:[state getCFlag]];
            PRINTDBG("0xCB%02x -- BIT 7,H -- H is 0x%02x -- Z is now %i\n", currentInstruction, \
                     [state getH], [state getZFlag]);
            break;
        case 0xD:
            
            break;
        case 0xE:
            
            break;
        case 0xF:
            
            break;
    }
};
void (^execute0xcb8Instruction)(romState *,
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
            
            break;
    }
};
void (^execute0xcb9Instruction)(romState *,
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
            
            break;
    }
};
void (^execute0xcbAInstruction)(romState *,
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
            
            break;
    }
};
void (^execute0xcbBInstruction)(romState *,
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
            
            break;
    }
};
void (^execute0xcbCInstruction)(romState *,
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
            
            break;
    }
};
void (^execute0xcbDInstruction)(romState *,
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
            
            break;
    }
};
void (^execute0xcbEInstruction)(romState *,
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
            
            break;
    }
};
void (^execute0xcbFInstruction)(romState *,
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
            
            break;
    }
};

