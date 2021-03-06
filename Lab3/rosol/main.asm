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
            ORG $1000
Length:     DC.B 8
Array:      DC.B 19,15,20,17,12,16,15, 10
Sum:        DS.B 1

; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer
            ORG $4100
            CLRA
            LDX #Array
            LDAB Length
beginLoop:  BEQ endLoop
            ADDA 0,X
            INX
            DECB
            BRA beginLoop
endLoop:    STAA Sum
endmain:    BRA endmain