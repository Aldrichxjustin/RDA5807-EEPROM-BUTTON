single assembly language code for RDA5807 family FM tuner.
EEPROM for storing last used channel and volume information. 
Two buttons for controlling volume and channel.

PIN ASSIGNMENT FOR PIC10F2XX
sda         EQU    GP2    ;SDA pin of the I2C
scl         EQU    GP1    ;SCL pin of the I2C
but_up      EQU    GP3    ;Button Volume up/Next station
but_down    EQU    GP0    ;Button Volume down/Previous station
