;==========================================================================
; TITLE      PIC20X+PIC12F50X+RDA5807M+24C02+Button                       =
; SUBTITLE   PIC10F200,F202,F204,F206,F220,F222,12F508,12F509 & 12F510    =
; CONTENTS:  I²C RDA5807M + Button Control                                =
; EDITOR:    @mit41301                                                    =
; UPDATED:   01/09/2025                                                   =
;==========================================================================
 
 ifdef __10F200
 include "p10F200.inc"
 list    p=10F200
RAM     SET  H'0010'
MAXRAM  EQU  H'001F'
 __CONFIG _IntRC_OSC & _WDT_OFF & _CP_OFF & _MCLRE_OFF
 __idlocs H'F200'
sda         EQU    GP2    ;SDA pin of the I2C
scl         EQU    GP1    ;SCL pin of the I2C
but_up      EQU    GP3    ;Button Volume up/Next station
but_down    EQU    GP0    ;Button Volume down/Previous station
 endif
;==========================================================================
 ifdef __10F202
 include "p10F202.inc"
 list    p=10F202
RAM     EQU  h'0008'
MAXRAM  EQU  H'001F'
 __CONFIG _IntRC_OSC & _WDT_OFF & _CP_OFF & _MCLRE_OFF
 __idlocs H'F202'
sda         EQU    GP2    ;SDA pin of the I2C
scl         EQU    GP1    ;SCL pin of the I2C
but_up      EQU    GP3    ;Button Volume up/Next station
but_down    EQU    GP0    ;Button Volume down/Previous station
 endif
;==========================================================================
 ifdef __10F204
 include "p10F204.inc"
 list    p=10F204
RAM  	EQU  H'0010'
MAXRAM  EQU  H'001F'
 __CONFIG _IntRC_OSC & _WDT_OFF & _CP_OFF & _MCLRE_OFF
 __idlocs H'F204'
sda         EQU    GP2    ;SDA pin of the I2C
scl         EQU    GP1    ;SCL pin of the I2C
but_up      EQU    GP3    ;Button Volume up/Next station
but_down    EQU    GP0    ;Button Volume down/Previous station
 endif
;==========================================================================
 ifdef __10F206
 include "p10F206.inc"
 list    p=10F206
RAM  	EQU  h'0008'
MAXRAM  EQU  H'001F'
 __CONFIG _IntRC_OSC & _WDT_OFF & _CP_OFF & _MCLRE_OFF
 __idlocs H'F206'
sda         EQU    GP2    ;SDA pin of the I2C
scl         EQU    GP1    ;SCL pin of the I2C
but_up      EQU    GP3    ;Button Volume up/Next station
but_down    EQU    GP0    ;Button Volume down/Previous station
 endif
;==========================================================================
 ifdef __10F220
 include "p10F220.inc"
 list    p=10F220
RAM  	EQU  H'0010'
MAXRAM  EQU  H'001F'
 __CONFIG _IOSCFS_4MHZ & _WDT_OFF & _CP_OFF & _MCLRE_OFF
 __idlocs H'F220'
sda         EQU    GP2    ;SDA pin of the I2C
scl         EQU    GP1    ;SCL pin of the I2C
but_up      EQU    GP3    ;Button Volume up/Next station
but_down    EQU    GP0    ;Button Volume down/Previous station
 endif
;==========================================================================
 ifdef __10F222
 include "p10F222.inc"
 list    p=10F222
RAM  	EQU  h'0009'
MAXRAM  EQU  H'001F'
 __CONFIG _IOSCFS_4MHZ & _WDT_OFF & _CP_OFF & _MCLRE_OFF
 __idlocs H'F222'
sda         EQU    GP2    ;SDA pin of the I2C
scl         EQU    GP1    ;SCL pin of the I2C
but_up      EQU    GP3    ;Button Volume up/Next station
but_down    EQU    GP0    ;Button Volume down/Previous station
 endif
;========================================================================== 
 ifdef __12F508
 include "p12F508.inc"
 list    p=12F508
RAM  	EQU  h'0007'
MAXRAM  EQU  H'001F'
 __CONFIG _IntRC_OSC & _WDT_OFF & _CP_OFF & _MCLRE_OFF
 __idlocs H'F508'
but_up     EQU    GP0    ;Button Volume up/Next station
but_down   EQU    GP1    ;Button Volume down/Previous station
scl        EQU    GP4    ;SCL pin of the I²C Bus
sda        EQU    GP5    ;SDA pin of the I²C Bus
 endif
