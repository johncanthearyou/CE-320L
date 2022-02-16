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
            ORG $1010
   HexData: DC.W $982D
   
            ORG $1020
    BCDNum: DS.B 5 


; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer
            
            ORG $4500
            
            CLR Y
            LDY #BCDNum+4 
            LDD HexData
            
 startLoop: CPY #BCDNum
            BLO endLoop
            LDX #10
            IDIV
            STAB Y
            XGDX
            DEY
            BRA startLoop
            
   endLoop: SWI