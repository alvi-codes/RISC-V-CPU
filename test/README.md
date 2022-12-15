# Test Results & Proof of Success - Pipleined
This page displays the test programmes used to verify our design and the resultant outputs seen on the waveform viewer that prooves the correctness of our CPU design implemnetation working as per the needs of this course work.

In addition, we have also added videos that show the outputs for the F1 Program driving the neopixel bar on VBuddy and the trace values for the Reference Program plotted on the VBuddy's TFT display.

# F1 Program

The program developed and used by the team:
```
main:
	jal a1, iloop
    nop
    nop
    addi a2, zero, 0x0
    beq a2, zero, 0
    nop 
    nop
    
iloop:
	lw a0, 0(zero)
    lw a0, 1(zero)
    lw a0, 2(zero)
    lw a0, 3(zero)
    lw a0, 4(zero)
    lw a0, 5(zero)
    lw a0, 6(zero)
    lw a0, 7(zero)
    nop
    nop
    nop
    lw a0, 8(zero)
    jalr a3, a1, 0
    nop 
    nop
    
 mloop:
 	beq a2, zero, mloop
    nop
    nop
    
```
Resultant waveform view from the `risc_v.vcd` file:
![Alt text](images/Screenshot_20221215_085344.png)
![Alt text](images/Screenshot_20221215_085419.png)
![Alt text](images/Screenshot_20221215_085428.png)

Outputs from `a0` driving the neopixel bar on VBuddy:

# Reference Program