;==========================================================================
 ifdef   __12F509
 include "p12F509.inc"
 list    p=12F509
RAM  	EQU  H'0007'
MAXRAM  EQU  H'003F'
 __CONFIG _IntRC_OSC & _WDT_OFF & _CP_OFF & _MCLRE_OFF
 __idlocs H'F509'
but_up     EQU    GP0    ;Button Volume up/Next station
but_down   EQU    GP1    ;Button Volume down/Previous station
scl        EQU    GP4    ;SCL pin of the I²C Bus
sda        EQU    GP5    ;SDA pin of the I²C Bus
 endif
;==========================================================================
 ifdef   __12F510
 include "p12F510.inc"
 list    p=12F510
RAM  	EQU  H'000A'
MAXRAM  EQU  H'003F'
 __CONFIG _IntRC_OSC & _WDT_OFF & _CP_OFF & _MCLRE_OFF & _IOSCFS_OFF
 __idlocs H'F510'
but_up     EQU    GP0    ;Button Volume up/Next station
but_down   EQU    GP1    ;Button Volume down/Previous station
scl        EQU    GP4    ;SCL pin of the I²C Bus
sda        EQU    GP5    ;SDA pin of the I²C Bus
 endif

 errorlevel +305

;**************************************************************************
; File register usage                                                     *
;**************************************************************************

		cblock RAM
i           ;EQU    010h    ;Delay variable
j           ;EQU    011h    ;Delay variable
bit_count   ;EQU    012h    ;Counter of processed bits in I2C
i2c_data    ;EQU    013h    ;Data to receive/transmit via I2C
port        ;EQU    014h    ;Helper register to implement I2C
ack         ;EQU    015h    ;Acknowledgment received from the device
volume      ;EQU    016h    ;Radio volume level
frequency_l ;EQU    017h    ;Frequency low byte
frequency_h ;EQU    018h    ;Frequency high byte
count       ;EQU    019h    ;Stores the time the button is pressed
button      ;EQU    01Ah    ;The number of button that is pressed
startup     ;EQU    01Bh    ;Indicates if it's the startup state
timer       ;EQU    01Ch    ;Counts time before storing the station
need_save   ;EQU    01Dh    ;Indicates if current station need to be saved
RAM_		
		endc

     	if RAM_ > MAXRAM
     	error "File register usage overflow"
     	endif

	ORG 0X00 ;added by @mit41301

    andlw   ~1
;    andlw   B'11111110' ;~1
    movwf   OSCCAL
 ifdef __10F204
    movlw  B'00000000'	 ;Use as Digital I/O 
    movwf  CMCON0		 ;Disable Digital Comparator function
 endif

 ifdef __10F206
    movlw  B'00000000'   ;Use as Digital I/O 
    movwf  CMCON0		 ;Disable Digital Comparator function
 endif
 ifdef __10F220
    movlw  B'00000000'   ;Use as Digital I/O 
    movwf  ADCON0		 ;Disable Digital Comparator function
 endif
 ifdef __10F222
    movlw  B'00000000'   ;Use as Digital I/O 
    movwf  ADCON0		 ;Disable Digital Comparator function
 endif
 ifdef __12F510
    movlw  B'00000000'   ;Use as Digital I/O 
    movwf  CM1CON0		 ;Disable Digital Comparator function
    movlw  B'00000000'   ;Use as Digital I/O 
    movwf  ADCON0		 ;Disable ADC function
 endif
INIT:
    MOVLW ~((1<<T0CS)|(1<<NOT_GPPU))
    OPTION              ;Enable GPIO2 and pull-ups
    MOVLW 0x3F          ;Save 0x0F into 'port' register
    MOVWF port          ;It's used to switch SDA/SCL pins direction
    TRIS  GPIO           ;Set all pins as inputs
;#######################################################################
    MOVLW 0xFF          ;Perform 200 ms delay
    CALL DELAY          ;to let the power stabilize

    MOVLW 0xFF          ;Perform 400 ms delay
    CALL  DELAY         ;to let the power stabilize

    MOVLW 0xFF          ;Perform 600 ms delay
    CALL  DELAY         ;to let the power stabilize

    MOVLW 0xFF          ;Perform 800 ms delay
    CALL  DELAY         ;to let the power stabilize

