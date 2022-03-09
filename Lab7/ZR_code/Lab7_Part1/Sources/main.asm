;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000  ; absolute address to place my code/constant data

; variable/data section

            ORG RAMStart
 ; Insert here your data definition.
Array1: DC.B $64, $45, $22, $25, $52, $66, $48, $53, $50,$AF
N EQU 10

; The memory allocation for the BCD number for the array maximum
            ORG $1010
BCDNum: DS.B 4

;PORT P data to enable the 7-segment LED#0 - LED #3
PORTP_Data: DC.B %00001110, %00001101, %00001011, %00000111 

LED_Data: DC.B $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F

; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer
            ;part 1
            LDAA  Array1
            LDX   #Array1+1
            LDAB  #N-1
Loop:       CMPA  X
            BHS   SKIP
            LDAA  X
SKIP:       INX
            DECB
            CMPB  #$00
            BNE Loop
            ;part 2
            TAB
            CLRA
            LDY #BCDNum+3
BCDLoop:    LDX #10
            IDIV
            STAB  Y
            DEY
            XGDX
            CPD $00
            BNE BCDLoop
            MOVB  $00, BCDNum
            ;part 3
            BSET DDRB, %11111111 
            BSET DDRJ, %00000010
            BSET DDRP, %00001111
            
            BSET PTJ, %00000010 ; Disable eight flashing LEDs
            Forever: LDX #BCDNum
            LDY #LED_Data
              LEDLoop: 
                LDAA X
                LDAB A,Y
                STAB PORTB
                MOVB 4,X, PTP
                
                PSHY
                LDY #1
                JSR Delay
                PULY
                INX
                CPX #BCDNum+4
                BLO LEDLoop

            BRA Forever
            
Delay: PSHX

       OuterLoop: LDX #1000

                  InnerLoop: PSHA
                             PULA
                             PSHA
                             PULA
                             PSHA
                             PULA
                             PSHA
                             PULA 
                             nop
                             DBNE X, InnerLoop
      
       DBNE Y,OuterLoop
       PULX
       RTS 