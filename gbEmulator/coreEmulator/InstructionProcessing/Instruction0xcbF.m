#import "emulatorMain.h"

extern int8_t (^setBit)(int8_t,
                        int8_t,
                        NSString *,
                        unsigned int);

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
            // SET 6,B -- Set bit 6 of B
            [state setB:setBit(currentInstruction, [state getB], @"B", 6)];
            break;
        case 1:
            // SET 6,C -- Set bit 6 of C
            [state setC:setBit(currentInstruction, [state getC], @"C", 6)];
            break;
        case 2:
            // SET 6,D -- Set bit 6 of D
            [state setD:setBit(currentInstruction, [state getD], @"D", 6)];
            break;
        case 3:
            // SET 6,E -- Set bit 6 of E
            [state setE:setBit(currentInstruction, [state getE], @"E", 6)];
            break;
        case 4:
            // SET 6,H -- Set bit 6 of H
            [state setH:setBit(currentInstruction, [state getH], @"H", 6)];
            break;
        case 5:
            // SET 6,L -- Set bit 6 of L
            [state setL:setBit(currentInstruction, [state getL], @"L", 6)];
            break;
        case 6:
            // SET 6,(HL) -- Set bit 6 of (HL)
            ram[(unsigned short)[state getHL_big]] = setBit(currentInstruction,
                                                            ram[(unsigned short)[state getHL_big]],
                                                            @"(HL)", 6);
            break;
        case 7:
            // SET 6,A -- Set bit 6 of A
            [state setA:setBit(currentInstruction, [state getA], @"A", 6)];
            break;
        case 8:
            // SET 7,B -- Set bit 7 of B
            [state setB:setBit(currentInstruction, [state getB], @"B", 7)];
            break;
        case 9:
            // SET 7,C -- Set bit 7 of C
            [state setC:setBit(currentInstruction, [state getC], @"C", 7)];
            break;
        case 0xA:
            // SET 7,D -- Set bit 7 of D
            [state setD:setBit(currentInstruction, [state getD], @"D", 7)];
            break;
        case 0xB:
            // SET 7,E -- Set bit 7 of E
            [state setE:setBit(currentInstruction, [state getE], @"E", 7)];
            break;
        case 0xC:
            // SET 7,H -- Set bit 7 of H
            [state setH:setBit(currentInstruction, [state getH], @"H", 7)];
            break;
        case 0xD:
            // SET 7,L -- Set bit 7 of L
            [state setL:setBit(currentInstruction, [state getL], @"L", 7)];
            break;
        case 0xE:
            // SET 7,(HL) -- Set bit 7 of (HL)
            ram[(unsigned short)[state getHL_big]] = setBit(currentInstruction,
                                                            ram[(unsigned short)[state getHL_big]],
                                                            @"(HL)", 7);
            break;
        case 0xF:
            // SET 7,A -- Set bit 7 of A
            [state setA:setBit(currentInstruction, [state getA], @"A", 7)];
            break;
    }
};