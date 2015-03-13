#import "emulatorMain.h"

extern int8_t (^setBit)(int8_t,
                        int8_t,
                        NSString *,
                        unsigned int);

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
            // SET 2,B -- Set bit 2 of B
            [state setB:setBit(currentInstruction, [state getB], @"B", 2)];
            break;
        case 1:
            // SET 2,C -- Set bit 2 of C
            [state setC:setBit(currentInstruction, [state getC], @"C", 2)];
            break;
        case 2:
            // SET 2,D -- Set bit 2 of D
            [state setD:setBit(currentInstruction, [state getD], @"D", 2)];
            break;
        case 3:
            // SET 2,E -- Set bit 2 of E
            [state setE:setBit(currentInstruction, [state getE], @"E", 2)];
            break;
        case 4:
            // SET 2,H -- Set bit 2 of H
            [state setH:setBit(currentInstruction, [state getH], @"H", 2)];
            break;
        case 5:
            // SET 2,L -- Set bit 2 of L
            [state setL:setBit(currentInstruction, [state getL], @"L", 2)];
            break;
        case 6:
            // SET 2,(HL) -- Set bit 2 of (HL)
            ram[(unsigned short)[state getHL_big]] = setBit(currentInstruction,
                                                            ram[(unsigned short)[state getHL_big]],
                                                            @"(HL)", 2);
            break;
        case 7:
            // SET 2,A -- Set bit 2 of A
            [state setA:setBit(currentInstruction, [state getA], @"A", 2)];
            break;
        case 8:
            // SET 3,B -- Set bit 3 of B
            [state setB:setBit(currentInstruction, [state getB], @"B", 3)];
            break;
        case 9:
            // SET 3,C -- Set bit 3 of C
            [state setC:setBit(currentInstruction, [state getC], @"C", 3)];
            break;
        case 0xA:
            // SET 3,D -- Set bit 3 of D
            [state setD:setBit(currentInstruction, [state getD], @"D", 3)];
            break;
        case 0xB:
            // SET 3,E -- Set bit 3 of E
            [state setE:setBit(currentInstruction, [state getE], @"E", 3)];
            break;
        case 0xC:
            // SET 3,H -- Set bit 3 of H
            [state setH:setBit(currentInstruction, [state getH], @"H", 3)];
            break;
        case 0xD:
            // SET 3,L -- Set bit 3 of L
            [state setL:setBit(currentInstruction, [state getL], @"L", 3)];
            break;
        case 0xE:
            // SET 3,(HL) -- Set bit 3 of (HL)
            ram[(unsigned short)[state getHL_big]] = setBit(currentInstruction,
                                                            ram[(unsigned short)[state getHL_big]],
                                                            @"(HL)", 3);
            break;
        case 0xF:
            // SET 3,A -- Set bit 3 of A
            [state setA:setBit(currentInstruction, [state getA], @"A", 3)];
            break;
    }
};