;    MOVLW 0xFF          ;Perform 200 ms delay
;    CALL  DELAY          ;to let the power stabilize
;#######################################################################

    CLRF GPIO           ;Clear GPIO to set all pins to 0
    CLRF need_save      ;No need to save the station for now
    BSF startup, 0      ;Set 'startup' to 1 to indicate startup state

READ_EEPROM:            ;Reading the stored data from EEPROM
    CALL I2C_START      ;Issue I2C start condition
    MOVLW 0xA0          ;EEPROM chip address for writing is 0xA0
    CALL I2C_WRITE_BYTE ;Write the EEPROM address via I2C
    MOVLW 0x00          ;Set the EEPROM memory address to be read
    CALL I2C_WRITE_BYTE ;And write it via I2C
    CALL I2C_START      ;Issue I2C repeated start condition
    MOVLW 0xA1          ;EEPROM chip address for reading is 0xA1
    CALL I2C_WRITE_BYTE ;Write EEPROM address via I2C
    CALL I2C_READ_BYTE  ;Read the EEPROM value at address 0x00
    CALL I2C_ACK        ;Issue acknowledgement
    MOVF i2c_data, W    ;Copy the 'i2c_data' into W register
    MOVWF volume        ;And store it into 'volume' register
    CALL I2C_READ_BYTE  ;Read the next EEPROM address
    CALL I2C_ACK
    MOVF i2c_data, W
    MOVWF frequency_l   ;and store its content into 'frequency_l'
    CALL I2C_READ_BYTE  ;Read the next EEPROM address
    CALL I2C_NACK       ;Issue Not acknowledgement, it's the last byte
    MOVF i2c_data, W
    MOVWF frequency_h   ;and store its content into 'frequency_h'
    CALL I2C_STOP       ;Issue Stop condition

    MOVLW 0xC0          ;Implement AND operation between 0xC0
    ANDWF frequency_l, F;and 'frequency_l' to clear its last 6 bits
    BSF frequency_l, 4  ;Set bit 4 (Tune) to adjust the frequency

START_RADIO:            ;Start FM radio
    CALL I2C_START      ;Issue I2C Start condition
    MOVLW 0x20          ;Radio chip address for sequential writing is 0x20
    CALL I2C_WRITE_BYTE ;Write the radio address via i2C
    MOVLW 0xC0          ;Write high byte into radio register 0x02
;	MOVLW 0xD0 ; added by Tony to enable BASS 
    CALL I2C_WRITE_BYTE
    MOVLW 0x01          ;Write low byte into radio register 0x02
    CALL I2C_WRITE_BYTE
    MOVF frequency_h, W ;Write high byte into radio register 0x03
    CALL I2C_WRITE_BYTE
    MOVF frequency_l, W ;Write low byte into radio register 0x03
    CALL I2C_WRITE_BYTE
    CALL I2C_STOP       ;Issue I2C Stop condition

    MOVLW 0x0F          ;Implement AND operation between 0xC0
    ANDWF volume, F     ;and 'volume' to clear its higher 4 bits
    BSF volume, 7       ;Set bit 7  to select correct LNA input
    GOTO SET_VOLUME     ;And go to the 'SET_VOLUME' label

LOOP:                   ;Main loop of the program
    ;Beginning of the button 1 checking
    CALL CHECK_BUTTONS  ;Read the buttons state
    ANDLW 3             ;Clear all the bits of the result except two LSBs
    BTFSC STATUS, Z     ;If result is 0 (none of buttons were pressed)
    GOTO WAIT_FOR_TIMER ;Then go to the 'WAIT_FOR_TIMER' label 
    MOVLW 40            ;Otherwise load initial value for the delay  
    CALL DELAY          ;and perform the debounce delay
    CALL CHECK_BUTTONS  ;Then check the buttons state again
    ANDLW 3
    BTFSC STATUS, Z     ;If result is 0 (none of buttons were pressed)
    GOTO WAIT_FOR_TIMER ;Then go to the 'WAIT_FOR_TIMER' label
    MOVWF button        ;Save the W value into the 'button'
    CLRF count          ;clear loop counter
BUTTONS_LOOP:           ;Loop while button is pressed
    MOVLW 0xFF          ;Load initial value for the delay 200ms
    CALL DELAY          ;And perform the delay
    CALL CHECK_BUTTONS  ;Then check the buttons state again
    ANDLW 3
    BTFSC STATUS, Z     ;If state is 0 (it was a short press)
    GOTO CHANNEL_SEEK    ;Go to the 'CHANNEL_SEEK' label
    INCF count, F       ;Otherwise (long press) increment the counter
    BTFSS button, 0     ;Check the last bit of the 'button' register
    GOTO DECREASE_VOLUME;If it's 0 (Down), go to 'DECREASE_VOLUME'
