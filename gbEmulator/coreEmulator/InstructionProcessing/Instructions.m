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
void (^execute0xcbInstruction)(romState *, char *, bool *, int8_t *, int8_t);
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

#pragma mark - enableInterrupts
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

#pragma mark - setKeysInMemory
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

#pragma mark - executeInstruction
void (^executeInstruction)(romState *, char *, bool *, int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    unsigned char currentInstruction = ram[[state getPC]-1];
    PRINTDBG("Instruction address: 0x%02x\n", ([state getPC]-1) & 0xff);
    switch ((currentInstruction & 0xF0) >> 4) {
        case 0:
            execute0x0Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 1:
            execute0x1Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 2:
            execute0x2Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 3:
            execute0x3Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 4:
            execute0x4Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 5:
            execute0x5Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 6:
            execute0x6Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 7:
            execute0x7Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 8:
            execute0x8Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 9:
            execute0x9Instruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xA:
            execute0xAInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xB:
            execute0xBInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xC:
            execute0xCInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xD:
            execute0xDInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xE:
            execute0xEInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xF:
            execute0xFInstruction(state, currentInstruction, ram, incrementPC, interruptsEnabled);
            break;
    }
};

#pragma mark - execute0xcbInstruction
void (^execute0xcbInstruction)(romState *,
                               char *,
                               bool *,
                               int8_t *,
                               int8_t) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled,
  int8_t CBInstruction)
{
    [state incrementPC];
    switch ((CBInstruction & 0xF0) >> 4) {
        case 0:
            execute0xcb0Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 1:
            execute0xcb1Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 2:
            execute0xcb2Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 3:
            execute0xcb3Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 4:
            execute0xcb4Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 5:
            execute0xcb6Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 6:
            execute0xcb6Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 7:
            execute0xcb7Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 8:
            execute0xcb8Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 9:
            execute0xcb9Instruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xA:
            execute0xcbAInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xB:
            execute0xcbBInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xC:
            execute0xcbCInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xD:
            execute0xcbDInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xE:
            execute0xcbEInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
        case 0xF:
            execute0xcbFInstruction(state, CBInstruction, ram, incrementPC, interruptsEnabled);
            break;
    }
};

