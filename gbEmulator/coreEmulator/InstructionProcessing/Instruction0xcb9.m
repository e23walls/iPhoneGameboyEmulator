#import "emulatorMain.h"

extern int8_t (^resetBit)(int8_t,
                          int8_t,
                          NSString *,
                          unsigned int);

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
            // RES 2,B -- Reset bit 2 of B
            [state setB:resetBit(currentInstruction, [state getB], @"B", 2)];
            break;
        case 1:
            // RES 2,C -- Reset bit 2 of C
            [state setC:resetBit(currentInstruction, [state getC], @"C", 2)];
            break;
        case 2:
            // RES 2,D -- Reset bit 2 of D
            [state setD:resetBit(currentInstruction, [state getD], @"D", 2)];
            break;
        case 3:
            // RES 2,E -- Reset bit 2 of E
            [state setE:resetBit(currentInstruction, [state getE], @"E", 2)];
            break;
        case 4:
            // RES 2,H -- Reset bit 2 of H
            [state setH:resetBit(currentInstruction, [state getH], @"H", 2)];
            break;
        case 5:
            // RES 2,L -- Reset bit 2 of L
            [state setL:resetBit(currentInstruction, [state getL], @"L", 2)];
            break;
        case 6:
            // RES 2,(HL) -- Reset bit 2 of (HL)
            ram[(unsigned short)[state getHL_big]] = resetBit(currentInstruction, ram[(unsigned short)[state getHL_big]], @"(HL)", 2);
            break;
        case 7:
            // RES 2,A -- Reset bit 2 of A
            [state setA:resetBit(currentInstruction, [state getA], @"A", 2)];
            break;
        case 8:
            // RES 3,B -- Reset bit 3 of B
            [state setB:resetBit(currentInstruction, [state getB], @"B", 3)];
            break;
        case 9:
            // RES 3,C -- Reset bit 3 of C
            [state setC:resetBit(currentInstruction, [state getC], @"C", 3)];
            break;
        case 0xA:
            // RES 3,D -- Reset bit 3 of D
            [state setD:resetBit(currentInstruction, [state getD], @"D", 3)];
            break;
        case 0xB:
            // RES 3,E -- Reset bit 3 of E
            [state setE:resetBit(currentInstruction, [state getE], @"E", 3)];
            break;
        case 0xC:
            // RES 3,H -- Reset bit 3 of H
            [state setH:resetBit(currentInstruction, [state getH], @"H", 3)];
            break;
        case 0xD:
            // RES 3,L -- Reset bit 3 of L
            [state setL:resetBit(currentInstruction, [state getL], @"L", 3)];
            break;
        case 0xE:
            // RES 3,(HL) -- Reset bit 3 of (HL)
            ram[(unsigned short)[state getHL_big]] = resetBit(currentInstruction, ram[(unsigned short)[state getHL_big]], @"(HL)", 3);
            break;
        case 0xF:
            // RES 3,A -- Reset bit 3 of A
            [state setA:resetBit(currentInstruction, [state getA], @"A", 3)];
            break;
    }
};