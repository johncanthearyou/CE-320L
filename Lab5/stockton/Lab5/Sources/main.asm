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
     Array1: DC.B $11, $22, $11, $22, $22, $66, $77, $88, $99, $10
         N1: equ 10
    
     Array2: DC.B $33, $10, $FE, $09, $FF
         N2: equ 5
    
     Array3: DC.B $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C
         N3: equ 12


             ORG $1020
Array1_mean: DS.B 2 
Array2_mean: DS.B 2 
Array3_mean: DS.B 2


; code section
            ORG   ROMStart
Entry:
_Startup:
            LDS #RAMEnd+1       ; initialize the stack pointer
            
            LDX #Array1 
            LDY #N1
            JSR MyAvg
            STD Array1_mean
            
            LDX #Array2
            LDY #N2
            JSR MyAvg
            STD Array2_mean
            
            LDX #Array3 
            LDY #N3
            JSR MyAvg
            STD Array3_mean
            
   Endmain: BRA Endmain
   
MyAvg:      CLRA
            CLRB
            PSHY
      Loop: CPY #00
            BEQ ExitLoop
            ADDB 0,X
            ADCA #$00
            INX
            DEY
            BRA Loop
            
  ExitLoop: PULX
            IDIV
            XGDX
            RTS