INCREASE_VOLUME:        ;Otherwise start 'INCREASE_VOLUME'
    INCF volume, F      ;Increment the 'volume' register
    BTFSC volume, 4     ;If bit 4 becomes set (volume = 0b10010000)
    DECF volume, F      ;then decrement the 'volume' to get 0b10001111
    GOTO SET_VOLUME     ;and go to the 'SET_VOLUME' label
DECREASE_VOLUME:        ;Decrease the volume here
    DECF volume, F      ;Decrement the 'volume' register
    BTFSS volume, 7     ;If bit 7 becomes 0 (volume = 0b01111111)
    INCF volume, F      ;then increment the 'volume' to get 0b10000000
SET_VOLUME:             ;Set the radio volume
    CALL I2C_START      ;Issue I2C start condition
    MOVLW 0x22          ;Radio chip address for random writing is 0x22
    CALL I2C_WRITE_BYTE ;Write the radio address via I2C
    MOVLW 0x05          ;Set the register number to write to (0x05)
    CALL I2C_WRITE_BYTE ;And write it via I2C
    MOVLW 0x88          ;Set the high byte of 0x05 register (default value)
    CALL I2C_WRITE_BYTE ;And write it via i2C
    MOVF volume, W      ;Set the 'volume' as low byte of 0x05 register
    CALL I2C_WRITE_BYTE ;And write it via I2C
    CALL I2C_STOP       ;Issue Stop condition
    BTFSS startup, 0    ;If 'startup' is 0 (not startup condition)
    GOTO BUTTONS_LOOP   ;Then return to the 'BUTTONS_LOOP' label
    BCF startup, 0      ;Otherwise reset the 'startup' register
    GOTO LOOP           ;And return to the 'LOOP' label
CHANNEL_SEEK:           ;Here button is released and we check what to do
    MOVF count, F       ;Check if 'count' register is 0
    BTFSS STATUS, Z     ;If 'count' is not 0 (it was a long press)
    GOTO SAVE_VOLUME    ;then go to the 'SAVE VOLUME' label
    CLRF timer          ;Otherwise (short press) we clear the 'timer'
    BSF need_save, 0    ;And set the 'need_save' register
    CALL I2C_START      ;Issue I2C Start condition
    MOVLW 0x20          ;Radio chip address for sequential writing is 0x20
    CALL I2C_WRITE_BYTE ;Write the radio address via I2C
    BTFSS button, 0     ;Check the last bit of the 'button' register
    GOTO SEEK_DOWN      ;If it's 0 (button Down), go to 'SEEK_DOWN' label
    MOVLW 0xC3          ;Otherwise set 0xC3 as high byte of 0x02 register
    CALL I2C_WRITE_BYTE ;And write it via I2C
    MOVLW 0x01          ;Set 0x01 as low byte of 0x02 register
    CALL I2C_WRITE_BYTE ;And write it via I2C
    CALL I2C_STOP       ;Issue I2C Stop condition
    GOTO WAIT_FOR_TIMER ;And go to the 'WAIT_FOR_TIMER' label
SEEK_DOWN:              ;Seek the station down
    MOVLW 0xC1          ;Set 0xC1 as high byte of 0x02 register
    CALL I2C_WRITE_BYTE ;Ending of previous transaction
    MOVLW 0x01          ;Set 0x01 as low byte of 0x02 register
    CALL I2C_WRITE_BYTE ;And write it via I2C
    CALL I2C_STOP       ;Issue I2C Stop condition
    GOTO WAIT_FOR_TIMER ;And go to the 'WAIT_FOR_TIMER' label

SAVE_VOLUME:            ;Save the volume to the EEPROM
    CALL I2C_START      ;Issue I2C start condition
    MOVLW 0xA0          ;Set the EEPROM chip address to write
    CALL I2C_WRITE_BYTE ;And write it via I2C
    MOVLW 0x00          ;Set the EEPROM register address to write as 0x00
    CALL I2C_WRITE_BYTE ;And write it via I2C
    MOVF volume, W      ;Set the 'volume' as value to write to EEPROM
    CALL I2C_WRITE_BYTE ;And write it via I2C
    CALL I2C_STOP       ;Issue I2C stop condition
    GOTO LOOP           ;And return to the 'LOOP' labe;

