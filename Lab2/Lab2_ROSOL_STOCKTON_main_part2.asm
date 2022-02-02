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
             
 operandA: DC.B $9C
 operandB: DC.B $B5
 Result1: DS.B 1
 operandC: DC.B $3E
 operandD: DC.B $F7
 Result2: DS.B 1

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
            ABA
            STAA Result2
endmain: BRA endmain
            


