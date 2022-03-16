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

 ifdef _HCS12_SERIALMON
            ORG $3FFF - (RAMEnd - RAMStart)
 else
            ORG RAMStart
 endif
 ; Insert here your data definition.

 ;a) The memory allocation for the BCD number. Four bytes are allocated

BCDNum:   DS.B   4

;b) PORT P data to enable LED#0 -  LED #3
PORTP_Data:  DC.B %00001110, %00001101, %00001011, %00000111 

     
;c) This table contains the hex-value for PORT B to represent the digit 0-9. For example, $3F will display the digit  '0 ' on the 7-seg LED, $6F will display the digit ' 9' on the 7-seg LED

LED_Data:    DC.B $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F

;d)	Interrupt Vector Address and Interrupt Vector
         ORG	   $FFCC                         ; $FFCC is a Push button interrupt vector address

        ;************** complete Here ***************
        ; Provide your Interrupt Vector ( It holds the starting address of your interrupt routine )

        ;***************************************

  


; code section
            ORG   ROMStart

;***************************************
;II.	Main Program:
;***************************************

Entry:
_Startup:
            ; remap the RAM &amp; EEPROM here. See EB386.pdf
 ifdef _HCS12_SERIALMON
            ; set registers at $0000
            CLR   $11                  ; INITRG= $0
            ; set ram to end at $3FFF
            LDAB  #$39
            STAB  $10                  ; INITRM= $39

            ; set eeprom to end at $0FFF
            LDAA  #$9
            STAA  $12                  ; INITEE= $9


            LDS   #$3FFF+1        ; See EB386.pdf, initialize the stack pointer
 else
            LDS   #RAMEnd+1       ; initialize the stack pointer
 endif
   
; complete code below 

           ;1) Enable Global interrupt capability
           CLI                   


           ;2)Configure I/O PORTs (PORT B, P, J ,and PORT H)
           BSET DDRB, %11111111
           BSET DDRP, %00001111
           BSET DDRJ, %00000010
           BCLR DDRH, %11111111
            
            
           ;3)	Disable flashing LEDs by setting a value 1 in Bit 1 in PORT J.	
            BSET PTJ, %00000010
            
            

           ;4) Enable PORT H interrupt Enable Bits (PIEH) for Button 0 , Button 1, and Button2

            BSET  PIEH, %00000111
	          
	          
	          
	          
           ;5) Intialize the number to dispaly: '0 0 0 0'
          
             CLR   BCDNum
             CLR   BCDNum+1
             CLR   BCDNum+2
             CLR   BCDNum+3
             
             
             
; 5) Loop Forever:  Dispaly the each BCD digit onto the four 7-seg LEDs.
;    You can use the part of Lab 7 code here to display the BCD number on to the four 7-segment LEDs 
;    Add code here               
            Forever: LDX #BCDNum ;Register X holds the beginning address of BCD number
                     LDY #LED_Data

                     LEDLoop: LDAA 0,X
                              LDAB A,Y
                              STAB PORTB

                              MOVB 4,X, PTP

                              PSHY
                              LDY #1
                              JSR Delay_Yms
                              PULY

                              INX
                              CPX #BCDNum+4
                              BLO LEDLoop
                              BRA Forever



 ;***************************************         
 ;III. Interrupt Service Routine   -Complter code below 
 ;***************************************         
          
ISR_PSHBUTTN:          ;Begining of the interupt service routine

            BRCLR PIFH, %00000001, CHKButton1
            LDY #20
            JSR Delay_Yms
            BSET PIFH, %00000001
            
            LDAB  BCDNum+3
            JSR INCNum
            STAB  BCDNum+3
            CMPB #00
            LBNE Done         
         
            LDAB  BCDNum+2
            JSR INCNum
            STAB  BCDNum+2
            CMPB #00
            LBNE Done          
         
            LDAB  BCDNum+1
            JSR INCNum
            STAB  BCDNum+1
            CMPB #00
            LBNE Done          
         
            LDAB  BCDNum
            JSR INCNum
            STAB  BCDNum
            LBRA Done 

CHKButton1:   
            BRCLR PIFH, %00000010, CHKButton2         
            LDY #20
            JSR Delay_Yms
            BSET PIFH, %00000010         
         
            LDAB  BCDNum+3
            JSR DECNum
            STAB  BCDNum+3
            CMPB #09
            LBNE Done         
         
            LDAB  BCDNum+2
            JSR DECNum
            STAB  BCDNum+2
            CMPB #09
            LBNE Done          
         
            LDAB  BCDNum+1
            JSR DECNum
            STAB  BCDNum+1
            CMPB #09
            LBNE Done          
         
            LDAB  BCDNum
            JSR DECNum
            STAB  BCDNum
            LBRA Done          
         

CHKButton2:   
            LDY #20
            JSR Delay_Yms
            BSET PIFH, %00000010      
            BSET PIFH, %00000100 
            CLR   BCDNum
            CLR   BCDNum+1
            CLR   BCDNum+2
            CLR   BCDNum+3
            LBRA Done  
       
       
       
       
       
       
       
            

   
Done:        RTI  ;end of the interupt service routine 





;********************************************************
; Input: B: BCD number
; Output: B: (B)+1 if (B) < 9, else B=0
;*******************************************************
INCNum:
   	       INCB
   	       CMPB   #9
	         BHI CARRY1    ; register B has the value(10) > 9
	         
	        BRA END_SUBI 	
CARRY1:   LDAB #0
END_SUBI: RTS	



;***************************************************
; Input: B: BCD number
; Output: B: (B)-1 if (B) > 0 else B= 9
;***************************************************
DECNum     
             CMPB 	#0
	           BLS    BORROW1   ; if register B has value 0, then go to BORROW1
	           
	           DECB
	           BRA    END_SUBD	
	           	
BORROW1:     LDAB #9

END_SUBD:     RTS
                             




;***************************************************
; Input: Y: Y ms delay
; ***************************************************           
Delay_Yms:                                 ; subroutine to make a delay of Y ms
            PSHX                         ; save X register 

outerloop: 
              
              LDX #1000
 
innerloop:    PSHA                        ; 2 E cycles
              PULA                        ; 3 E cycles
              PSHA                        ; 2 E cycles
              PULA                        ; 3 E cycles
              PSHA                       ; 2 E cycles
              PULA                       ; 3 E cycles
              PSHA                       ; 2 E cycles
              PULA                       ; 3 E cycles
              nop                        ; 1 E cycle
              DBNE X,innerloop        ; 3 E cycles
    
              DBNE Y, outerloop
              PULX                       
              RTS          