WAIT_FOR_TIMER:         ;Wait for 10 second to save the channel to EEPROM
    MOVLW 45            ;Set the delay about 40 ms
    CALL DELAY          ;And call the DELAY subroutine
    INCFSZ timer, F     ;Increase the 'timer' and check while it becomes 0
    GOTO LOOP           ;If it's not 0 then return to the 'LOOP' label

    BTFSS need_save, 0  ;Otherwise check the 'need_save' register
    GOTO LOOP           ;If it's 0 then return to the 'LOOP' register
    BCF need_save, 0    ;Otherwise clear the 'need_save' register
    CALL I2C_START      ;Issue I2C start condition
    MOVLW 0x22          ;Set the radic chip address for random writing
    CALL I2C_WRITE_BYTE ;And write it via I2C
    MOVLW 0x03          ;Set the radio register to read from (0x03)
    CALL I2C_WRITE_BYTE ;And write it via I2C
    CALL I2C_START      ;Issue I2C Repeated start condition
    MOVLW 0x23          ;Set the radio chip address for random reading
    CALL I2C_WRITE_BYTE ;And write it via I2C
    CALL I2C_READ_BYTE  ;Read the high byte of the register 0x03
    CALL I2C_ACK        ;Issue the Acknowledgement
    MOVF i2c_data, W    ;Copy the 'i2c_data' content into W register
    MOVWF frequency_h   ;And save it to the 'frequency_h' register
    CALL I2C_READ_BYTE  ;Read the low byte of the register 0x03
    CALL I2C_NACK       ;Issue the Not acknowledgement
    MOVF i2c_data, W    ;Copy the 'i2c_data' content into W register
    MOVWF frequency_l   ;And save it to the 'frequency_l' register
    CALL I2C_STOP       ;Issue I2C stop condition

    CALL I2C_START      ;Issue I2C start condition
    MOVLW 0xA0          ;Set the EEPROM chip address for writing
    CALL I2C_WRITE_BYTE ;And write it via I2C
    MOVLW 0x01          ;Set the EEPROM memory address for writing as 0x01
    CALL I2C_WRITE_BYTE ;And write it via I2C
    MOVF frequency_l, W ;Load the 'frequency_l' content
    CALL I2C_WRITE_BYTE ;And write it via I2C to the address 0x01
    BCF frequency_h, 7  ;Some weird thing, this bit is set for some reason
    MOVF frequency_h, W ;Load the 'frequency_2' content
    CALL I2C_WRITE_BYTE ;And write it via I2C to the address 0x02
    CALL I2C_STOP       ;Issue I2C Stop condition

    GOTO LOOP           ;loop forever

;-------------Check buttons---------------
CHECK_BUTTONS:
    BTFSS GPIO, but_up  ;Check if button Up is pressed
    RETLW 1             ;and return 1 (b'01')
    BTFSS GPIO, but_down;Check if button Down is pressed
    RETLW 2             ;and return 2 (b'10')
    RETLW 0             ;If none of buttons is pressed then return 0
;-------------Helper subroutines---------------
SDA_HIGH:               ;Set SDA pin high
    BSF port, sda       ;Set 'sda' bit in the 'port' to make it input
    MOVF port, W        ;Copy 'port' into W register
    TRIS GPIO           ;And set it as TRISGPIO value
    RETLW 0

SDA_LOW:                ;Set SDA pin low
    BCF port, sda       ;Reset 'sda' bit in the 'port' to make it output
    MOVF port, W        ;Copy 'port' into W register
    TRIS GPIO           ;And set it as TRISGPIO value
    RETLW 0

SCL_HIGH:               ;Set SCL pin high
    BSF port, scl       ;Set 'scl' bit in the 'port' to make it input
    MOVF port, W        ;Copy 'port' into W register
    TRIS GPIO           ;And set it as TRISGPIO value
    RETLW 0

SCL_LOW:                ;Set SCL pin low
    BCF port, scl       ;Reset 'scl' bit in the 'port' to make it output
    MOVF port, W        ;Copy 'port' into W register
    TRIS GPIO           ;And set it as TRISGPIO value
    RETLW 0

;-------------I2C start condition--------------
I2C_START:
    CALL SCL_HIGH       ;Set SCL high
    CALL SDA_LOW        ;Then set SDA low
    RETLW 0
