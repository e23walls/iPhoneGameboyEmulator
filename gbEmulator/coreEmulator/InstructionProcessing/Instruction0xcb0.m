#import "emulatorMain.h"

void (^execute0xcb00Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RLC B -- Rotate B left
    prev = [state getB];
    C = [state getB] & 0b10000000;
    [state setB:([state getB] << 1)];
    [state setFlags:[state getB] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB00 -- RLC B -- B was 0x%02x; B is now 0x%02x\n", prev, [state getB]);
};
void (^execute0xcb01Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RLC C -- Rotate C left
    prev = [state getC];
    C = [state getC] & 0b10000000;
    [state setC:([state getC] << 1)];
    [state setFlags:[state getC] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB01 -- RLC C -- C was 0x%02x; C is now 0x%02x\n", prev, [state getC]);
};
void (^execute0xcb02Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RLC D -- Rotate D left
    prev = [state getD];
    C = [state getD] & 0b10000000;
    [state setD:([state getD] << 1)];
    [state setFlags:[state getD] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB02 -- RLC D -- D was 0x%02x; D is now 0x%02x\n", prev, [state getD]);
};
void (^execute0xcb03Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RLC E -- Rotate E left
    prev = [state getE];
    C = [state getE] & 0b10000000;
    [state setE:([state getE] << 1)];
    [state setFlags:[state getE] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB03 -- RLC E -- E was 0x%02x; E is now 0x%02x\n", prev, [state getE]);
};
void (^execute0xcb04Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RLC H -- Rotate H left
    prev = [state getH];
    C = [state getH] & 0b10000000;
    [state setH:([state getH] << 1)];
    [state setFlags:[state getH] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB04 -- RLC H -- H was 0x%02x; H is now 0x%02x\n", prev, [state getH]);
};
void (^execute0xcb05Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RLC L -- Rotate L left
    prev = [state getL];
    C = [state getH] & 0b10000000;
    [state setL:([state getL] << 1)];
    [state setFlags:[state getL] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB05 -- RLC L -- L was 0x%02x; L is now 0x%02x\n", prev, [state getL]);
};
void (^execute0xcb06Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RLC (HL) -- Rotate (HL) left
    prev = ram[(unsigned short)[state getHL_big]];
    C = ram[(unsigned short)[state getHL_big]] & 0b10000000;
    ram[(unsigned short)[state getHL_big]] = ram[(unsigned short)[state getHL_big]] << 1;
    [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB06 -- RLC (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0xcb07Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RLC A -- Rotate A left
    prev = [state getA];
    C = [state getA] & 0b10000000;
    [state setA:([state getA] << 1)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB07 -- RLC A -- A was 0x%02x; A is now 0x%02x\n", prev, [state getA]);
};
void (^execute0xcb08Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RRC B -- Rotate B right
    prev = [state getB];
    C = [state getB] & 0b00000001;
    [state setB:([state getB] >> 1)];
    [state setFlags:[state getB] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB08 -- RRC B -- B was 0x%02x; B is now 0x%02x\n", prev, [state getB]);
};
void (^execute0xcb09Instruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RRC C -- Rotate C right
    prev = [state getC];
    C = [state getC] & 0b00000001;
    [state setC:([state getC] >> 1)];
    [state setFlags:[state getC] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB09 -- RRC C -- C was 0x%02x; C is now 0x%02x\n", prev, [state getC]);
};
void (^execute0xcb0AInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RRC D -- Rotate D right
    prev = [state getD];
    C = [state getD] & 0b00000001;
    [state setD:([state getD] >> 1)];
    [state setFlags:[state getD] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB0A -- RRC D -- D was 0x%02x; D is now 0x%02x\n", prev, [state getD]);
};
void (^execute0xcb0BInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RRC E -- Rotate E right
    prev = [state getE];
    C = [state getE] & 0b00000001;
    [state setE:([state getE] >> 1)];
    [state setFlags:[state getE] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB0B -- RRC E -- E was 0x%02x; E is now 0x%02x\n", prev, [state getE]);
};
void (^execute0xcb0CInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RRC H -- Rotate H right
    prev = [state getH];
    C = [state getH] & 0b00000001;
    [state setH:([state getH] >> 1)];
    [state setFlags:[state getH] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB0C -- RRC H -- H was 0x%02x; H is now 0x%02x\n", prev, [state getH]);
};
void (^execute0xcb0DInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RRC L -- Rotate L right
    prev = [state getL];
    C = [state getL] & 0b00000001;
    [state setL:([state getL] >> 1)];
    [state setFlags:[state getL] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB0D -- RRC L -- L was 0x%02x; L is now 0x%02x\n", prev, [state getL]);
};
void (^execute0xcb0EInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RRC (HL) -- Rotate (HL) right
    prev = ram[(unsigned short)[state getHL_big]];
    C = ram[(unsigned short)[state getHL_big]] & 0b00000001;
    ram[(unsigned short)[state getHL_big]] = ram[(unsigned short)[state getHL_big]] >> 1;
    [state setFlags:ram[(unsigned short)[state getHL_big]] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB0E -- RRC (HL) -- (HL) was 0x%02x; (HL) is now 0x%02x\n", prev, ram[(unsigned short)[state getHL_big]]);
};
void (^execute0xcb0FInstruction)(RomState *,
                                int8_t *,
                                bool *,
                                int8_t *) =
^(RomState * state,
  int8_t * ram,
  bool * incrementPC,
  int8_t * interruptsEnabled)
{
    bool C = false;
    int8_t prev = 0;

    // RRC A -- Rotate A right
    prev = [state getA];
    C = [state getA] & 0b00000001;
    [state setA:([state getA] >> 1)];
    [state setFlags:[state getA] == 0
                  N:false
                  H:false
                  C:C];
    PRINTDBG("0xCB0F -- RRC A -- A was 0x%02x; A is now 0x%02x\n", prev, [state getA]);
};