#import "emulatorMain.h"

extern int8_t (^resetBit)(int8_t,
                          int8_t,
                          NSString *,
                          unsigned int);

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
            // RES 4,B -- Reset bit 4 of B
            [state setB:resetBit(currentInstruction, [state getB], @"B", 4)];
            break;
        case 1:
            // RES 4,C -- Reset bit 4 of C
            [state setC:resetBit(currentInstruction, [state getC], @"C", 4)];
            break;
        case 2:
            // RES 4,D -- Reset bit 4 of D
            [state setD:resetBit(currentInstruction, [state getD], @"D", 4)];
            break;
        case 3:
            // RES 4,E -- Reset bit 4 of E
            [state setE:resetBit(currentInstruction, [state getE], @"E", 4)];
            break;
        case 4:
            // RES 4,H -- Reset bit 4 of H
            [state setH:resetBit(currentInstruction, [state getH], @"B", 4)];
            break;
        case 5:
            // RES 4,L -- Reset bit 4 of L
            [state setL:resetBit(currentInstruction, [state getL], @"L", 4)];
            break;
        case 6:
            // RES 4,(HL) -- Reset bit 4 of (HL)
            ram[(unsigned short)[state getHL_big]] = resetBit(currentInstruction, ram[(unsigned short)[state getHL_big]], @"(HL)", 4);
            break;
        case 7:
            // RES 4,A -- Reset bit 4 of A
            [state setA:resetBit(currentInstruction, [state getA], @"A", 4)];
            break;
        case 8:
            // RES 5,B -- Reset bit 5 of B
            [state setB:resetBit(currentInstruction, [state getB], @"B", 5)];
            break;
        case 9:
            // RES 5,C -- Reset bit 5 of C
            [state setC:resetBit(currentInstruction, [state getC], @"C", 5)];
            break;
        case 0xA:
            // RES 5,D -- Reset bit 5 of D
            [state setD:resetBit(currentInstruction, [state getD], @"D", 5)];
            break;
        case 0xB:
            // RES 5,E -- Reset bit 5 of E
            [state setE:resetBit(currentInstruction, [state getE], @"E", 5)];
            break;
        case 0xC:
            // RES 5,H -- Reset bit 5 of H
            [state setH:resetBit(currentInstruction, [state getH], @"H", 5)];
            break;
        case 0xD:
            // RES 5,L -- Reset bit 5 of L
            [state setL:resetBit(currentInstruction, [state getL], @"L", 5)];
            break;
        case 0xE:
            // RES 5,(HL) -- Reset bit 5 of (HL)
            ram[(unsigned short)[state getHL_big]] = resetBit(currentInstruction, ram[(unsigned short)[state getHL_big]], @"(HL)", 5);
            break;
        case 0xF:
            // RES 5,A -- Reset bit 5 of A
            [state setA:resetBit(currentInstruction, [state getA], @"A", 5)];
            break;
    }
};