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
 ORG $3000
operandA: DC.B $9C ;operandA is a meaningful name of the memory address $3000
operandB: DC.B $B5 ;operandB is a meaningful name of the memory address $3001
Result1: DS.B 1 ;Result1 is a meaningful name of the memory address $3002
operandC: DC.B $3E ;operandC is a meaningful name of the memory address $3003
operandD: DC.B $F7 ;operandD is a meaningful name of the memory address $3004
Result2: DS.B 1 ;Result2 is a meaningful name of the memory address $3005


; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer
            ORG $4100
            LDAA operandA
            LDAB operandB
            ABA
            STAA Result1
            LDAA operandC
            LDAB operandD
            SBA
            STAA Result2
endmain:    BRA endmain
