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
   LedData: DC.B $4F,$0E ; %00001110=$0E
            DC.B $66,$0D ; %00001101=$0D               
            DC.B $6D,$0B ; %00001011=$0B
            DC.B $7D,$07 ; %00000111=$07


; code section
            ORG   ROMStart

Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer
            
            ;Init I/O ports
            BSET DDRB, %11111111
            BSET DDRP, %00000010
            BSET DDRJ, %00001111
            
            ; Disable LEDs
            BSET PTJ, %00000010
            
            Forever: LDX #LedData
             
                     Loop: MOVB 1,X+, PORTB
                           MOVB 1,X+, PTP
                           LDY #1
                           JSR Delay
                           CPX #LedData +8
                           BLO Loop

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