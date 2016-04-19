#import "emulatorMain.h"

void (^execute0xcb10Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RL B -- Rotate B left through C-flag
    prev = [state getB] << 1;
    C = (bool)([state getB] & 0b10000000);
    // Set LSb of B to its previous C-value
    [state getCFlag] ? [state setB:(prev | 1)] : [state setB:(prev & 0b11111110)];
    [state setFlags:[state getB] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB10 -- RL B -- B was 0x%02x; B is now 0x%02x\n", prev, [state getB]);
};
void (^execute0xcb11Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RL C -- Rotate C left through C-flag
    prev = [state getC];
    C = (bool)([state getC] & 0b10000000);
    // Set LSb of C to its previous C-value
    [state getCFlag] ? [state setC:((prev << 1) | 1)] : [state setC:((prev << 1) & 0b11111110)];
    [state setFlags:[state getC] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB11 -- RL C -- C was 0x%02x; C is now 0x%02x\n", prev, [state getC]);
};
void (^execute0xcb12Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RL D -- Rotate D left through C-flag
    prev = [state getD] << 1;
    C = (bool)([state getD] & 0b10000000);
    // Set LSb of D to its previous C-value
    [state getCFlag] ? [state setD:(prev | 1)] : [state setD:(prev & 0b11111110)];
    [state setFlags:[state getD] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB12 -- RL D -- D was 0x%02x; D is now 0x%02x\n", prev, [state getD]);
};
void (^execute0xcb13Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RL E -- Rotate E left through C-flag
    prev = [state getE] << 1;
    C = (bool)([state getE] & 0b10000000);
    // Set LSb of E to its previous C-value
    [state getCFlag] ? [state setE:(prev | 1)] : [state setE:(prev & 0b11111110)];
    [state setFlags:[state getE] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB13 -- RL E -- E was 0x%02x; E is now 0x%02x\n", prev, [state getE]);
};
void (^execute0xcb14Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RL H -- Rotate H left through C-flag
    prev = [state getH] << 1;
    C = (bool)([state getH] & 0b10000000);
    // Set LSb of H to its previous C-value
    [state getCFlag] ? [state setH:(prev | 1)] : [state setH:(prev & 0b11111110)];
    [state setFlags:[state getH] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB14 -- RL H -- H was 0x%02x; H is now 0x%02x\n", prev, [state getH]);
};
void (^execute0xcb15Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RL L -- Rotate L left through C-flag
    prev = [state getL] << 1;
    C = (bool)([state getL] & 0b10000000);
    // Set LSb of L to its previous C-value
    [state getCFlag] ? [state setL:(prev | 1)] : [state setL:(prev & 0b11111110)];
    [state setFlags:[state getL] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB15 -- RL L -- L was 0x%02x; L is now 0x%02x\n", prev, [state getL]);
};
void (^execute0xcb16Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RL (HL) -- Rotate (HL) left through C-flag
    prev = ram[(unsigned short)[state getHL_big]] << 1;
    C = (bool)([state getC] & 0b10000000);
    // Set LSb of A to its previous C-value
    if ([state getCFlag])
    {
        ram[(unsigned short)[state getHL_big]] = prev | 1;
    }
    else
    {
        ram[(unsigned short)[state getHL_big]] = prev & 0b11111110;
    }
    [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB16 -- RL (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", prev,
             ram[(unsigned short)[state getHL_big]]);
};
void (^execute0xcb17Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RL A -- Rotate A left through C-flag
    prev = [state getA] << 1;
    C = (bool)([state getA] & 0b10000000);
    // Set LSb of A to its previous C-value
    [state getCFlag] ? [state setA:(prev | 1)] : [state setA:(prev & 0b11111110)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB17 -- RL A -- A was 0x%02x; A is now 0x%02x\n", prev, [state getA]);
};
void (^execute0xcb18Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RR B -- Rotate B right through C-flag
    prev = [state getB] >> 1;
    C = (bool)([state getB] & 0b00000001);
    // Set MSb of B to its previous C-value
    [state getCFlag] ? [state setB:(prev | 0b10000000)] : [state setB:(prev & 0b01111111)];
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB18 -- RR B -- B was 0x%02x; B is now 0x%02x\n", prev, [state getB]);
};
void (^execute0xcb19Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RR C -- Rotate C right through C-flag
    prev = [state getC] >> 1;
    C = (bool)([state getC] & 0b00000001);
    // Set MSb of C to its previous C-value
    [state getCFlag] ? [state setC:(prev | 0b10000000)] : [state setC:(prev & 0b01111111)];
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB19 -- RR C -- C was 0x%02x; C is now 0x%02x\n", prev, [state getC]);
};
void (^execute0xcb1AInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RR D -- Rotate D right through C-flag
    prev = [state getD] >> 1;
    C = (bool)([state getD] & 0b00000001);
    // Set MSb of D to its previous C-value
    [state getCFlag] ? [state setD:(prev | 0b10000000)] : [state setD:(prev & 0b01111111)];
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB1A -- RR D -- D was 0x%02x; D is now 0x%02x\n", prev, [state getD]);
};
void (^execute0xcb1BInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RR E -- Rotate E right through C-flag
    prev = [state getE] >> 1;
    C = (bool)([state getE] & 0b00000001);
    // Set MSb of E to its previous C-value
    [state getCFlag] ? [state setE:(prev | 0b10000000)] : [state setE:(prev & 0b01111111)];
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB1B -- RR E -- E was 0x%02x; E is now 0x%02x\n", prev, [state getE]);
};
void (^execute0xcb1CInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RR H -- Rotate H right through C-flag
    prev = [state getH] >> 1;
    C = (bool)([state getH] & 0b00000001);
    // Set MSb of H to its previous C-value
    [state getCFlag] ? [state setH:(prev | 0b10000000)] : [state setH:(prev & 0b01111111)];
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB1C -- RR H -- H was 0x%02x; H is now 0x%02x\n", prev, [state getH]);
};
void (^execute0xcb1DInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RR L -- Rotate L right through C-flag
    prev = [state getL] >> 1;
    C = (bool)([state getL] & 0b00000001);
    // Set MSb of L to its previous C-value
    [state getCFlag] ? [state setL:(prev | 0b10000000)] : [state setL:(prev & 0b01111111)];
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB1D -- RR L -- L was 0x%02x; L is now 0x%02x\n", prev, [state getL]);
};
void (^execute0xcb1EInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RR (HL) -- Rotate (HL) right through C-flag
    prev = ram[(unsigned short)[state getHL_big]] >> 1;
    C = (bool)(ram[(unsigned short)[state getHL_big]] & 0b00000001);
    // Set MSb of (HL) to its previous C-value
    [state getCFlag] ? (ram[(unsigned short)[state getHL_big]] = (prev | 0b10000000)) :
    (ram[(unsigned short)[state getHL_big]] = (prev & 0b01111111));
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB1E -- RR (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n",
             prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0xcb1FInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    int8_t prev = 0;
    bool C = false;

    // RR A -- Rotate A right through C-flag
    prev = [state getA] >> 1;
    C = (bool)([state getA] & 0b00000001);
    // Set MSb of A to its previous C-value
    [state getCFlag] ? [state setA:(prev | 0b10000000)] : [state setA:(prev & 0b01111111)];
    [state setFlags:false
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB1F -- RR A -- A was 0x%02x; A is now 0x%02x\n", prev, [state getA]);
};