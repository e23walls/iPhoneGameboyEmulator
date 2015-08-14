#import "emulatorMain.h"


void (^execute0xcb30Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SWAP B -- swap upper and lower nybbles of B
    prev = [state getB];
    [state setB:(([state getB] & 0x0f) << 4) | (([state getB] & 0xf0) >> 4)];
    [state setFlags:[state getB] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xCB30 -- SWAP B -- B was 0x%02x; B is now 0x%02x\n",
             prev, [state getB]);
};
void (^execute0xcb31Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SWAP C -- swap upper and lower nybbles of C
    prev = [state getC];
    [state setC:(([state getC] & 0x0f) << 4) | (([state getC] & 0xf0) >> 4)];
    [state setFlags:[state getC] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xCB31 -- SWAP C -- C was 0x%02x; C is now 0x%02x\n",
             prev, [state getC]);
};
void (^execute0xcb32Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SWAP D -- swap upper and lower nybbles of D
    prev = [state getD];
    [state setD:(([state getD] & 0x0f) << 4) | (([state getD] & 0xf0) >> 4)];
    [state setFlags:[state getD] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xCB32 -- SWAP D -- D was 0x%02x; D is now 0x%02x\n",
             prev, [state getD]);
};
void (^execute0xcb33Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SWAP E -- swap upper and lower nybbles of E
    prev = [state getE];
    [state setE:(([state getE] & 0x0f) << 4) | (([state getE] & 0xf0) >> 4)];
    [state setFlags:[state getE] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xCB33 -- SWAP E -- E was 0x%02x; E is now 0x%02x\n",
             prev, [state getE]);
};
void (^execute0xcb34Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SWAP H -- swap upper and lower nybbles of H
    prev = [state getH];
    [state setH:(([state getH] & 0x0f) << 4) | (([state getH] & 0xf0) >> 4)];
    [state setFlags:[state getH] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xCB34 -- SWAP H -- H was 0x%02x; H is now 0x%02x\n",
             prev, [state getH]);
};
void (^execute0xcb35Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SWAP L -- swap upper and lower nybbles of L
    prev = [state getL];
    [state setL:(([state getL] & 0x0f) << 4) | (([state getL] & 0xf0) >> 4)];
    [state setFlags:[state getL] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xCB35 -- SWAP L -- L was 0x%02x; L is now 0x%02x\n",
             prev, [state getL]);
};
void (^execute0xcb36Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SWAP (HL) -- swap upper and lower nybbles of (HL)
    prev = ram[(unsigned short)[state getHL_big]];
    ram[(unsigned short)[state getHL_big]] = ((ram[(unsigned short)[state getHL_big]] & 0x0f) << 4) |
    ((ram[(unsigned short)[state getHL_big]] & 0xf0) >> 4);
    [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xCB36 -- SWAP (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n",
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0xcb37Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;

    // SWAP A -- swap upper and lower nybbles of A
    prev = [state getA];
    [state setA:(([state getA] & 0x0f) << 4) | (([state getA] & 0xf0) >> 4)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:false];
    PRINTDBG("0xCB37 -- SWAP A -- A was 0x%02x; A is now 0x%02x\n",
             prev, [state getA]);
};
void (^execute0xcb38Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // SRL B -- Shift B right into Carry; MSb reset
    prev = [state getB];
    C = (bool)([state getB] & 0b00000001);
    [state setB:([state getB] >> 1) & 0xff];
    [state setFlags:[state getB] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB38 -- SRL B -- B was 0x%02x; B is now 0x%02x; C-flag = %i\n",
             prev & 0xff, [state getB] & 0xff, [state getCFlag]);
};
void (^execute0xcb39Instruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // SRL C -- Shift C right into Carry; MSb reset
    prev = [state getC];
    C = (bool)([state getC] & 0b00000001);
    [state setC:([state getC] >> 1) & 0xff];
    [state setFlags:[state getC] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB39 -- SRL C -- C was 0x%02x; C is now 0x%02x; C-flag = %i\n",
             prev & 0xff, [state getC] & 0xff, [state getCFlag]);
};
void (^execute0xcb3AInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // SRL D -- Shift D right into Carry; MSb reset
    prev = [state getD];
    C = (bool)([state getD] & 0b00000001);
    [state setD:([state getD] >> 1) & 0xff];
    [state setFlags:[state getD] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB3A -- SRL D -- D was 0x%02x; D is now 0x%02x; C-flag = %i\n",
             prev & 0xff, [state getD] & 0xff, [state getCFlag]);
};
void (^execute0xcb3BInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // SRL E -- Shift E right into Carry; MSb reset
    prev = [state getE];
    C = (bool)([state getE] & 0b00000001);
    [state setE:([state getE] >> 1) & 0xff];
    [state setFlags:[state getE] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB3B -- SRL E -- E was 0x%02x; E is now 0x%02x; C-flag = %i\n",
             prev & 0xff, [state getE] & 0xff, [state getCFlag]);
};
void (^execute0xcb3CInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // SRL H -- Shift H right into Carry; MSb reset
    prev = [state getH];
    C = (bool)([state getH] & 0b00000001);
    [state setH:([state getH] >> 1) & 0xff];
    [state setFlags:[state getH] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB3C -- SRL H -- H was 0x%02x; H is now 0x%02x; C-flag = %i\n",
             prev & 0xff, [state getH] & 0xff, [state getCFlag]);
};
void (^execute0xcb3DInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // SRL L -- Shift L right into Carry; MSb reset
    prev = [state getL];
    C = (bool)([state getL] & 0b00000001);
    [state setL:([state getL] >> 1) & 0xff];
    [state setFlags:[state getL] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB3D -- SRL L -- L was 0x%02x; L is now 0x%02x; C-flag = %i\n",
             prev & 0xff, [state getL] & 0xff, [state getCFlag]);
};
void (^execute0xcb3EInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // SRL (HL) -- Shift (HL) right into Carry; MSb reset
    prev = ram[(unsigned short)[state getHL_big]];
    C = (bool)(ram[(unsigned short)[state getHL_big]] & 0b00000001);
    ram[(unsigned short)[state getHL_big]] = (ram[(unsigned short)[state getHL_big]] << 1)
    & 0xff;
    [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB3E -- SRL (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x; C-flag = %i\n",
             prev & 0xff, ram[(unsigned short)[state getHL_big]] & 0xff, [state getCFlag]);
};
void (^execute0xcb3FInstruction)(romState *,
                                char *,
                                bool *,
                                int8_t *) =
^(romState * state,
  char * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // SRL A -- Shift A right into Carry; MSb reset
    prev = [state getA];
    C = (bool)([state getA] & 0b00000001);
    [state setA:([state getA] >> 1) & 0xff];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB3F -- SRL A -- A was 0x%02x; A is now 0x%02x; C-flag = %i\n",
             prev & 0xff, [state getA] & 0xff, [state getCFlag]);
};