;-------------I2C stop condition---------------
I2C_STOP:
    CALL SDA_LOW        ;Set SDA low
    CALL SCL_HIGH       ;Set SCL high
    CALL SDA_HIGH       ;Then set SDA highs and release the bus
    RETLW 0
;------------I2C write byte--------------------
I2C_WRITE_BYTE:
    MOVWF i2c_data      ;Load 'i2c_data' from W register
    MOVLW 8             ;Load value 8 into 'bit_count'
    MOVWF bit_count     ;to indicate we're going to send 8 bits
I2C_WRITE_BIT:          ;Write single bit to I2C
    CALL SCL_LOW        ;Set SCL low, now we can change SDA
    BTFSS i2c_data, 7   ;Check the MSB of 'i2c_data'
    GOTO I2C_WRITE_0    ;If it's 0 then go to the 'I2C_WRITE_0' label
I2C_WRITE_1:            ;Else continue with 'I2C_WRITE_1'
    CALL SDA_HIGH       ;Set SDA high
    GOTO I2C_SHIFT      ;And go to the 'I2C_SHIFT' label
I2C_WRITE_0:
    CALL SDA_LOW        ;Set SDA low
I2C_SHIFT:
    CALL SCL_HIGH       ;Set SCL high to start the new pulse
    RLF i2c_data, F     ;Shift 'i2c_data' one bit to the left
    DECFSZ bit_count, F ;Decrement the 'bit_count' value, check if it's 0
    GOTO I2C_WRITE_BIT  ;If not then return to the 'I2C_WRITE_BIT'
I2C_CHECK_ACK:          ;Else check the acknowledgement bit
    CALL SCL_LOW        ;Set I2C low to end the last pulse
    CALL SDA_HIGH       ;Set SDA high to release the bus
    CALL SCL_HIGH       ;Set I2C high to start the new pulse
    MOVF GPIO, W        ;Copy the GPIO register value into the 'ack'
    MOVWF ack           ;Now bit 'sda' of the 'ack' will contain ACK bit
    CALL SCL_LOW        ;Set SCL low to end the acknowledgement bit
    RETLW 0
;------------I2C read byte--------------------
I2C_READ_BYTE:
    MOVLW 8             ;Load value 8 into 'bit_count'
    MOVWF bit_count     ;to indicate we're going to receive 8 bits
    CLRF i2c_data       ;Clear the 'i2c_data' register
I2C_READ_BIT:           ;Read single bit from the I2C
    RLF i2c_data, F     ;Shift the 'i2c_data' register one bit to the left
    CALL SCL_LOW        ;Set SCL low to prepare for the new bit
    CALL SCL_HIGH       ;Set SCL high to read the bit value
    BTFSC GPIO, sda     ;Check the 'sda' bit in the GPIO register
    BSF i2c_data, 0     ;if it's 1 then set the LSB of the 'i2c_data'
    DECFSZ bit_count, F ;Decrement the 'bit_count' value, check if it's 0
    GOTO I2C_READ_BIT   ;If not, then return to the 'I2C_READ_BIT'
    CALL SCL_LOW        ;Set SCL low to end the last pulse
    RETLW 0             ;Otherwise return from the subroutine
;----------I2C send ACK----------------------
I2C_ACK:
    CALL SDA_LOW        ;Set SDA low to issue ACK condition
    CALL SCL_HIGH       ;Set SCL high to start the new pulse
    CALL SCL_LOW        ;Set SCL low to end the pulse
    CALL SDA_HIGH       ;Set SDA high to release the bus
    RETLW 0
;----------I2C send NACK----------------------
I2C_NACK:
    CALL SDA_HIGH       ;Set SDA low to issue NACK condition
    CALL SCL_HIGH       ;Set SCL high to start the new pulse
    CALL SCL_LOW        ;Set SCL low to end the pulse
    RETLW 0

;-------------Delay subroutine--------------
DELAY:                  ;Start DELAY subroutine here  
    MOVWF i             ;Copy the value to the register i
    MOVWF j             ;Copy the value to the register j
DELAY_LOOP:             ;Start delay loop
    DECFSZ i, F         ;Decrement i and check if it is not zero
    GOTO DELAY_LOOP     ;If not, then go to the DELAY_LOOP label
    DECFSZ j, F         ;Decrement j and check if it is not zero
    GOTO DELAY_LOOP     ;If not, then go to the DELAY_LOOP label
    RETLW 0             ;Else return from the subroutine

;   END INIT            ; Program entry point.
    END                 ; Program entry point.